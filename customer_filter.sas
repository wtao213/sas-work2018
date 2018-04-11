/*********************************/
/* do customer filter from 2015*/
/********************************/
data new2015_v1;
 set Output_Cross_Shop_2015;

 ds_sales2015=sum(SS_Sales,NF_Sales);
 mk_sales2015 = sum(LBL_Sales,VM_Sales,YIG_Sales,Z_Sales);
 total_sales2015 = sum(LBL_Sales,VM_Sales,YIG_Sales,Z_Sales,SS_Sales,NF_Sales);

 ds_txn2015 = sum(SS_Txn,NF_Txn);
 mk_txn2015 = sum(LBL_Txn,VM_Txn,YIG_Txn,Z_Txn);
 total_txn2015 = sum(SS_Txn,NF_Txn,LBL_Txn,VM_Txn,YIG_Txn,Z_Txn);

 mk_pen2015 = mk_txn2015/total_txn2015;

 if		 mk_pen2015 = . then cus_grp2015 = "discount only";
 else if mk_pen2015 = 1 then cus_grp2015 = "market only";
 else						 cus_grp2015 = "shopping both";

run;

ods graphics on;
proc freq data=new2015_v1;
	tables cus_grp2015 /plots=freqplot;
run;
ods graphics off;

proc sort data=new2015_v1(keep=MBRSHIP_ID ds_sales2015 mk_sales2015 total_sales2015 ds_txn2015 mk_txn2015 total_txn2015 mk_pen2015 cus_grp2015) out=cus2015;
 by MBRSHIP_ID;
run;


proc datasets library=work;
   delete new2015_v1;
run;


/***********************************/
/* do the same thing for customre 2016 */
/***************************************/
data new2016_v1;
 set Output_Cross_Shop_2016;

 ds_sales2016=sum(SS_Sales,NF_Sales);
 mk_sales2016 = sum(LBL_Sales,VM_Sales,YIG_Sales,Z_Sales);
 total_sales2016 = sum(LBL_Sales,VM_Sales,YIG_Sales,Z_Sales,SS_Sales,NF_Sales);

 ds_txn2016 = sum(SS_Txn,NF_Txn);
 mk_txn2016 = sum(LBL_Txn,VM_Txn,YIG_Txn,Z_Txn);
 total_txn2016 = sum(SS_Txn,NF_Txn,LBL_Txn,VM_Txn,YIG_Txn,Z_Txn);

 mk_pen2016 = mk_txn2016/total_txn2016;

 if		 mk_pen2016 = . then cus_grp2016 = "discount only";
 else if mk_pen2016 = 1 then cus_grp2016 = "market only";
 else						 cus_grp2016 = "shopping both";

run;

proc sort data=new2016_v1(keep=MBRSHIP_ID ds_sales2016 mk_sales2016 total_sales2016 ds_txn2016 mk_txn2016 total_txn2016 mk_pen2016 cus_grp2016) out=cus2016;
 by MBRSHIP_ID;
run;

proc datasets library=work;
   delete new2016_v1;
run;




/***********************************/
/* do the same thing for customre 2017 */
/***************************************/
data new2017_v1;
 set Output_Cross_Shop_2017;

 ds_sales2017=sum(SS_Sales,NF_Sales);
 mk_sales2017 = sum(LBL_Sales,VM_Sales,YIG_Sales,Z_Sales);
 total_sales2017 = sum(LBL_Sales,VM_Sales,YIG_Sales,Z_Sales,SS_Sales,NF_Sales);

 ds_txn2017 = sum(SS_Txn,NF_Txn);
 mk_txn2017 = sum(LBL_Txn,VM_Txn,YIG_Txn,Z_Txn);
 total_txn2017 = sum(SS_Txn,NF_Txn,LBL_Txn,VM_Txn,YIG_Txn,Z_Txn);

 mk_pen2017 = mk_txn2017/total_txn2017;

 if		 mk_pen2017 = . then cus_grp2017 = "discount only";
 else if mk_pen2017 = 1 then cus_grp2017 = "market only";
 else						 cus_grp2017 = "shopping both";

run;

proc sort data=new2017_v1(keep=MBRSHIP_ID ds_sales2017 mk_sales2017 total_sales2017 ds_txn2017 mk_txn2017 total_txn2017 mk_pen2017 cus_grp2017) out=cus2017;
 by MBRSHIP_ID;
run;

proc datasets library=work;
   delete new2017_v1;
run;


/*****************************************/
/* merge the three files */
/*****************************/
data cus_full_15_17;
	merge cus2015 cus2016 cus2017;
	by MBRSHIP_ID;
run;



/***************************************/
/* getting full full info of customers */
/***************************************/
proc format;
	value group
    . 		 	 = "missing"
	0 - high 	 = "increase"
	-0.1 -< 0	 = "0-10%"
	-0.2 -< -0.1 = "10-20%"
	-0.3 -< -0.2 = "20-30%"
	-0.4 -< -0.3 = "30-40%"
	-0.5 -< -0.4 = "40-50%"
	-0.6 -< -0.5 = "50-60%"
	-0.7 -< -0.6 = "60-70%"
	-0.8 -< -0.7 = "70-80%"
	-0.9 -< -0.8 = "80-90%"
	-1	 -< -0.9 = "90-100%"
	;
run;

