/*********************************/
/* add group to market pen 		 */
/*********************************/
proc format;
value group
    . 	 = "DS only or no shop"
	0 = "Discount only"
	 0	 <-< 0.1 = "0-10%"
	0.1	 -< 0.2 = "10-20%"
	0.2	 -< 0.3 = "20-30%"
	0.3	 -< 0.4 = "30-40%"
	0.4	 -< 0.5 = "40-50%"
	0.5	 -< 0.6 = "50-60%"
	0.6	 -< 0.7 = "60-70%"
	0.7	 -< 0.8 = "70-80%"
	0.8	 -< 0.9 = "80-90%"
	0.9	 -< 1   = "90-100%"
	1 - high = "Market only";
run;

/* make your master file */
data test1;
 set EVERYINFO20180531;
 format division_2017 $18.;

 division_2017 = put(mk_pen_2017,group.);
run;


/* filtered the selected people */
data selected;
 set test1;

 where reg_in = "both q1 q4" and total_TRANS_2017 >25 and total_TRANS_2016 >25
 and -0.3<= YOY_TXN <= 0.3;

run;

proc freq data=selected;
 tables division_2017;
run;

/* combine the MCH0 level info to one file and add MCH0 name */
data full;
 set Toronto_Stores_20180604 Toronto_Stores_20180604_v2;
run;

/* import MCH0 mapping */
proc sort data=full;
	by MCH_0_CD;
run;

proc sort data='2016_LCL_Hierarchy'n(rename=('MCH0 Super Category'n=MCH_0_CD));
	by MCH_0_CD;
run;

data full_new;
 merge full(in=a) '2016_LCL_Hierarchy'n;
 by MCH_0_CD;

 if a=1;

 total_sales 		= sum(NF_SALES,ll_sales);
 total_sales_promo	= sum(NF_SALES_PROMO,ll_sales_promo);

 total_txn			= sum(NF_TRANS,ll_trans);
 total_txn_promo	= sum(NF_TRANS_PROMO,ll_trans_promo);

run;


/**************************************/
/*   get some summary info overall  	*/
/**************************************/
data full_v2;
 set FULL_NEW20180604;

 total_sales 		= sum(NF_SALES,ll_sales);
 total_sales_promo	= sum(NF_SALES_PROMO,ll_sales_promo);

 total_txn			= sum(NF_TRANS,ll_trans);
 total_txn_promo	= sum(NF_TRANS_PROMO,ll_trans_promo);

run;

/******************************************************/
/* change all 0 to missing value to fix count results */
/******************************************************/
data full_v3;
 set full_v2;
 array change _numeric_;
  do over change;
     if change = 0 then change =.;
  end;
run;


proc tabulate data=full_v3 missing;
	class YR QTR MCH_0_CD 'mch0 name'n;
	var NF_SALES NF_TRANS NF_SALES_PROMO NF_TRANS_PROMO ll_sales ll_sales_promo  
	ll_trans ll_trans_promo ;

	tables YR*QTR,MCH_0_CD*'mch0 name'n,(NF_SALES NF_SALES_PROMO ll_sales ll_sales_promo)*(n sum mean) ;
run;

proc sort data=FULL_NEW20180604 out=mchlist nodupkey;
 by MCH_0_CD;
run;


/* 	MBRSHIP_ID         8
        YR                 8
        QTR                8
        MCH_0_CD         $ 9
        NF_SALES           8
        NF_UNITS           8
        NF_TRANS           8
        NF_SALES_PROMO     8
        NF_UNITS_PROMO     8
        NF_TRANS_PROMO     8
        LL_SALES           8
        LL_UNITS           8
        LL_TRANS           8
        LL_SALES_PROMO     8
        LL_UNITS_PROMO     8
        LL_TRANS_PROMO     8
        'MCH3 Super Department'n $ 3
        'mch3 name'n     $ 20
        'MCH2 Department'n $ 5
        'mch2 name'n     $ 17
        'MCH1 Sub Department'n $ 7
        'mch1 name'n     $ 27
        'mch0 name'n */