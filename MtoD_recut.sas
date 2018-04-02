/************************************************/
/*	find the customer list for M to D	*/
/*************************************/
proc sort data=FULL_MASTER_SHIFTING_CUSTOMER;
	by MBRSHIP_ID ;
run;

proc sort data=MtoD_cust_list_132k(rename=(Mbrship_id=MBRSHIP_ID));
	by MBRSHIP_ID ;
run;

data MtoD132;
	merge FULL_MASTER_SHIFTING_CUSTOMER MtoD_cust_list_132k(in=a);
	by MBRSHIP_ID ;
	if a =1;
run;


/**********************************************/
/* get category info for every 132k customers */
/**********************************************/
proc sort data=Output4_Cross_Shop_MCH0;
	by mbrship_id;
run;

proc sort data=MtoD132(rename=(MBRSHIP_ID=mbrship_id));
	by mbrship_id;
run;

data MtoD132Full;
	merge Output4_Cross_Shop_MCH0 MtoD132(in=a);
	by mbrship_id;

	if a=1;
run;

/********************************************************/
/*	 look at the change info  */
/*********************************************/
/* 	transpose get sales info for every cus   */
/*********************************************/

proc sort data=MtoD132Full(rename=(mbrship_id=Mbrship_id));
	by Mbrship_id MCH_0_DESC_E mch_0_cd  total2016 total2017 YOY_sales_change	MK_pen_2016 MK_pen_2017 MK_pen_shift
	shift_grp BAN_NM16 RGN_NM URS_CD MKTotalSales2017 MKTotalSales2016	;  /* please remember, some category have same mch0 name but different mch0 code! */
run;

/* this data set only have info for Market banner */
proc transpose data=MtoD132Full out=full_sales_mch0;
	var SALES   /*Units   Txn  CB_SALES  CB_Units  CB_Txn*/;/* the variable want to see */
	by Mbrship_id MCH_0_DESC_E mch_0_cd total2016 total2017 YOY_sales_change MK_pen_shift
	shift_grp BAN_NM16 RGN_NM URS_CD MKTotalSales2017 MKTotalSales2016; /* the row indicator */
	id Yr cust_grp_cd; /* the id want to change from horizontal to vertical */
run;

/****************************************/
/* get calculation for category */
/******************************************/
data sales_info_full(drop=_name_);
	set full_sales_mch0;


	/*format MtoD2017  	MtoD2016 dollar4.2;*/

	catpctMK2017 = '2017MK'n/MKTotalSales2017;
	/*pctDS2017 = '2017DS'n/totadsl2017;*/

	catpctMK2016 = '2016MK'n/MKTotalSales2016;
	/*pctDS2016 = '2016DS'n/totadsl2017;*/

	catShiftMK = sum('2016MK'n, - '2017MK'n); /* using sum a-b to get subtraction contain missing value */
	/*ShiftDS = sum('2016DS'n ,- '2017DS'n);*/

	catShiftMKpct = sum(catpctMK2016, - catpctMK2017);
	/*ShiftDSpct = sum(pctDS2016,- pctDS2017);*/

run;

/*************************************/
/* show the top 5 for each customer */
/*************************************/
proc sort data=sales_info_full;
	by Mbrship_id;
run;

/* list the max and min two categories */
proc summary data=sales_info_full nway;
	class Mbrship_id total2016 total2017 YOY_sales_change MK_pen_shift
	shift_grp BAN_NM16 RGN_NM URS_CD MKTotalSales2017 MKTotalSales2016;
	var catShiftMKpct /*ShiftDSpct*/ catShiftMK /*ShiftDS*/;
	output out=sales_final_mch0 
	idgroup(max(catShiftMKpct)out[5](MCH_0_DESC_E catShiftMKpct catShiftMK )=Mdecline maxShiftMKpct  minShiftMK)
	/*idgroup(min(ShiftDSpct)out[2](MCH_2_DESC_E ShiftMKpct ShiftDSpct ShiftMK ShiftDS)=maxDtoM maxShiftMKpct maxShiftDSpct maxShiftMK maxShiftDS)*/;
run;

proc summary data=sales_info_full nway;
	class Mbrship_id total2016 total2017 YOY_sales_change MK_pen_shift
	shift_grp BAN_NM16 RGN_NM URS_CD MKTotalSales2017 MKTotalSales2016;
	var catShiftMKpct /*ShiftDSpct*/ catShiftMK /*ShiftDS*/;
	output out=sales_final_mch0 
	idgroup(max(catShiftMK)out[5](MCH_0_DESC_E catShiftMKpct catShiftMK )=Mdecline maxShiftMKpct  minShiftMK)
	/*idgroup(min(ShiftDSpct)out[2](MCH_2_DESC_E ShiftMKpct ShiftDSpct ShiftMK ShiftDS)=maxDtoM maxShiftMKpct maxShiftDSpct maxShiftMK maxShiftDS)*/;
run;

/*****************************************************/
/* only show evey customers' top 5 together */
/********************************************/
data top5_full_raw;
	set sales_final_mch0;
	
	array category{5} $27. Mdecline_1 - Mdecline_5;
	array maxShiftMKpct{5}  maxShiftMKpct_1 -maxShiftMKpct_5;/* be careful about the name!!!variable sales already in the data set !!*/
 	array minShiftMK{5}  minShiftMK_1 -minShiftMK_5;

	do i = 1 to 5;
		CA_name = category{i} ;/* DO NOT USE THE SAME NAME FOR AN ARRAY AS A VARIABLE IN YOUR DATA SET !! */
		cat_shift_pct = maxShiftMKpct{i};
		cat_shift_dollar = minShiftMK{i};
		if CA_name ne "." then output; /* use missing instead of .  , if not sas will convert CA to num variable TT */
		/*if Sales ne missing then output;*/ /*don't need to set every array, as if missing in CA, every will be missing*/
	end;

	keep Mbrship_id total2016 total2017 YOY_sales_change MK_pen_shift
	shift_grp BAN_NM16 RGN_NM URS_CD MKTotalSales2017 MKTotalSales2016 CA_name cat_shift_pct cat_shift_dollar;/* don't forget the thing you calculated */
run;

ods graphics on;
proc freq data=top5_full_raw order=freq;
	where shift_grp = "0-10%";
	tables CA_name/plots=freqplot ;
run;

proc freq data=top5_full_raw order=freq;
	where shift_grp ~= "0-10%";
	tables CA_name/plots=freqplot;
run;
ods graphics off;

/*****************************************************/
/* check whether shifting proportion make difference */
/*****************************************************/
ods graphics on;
proc freq data=sales_final_mch0 order=freq;
	where shift_grp = "0-10%";
	tables Mdecline_1 Mdecline_2 Mdecline_3 Mdecline_4 Mdecline_5/plots=freqplot;
run;

proc freq data=sales_final_mch0 order=freq;
	where shift_grp ~= "0-10%";
	tables Mdecline_1 Mdecline_2 Mdecline_3 Mdecline_4 Mdecline_5/plots=freqplot;
run;
ods graphics off;