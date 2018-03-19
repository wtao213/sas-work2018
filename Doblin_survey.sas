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
	value survey
		1 = "Very Satisfied"
		2 = "Fairly Satisfied"
		3 = "Neither Satisfied nor Dissatisfied"
		4 = "Somewhat dissatisfied"
		5 = "Very Dissatisfied"
		6 = "Didn't shop this department at this store"
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

proc format;
	value gender
	1	= "Male"
	2	= "Female"
	3,4 = "others"
	;

	value household
	1	= "1"
	2	= "2"
	3,4 = "3-4"
	other = "5+"
	;
/*even though just want everything below, still need to indicate low and high */
	value age
	low - <20 	= "below 20"
	20 - 30		= "20-30"
	31 - 40 	= "31-40"
	41 - 50 	= "41-50"
	51 - 64		= "51-64"
	65 <- high	= "65 +"
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
	
	/* add location/demo info */
	province  = put(A3province,province.);
	region    = put(A3province,region.);
	Age_group = put(Age,age.);
	household = put(E3_household_size,household.);
	gender 	  = put(A2_gender,gender.);

	
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


	/* sum every culumn between A10_1_Overwaitea and 'A10_29_CO-OP'n) */
	/* !!remember is sum "of" a list of variables */
	total_market_pen = sum(of A10_1_Overwaitea -- 'A10_29_CO-OP'n);

	Total_Discount_pen = sum(of A10_30_Extra_Foods -- A10_39_Presto A10_49_Save_Easy) ;

	Others_pen = sum(of A10_40_Real_Canadian_superstore -- A10_46_Club__entreport)  ;

	If total_market_pen > 50 then cus_type = "Conventional";
	else						  cus_type = "All Discount";

	oppr_mark_sow = sum(total_market_pen ,- LCL_Market_pen);

	/*A7_15_Loblaws_freq,A7_17_Zehrs_freq,A7_10_Your_Independent_freq,'A7_11_T&T_freq'n,'A7_18_Valu-Mart_freq'n,
					A7_24_Provigo_freq,A7_26_Atlantic_Superstore_freq,A7_27_Dominion_freq,A7_19_Fortinos_freq,A7_47_City_Market_freq*/
run;


/*********************************************/
/* simplify way to repeat the transfer   */
/*********************************************/
/*%let mylist= A7_1_Overwaitea_freq	A7_2_Save-On-Foods_freq'n	A7_3_Co-op__Calgary_freq'n	A7_4_Sobeys_freq	A7_5_IGA_freq
A7_6_Safeway_freq	A7_7_Thrifty_freq	A7_8_HY_freq	A7_9_Whole_foods_freq	A7_10_Your_Independent_freq	A7_11_T&T_freq'n	
A7_12_Super_Valu_freq	A7_13_Freson_Bros_freq	A7_14_Urban_Fare_freq	A7_15_Loblaws_freq	A7_16_Metro_freq	A7_17_Zehrs_freq
A7_18_Valu-Mart_freq'n	A7_19_Fortinos_freq	A7_20_Foodland_freq	A7_21_Longo''s_freq'n	A7_22_Farm_Boy_freq	A7_23_Marche_Adonis_freq	
A7_24_Provigo_freq	A7_25_IGA_freq	A7_26_Atlantic_Superstore_freq	A7_27_Dominion_freq	A7_28_Atlantic_Co-op_freq'n	A7_29_CO-OP_freq'n
A7_30_Extra_Foods_freq	A7_31_No_Frills_freq	A7_32_ShopEasy_Food_freq	A7_33_FreshCo_freq	A7_34_Price_Smart_freq	
A7_35_Food_Basics_freq	A7_36_Price_Chopper_freq	A7_37_Super_C_freq	A7_38_Maxi_freq	A7_39_Presto_freq	
A7_40_Real_Canadian_Superstore_f	A7_41_Walmart_freq	A7_42_Cash&Carry_freq'n	A7_43_SuperValu_freq	A7_44_Costco_freq
A7_45_Real_Canadian_Wholesale_fr	A7_46_Club_Entrepot	A7_47_City_Market_freq	A7_48_CO-OP_freq'n	A7_49_Save_Easy_freq
;

data test;
	set 
*/


/* look at all banner's performance in different region  */
proc tabulate data=doblin_survey missing ;
	class _character_;
	var A10_1_Overwaitea -- A10_49_Save_Easy total_market_pen Others_pen Total_Discount_pen;

	tables (A10_1_Overwaitea -- A10_49_Save_Easy)*(n );

	tables (A10_1_Overwaitea -- A10_49_Save_Easy)*(mean);

	tables region all,(A10_1_Overwaitea -- A10_49_Save_Easy total_market_pen Total_Discount_pen Others_pen)*(n );

	tables region all,(A10_1_Overwaitea -- A10_49_Save_Easy total_market_pen Total_Discount_pen Others_pen)*(mean);
run;

/***************************************************************/
/* find primary market shopper in loblaw,yig, zehrs in ontario */
/***************************************************************/

%macro test(dsn,vars,func);                                                                                                             
data new;                                                                                                                  
 set &dsn;                                                                                                                              
  array list(*) &vars;                                                                                                                  
  &func = vname(list[whichn(&func(of list[*]), of list[*])]);                                                                          
run;                                                                                                                                    
%mend test; 
 
/** retrieve maximum value from a b and c **/                                                                                                                                    
%test(doblin_survey,A10_1_Overwaitea -- A10_49_Save_Easy,max)  

/* one issue is if observation have mutiple max variables, will only return the first column shows up */

data primary_store_sample;
	set new;

	where max in ("A10_15_Loblaws","A10_17_Zehrs","A10_10_YIG") and region = "Ontario";

run;

/**********************************************************************/
/* look at where are they shopping, and where they shopped else where */
/***********************************************************************/
proc tabulate data=primary_store_sample missing ;
	class _character_;
	var A10_1_Overwaitea -- A10_49_Save_Easy LCL_Market_pen total_market_pen Others_pen Total_Discount_pen;

	tables (A10_1_Overwaitea -- 'A10_29_CO-OP'n LCL_Market_pen total_market_pen Others_pen Total_Discount_pen )*(n );

	tables (A10_1_Overwaitea -- 'A10_29_CO-OP'n LCL_Market_pen total_market_pen Others_pen Total_Discount_pen)*(mean);
	
run;