data CUS_FULL_15_17_v2;
	set CUS_FULL_15_17_20180406_v1;

	YOY_sales_1516 = total_sales2016/total_sales2015-1;
	YOY_sales_1617 = total_sales2017/total_sales2016-1;

	diff_mk_pen_1516 = sum(mk_pen2016,-mk_pen2015);
	diff_mk_pen_1617 = sum(mk_pen2017,-mk_pen2016);


	if 		 500<=total_sales2015 <=20000 		and 500<=total_sales2016 <=20000 	   and 500<=total_sales2017 <=20000     	then trend_all = "RRR";
	else if  (total_sales2015<= 500 or total_sales2015>=20000) and 500<=total_sales2016 <=20000 	   and 500<=total_sales2017 <=20000 		then trend_all = "IRR";
	else if  (total_sales2015<= 500 or total_sales2015>=20000) and (total_sales2016<= 500 or total_sales2016>=20000) and 500<=total_sales2017 <=20000 		then trend_all = "IIR";
	else if  (total_sales2015<= 500 or total_sales2015>=20000) and (total_sales2016<= 500 or total_sales2016>=20000) and (total_sales2017<= 500 or total_sales2017>=20000) 	then trend_all = "III";
	else if  500<=total_sales2015 <=20000  	and (total_sales2016<= 500 or total_sales2016>=20000) and (total_sales2017<= 500 or total_sales2017>=20000)	then trend_all = "RII";
	else																														     trend_all = "other";

	/* all market pen shifting, inside we have discount customer as well */
	shift_grp1516 = put(diff_mk_pen_1516,group.);
	shift_grp1617 = put(diff_mk_pen_1617,group.);
run;

proc freq data=CUS_FULL_15_17_v2;
	tables trend_all/missing;
run;

proc tabulate data=CUS_FULL_15_17_v2 missing;
	class  shift_grp1516 shift_grp1617;
	var diff_mk_pen_1516 diff_mk_pen_1617;
	
	where mk_pen_2015 in (0.05:0.95); /* only look at customer who are cross shopper in 2015*/

	tables shift_grp1516 all,(shift_grp1617 all)*(n rowpctn);
run;


proc datasets library=work;
 delete CUS_FULL_15_17_20180406_v1 CUS_FULL_15_17_v2 cust1617only;
run;





proc freq data=CUS_FULL_15_17_v2;
	tables cust_join_grp;
run;
/******************************************************************/
/* find the customer who might at least regular shopping one year */
/******************************************************************/
data cus_regular_1517;
 	set CUS_FULL_15_17_v2;

 	where 500<=total_sales2015 <=20000 or 500<=total_sales2016 <=20000 or 500<=total_sales2017 <=20000;
run;

/*****************************************************/
/* find customer regular shopping in all three years */
/*****************************************************/
data cus_regular3year_1517;
 	set CUS_FULL_15_17_v2;

 	where 500<=total_sales2015 <=20000 and 500<=total_sales2016 <=20000 and 500<=total_sales2017 <=20000;
run;


/**** check the frequency *****/
title "Any one shopped during 2015 to 2017 national";
proc freq data=CUS_FULL_15_17_v2;
 tables cus_grp2015 cus_grp2016 cus_grp2017/missing;
run;

title "Any one at least one year regular shopped during 2015 to 2017 national";
proc freq data=cus_regular_1517;
 tables cus_grp2015 cus_grp2016 cus_grp2017/missing;
run;

title "All three year regular shopped during 2015 to 2017 national";
proc freq data=cus_regular3year_1517;
 tables cus_grp2015 cus_grp2016 cus_grp2017/missing;
run;





/*****************************************/
/* for deck slide 4 */

proc freq data=MK_SALES_MCH0_ABS_20180403WT;
	where YOY_sales_change < 0;
	tables shift_grp/missing;
run;

proc freq data=MK_SALES_MCH0_ABS_20180403WT;
	where YOY_sales_change >= 0;
	tables shift_grp/missing;
run;

proc freq data=DS_SALES_FINAL_ABS_20180403WT;
	where YOY_sales_change < 0;
	tables shift_grp/missing;
run;

proc freq data=DS_SALES_FINAL_ABS_20180403WT;
	where YOY_sales_change >= 0;
	tables shift_grp/missing;
run;

/* urban info */
data DS_SALES_FINAL_ABS_20180403WT;
 	set DS_SALES_FINAL_ABS_20180403WT;

	If 		urs_cd = ""  then ur = "missing";
	else if urs_cd = "U" then ur = "urban";
	else					  ur = "rural";
run;

proc tabulate data=DS_SALES_FINAL_ABS_20180403WT missing;
	class shift_grp urs_cd ur;
	var YOY_sales_change;

	tables shift_grp all,urs_cd*(n colpctn) ;
	tables shift_grp all,(ur all)*(n colpctn) ;
run;


data MK_SALES_MCH0_ABS_20180403WT;
 	set MK_SALES_MCH0_ABS_20180403WT;

	If 		urs_cd = ""  then ur = "missing";
	else if urs_cd = "U" then ur = "urban";
	else					  ur = "rural";
run;

proc tabulate data=MK_SALES_MCH0_ABS_20180403WT missing;
	class shift_grp urs_cd ur;
	var YOY_sales_change;

	tables shift_grp all,urs_cd*(n colpctn) ;
	tables shift_grp all,(ur all)*(n colpctn) ;
run;

