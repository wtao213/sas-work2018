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