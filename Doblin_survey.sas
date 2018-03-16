/***********************************************************/
/* calculate some info for customer  */
/****************************************/
proc format;
	value freq
		1 = 1
		2 = 0.5
		3 = 0.25
		4 = 0.08333    /*1/12*/
		5 = 0.04166    /*1/24*/
		6 = 0.01923    /*1/52*/
		7,8,9 = 0
	;	
run;

proc format;
	value province
		1 = "Newfoundland"
		2 = "Nova Scotia"
		3 = "Prince Edward Island"
		4 = "New Brunswick"
		5 = "Quebec"
		6 = "Ontario"
		7 = "Manitoba"
		8 = "Saskatchewan"
		9 = "Alberta"
		10= "British Columnbia"
	;
run;

proc format;
	value region
	1,2,3,4		= "Atlantic"
	5			= "Quebec"
	6			= "Ontario"
	7,8,9,10	= "West"
	;
run;


/***********************************************************/
/* why put() return char? but format var freq. return num? */
/***********************************************************/
data test;
	set survey_data(keep= A7_15_Loblaws_freq A3province);
	
	/*format A7_15_Loblaws_freq freq.;*/
	newa7=put(A7_15_Loblaws_freq,freq.);

	province = put(A3province,province.);
	region = put(A3province,region.);

	/* convert to number */
	newa7num=input(put(A7_15_Loblaws_freq,freq.),8.);
run;


data doblin_survey;
	set survey_data;
	/* change freq to avalable count */
	

	Age = 2018 - birth_year;
	
	/* add location info */
	province = put(A3province,province.);
	region = put(A3province,region.);
	
	/* change original number to a number meaningful */
	A7_15_Loblaws_f				= input(put(A7_15_Loblaws_freq,freq.),8.);
	A7_17_Zehrs_f				= input(put(A7_17_Zehrs_freq,freq.),8.);
	A7_10_Your_Independent_f 	= input(put(A7_10_Your_Independent_freq,freq.),8.);
	'A7_11_T&T_f'n				= input(put('A7_11_T&T_freq'n,freq.),8.);
	'A7_18_Valu-Mart_f'n		= input(put('A7_18_Valu-Mart_freq'n,freq.),8.);
	A7_24_Provigo_f				= input(put(A7_24_Provigo_freq,freq.),8.);
	A7_26_Atlantic_Superstore_f = input(put(A7_26_Atlantic_Superstore_freq,freq.),8.);
	A7_27_Dominion_f			= input(put(A7_27_Dominion_freq,freq.),8.);
	A7_19_Fortinos_f			= input(put(A7_19_Fortinos_freq,freq.),8.);
	A7_47_City_Market_f			= input(put(A7_47_City_Market_freq,freq.),8.);


	/* create LCL pen, LCL spend etc */
	/* lCL market banner:loblaw,zehrs,YIG,T&T,Value_Mart,Provigo, altantic superstore,Dominion,Fortinos, City Market*/
	LCL_Market_freq = sum(A7_15_Loblaws_f,A7_17_Zehrs_f,A7_10_Your_Independent_f,'A7_11_T&T_f'n,'A7_18_Valu-Mart_f'n,
					A7_24_Provigo_f,A7_26_Atlantic_Superstore_f,A7_27_Dominion_f,A7_19_Fortinos_f,A7_47_City_Market_f);

	LCL_Market_pen = sum(A10_15_Loblaws,A10_17_Zehrs,A10_10_YIG,'A10_11_T&T'n ,'A10_18_Valu-Mart'n,A10_24_Provigo,A10_26_Atlantic_Superstore,
	A10_27_Dominion,A10_19_Fortinos, A10_47_City_Market);

	LCL_Market_spend = LCL_Market_pen*A8spend_per_week/100;

	/* banner sales */
	Loblaw_spend 				= A10_15_Loblaws*A8spend_per_week/100;
	Zehrs_spend					= A10_17_Zehrs*A8spend_per_week/100;
	YIG_spend 					= A10_10_YIG*A8spend_per_week/100;
	'T&T_spend'n				= 'A10_11_T&T'n*A8spend_per_week/100;
	'Valu-Mart_spend'n 			= 'A10_18_Valu-Mart'n*A8spend_per_week/100;
	Provigo_spend				= A10_24_Provigo*A8spend_per_week/100;
	Atlantic_Superstore_spend   = A10_26_Atlantic_Superstore*A8spend_per_week/100;
	Dominion_spend 				= A10_27_Dominion*A8spend_per_week/100;
	Fortinos_spend				= A10_19_Fortinos*A8spend_per_week/100;
	City_Market_spend 			= A10_47_City_Market*A8spend_per_week/100;

	
	/* create value segement */
	if 		LCL_Market_freq >= 1 and LCL_Market_spend >= 100 	then value_seg = "Best Customers";
	else if LCL_Market_freq >= 1 and LCL_Market_spend >= 45  	then value_seg = "Mid Customers";
	else if LCL_Market_freq >= 0.25 and LCL_Market_spend >= 45  then value_seg = "Not Sure yet";
	else if LCL_Market_freq >= 0.25 and LCL_Market_spend <  45  then value_seg = "Low Customers";
	else 														  	 value_seg = "No Segment";

	/*A7_15_Loblaws_freq,A7_17_Zehrs_freq,A7_10_Your_Independent_freq,'A7_11_T&T_freq'n,'A7_18_Valu-Mart_freq'n,
					A7_24_Provigo_freq,A7_26_Atlantic_Superstore_freq,A7_27_Dominion_freq,A7_19_Fortinos_freq,A7_47_City_Market_freq*/
run;


