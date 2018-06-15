/***************************************/
/*	 transfer from long to wide file   */
/***************************************/
data full_2016(rename=(NF_SALES=NF_SALES_cat2016 NF_TRANS=NF_TRANS_cat2016 NF_SALES_PROMO=NF_SALES_PROMO_cat2016 
	NF_TRANS_PROMO= NF_TRANS_PROMO_cat2016 LL_SALES=LL_SALES_cat2016 LL_SALES_PROMO=LL_SALES_PROMO_cat2016 LL_TRANS=LL_TRANS_cat2016 
	LL_TRANS_PROMO=	LL_TRANS_PROMO_cat2016 total_sales=total_sales_cat2016 total_sales_promo=total_sales_promo_cat2016
	total_txn=total_txn_cat2016 total_txn_promo=total_txn_promo_cat2016));
	set CUST_MCH_BY_YEAR20180607;

	where Yr =2016;
	drop YR _FREQ_qur;
run;

/* keep MBRSHIP_ID	MCH_0_CD MCH0_name NF_SALES NF_TRANS NF_SALES_PROMO NF_TRANS_PROMO
	LL_SALES LL_SALES_PROMO LL_TRANS LL_TRANS_PROMO total_sales total_sales_promo total_txn total_txn_promo; */


data full_2017(rename=(NF_SALES=NF_SALES_cat2017 NF_TRANS=NF_TRANS_cat2017 NF_SALES_PROMO=NF_SALES_PROMO_cat2017 
	NF_TRANS_PROMO= NF_TRANS_PROMO_cat2017 LL_SALES=LL_SALES_cat2017 LL_SALES_PROMO=LL_SALES_PROMO_cat2017 LL_TRANS=LL_TRANS_cat2017 
	LL_TRANS_PROMO=	LL_TRANS_PROMO_cat2017 total_sales=total_sales_cat2017 total_sales_promo=total_sales_promo_cat2017
	total_txn=total_txn_cat2017 total_txn_promo=total_txn_promo_cat2017));
	set CUST_MCH_BY_YEAR20180607;

	where Yr =2017;
	drop YR _FREQ_qur;
run;

proc sort data=full_2016;
 by MBRSHIP_ID	MCH_0_CD MCH0_name;
run;

proc sort data=full_2017;
 by MBRSHIP_ID	MCH_0_CD MCH0_name;
run;

data full;
 merge full_2016 full_2017;
 by MBRSHIP_ID	MCH_0_CD MCH0_name;

 cat_sales_pen_2016 = total_sales_cat2016/total_sales_2016;
 cat_sales_pen_2017 = total_sales_cat2017/total_sales_2017;

 cat_txn_pen_2016 = total_txn_cat2016/total_TRANS_2016;
 cat_txn_pen_2017 = total_txn_cat2017/total_TRANS_2017;

 cat_sales_pen_diff = sum(cat_sales_pen_2017,-cat_sales_pen_2016);
 cat_txn_pen_diff = sum(cat_txn_pen_2017,-cat_txn_pen_2016);

run;

proc sort data=full;
 by MBRSHIP_ID	MCH_0_CD MCH0_name;
run;

proc summary data= full nway;
	class  MBRSHIP_ID;
	var cat_sales_pen_diff cat_txn_pen_diff;
	output out=full_mch0
	idgroup(max(cat_txn_pen_diff)out[3](MCH0_name cat_txn_pen_diff)=maxCat max_shift)
	idgroup(min(cat_txn_pen_diff)out[3](MCH0_name cat_txn_pen_diff)=minCat min_shift);
run;


/* check customer by their primary banner ind */
proc sort data=FULL20180614;
	by MBRSHIP_ID;
run;

/* check the loblaw first */
proc summary data=FULL20180614 nway;
	where division_2017 = "primary market" and MCH0_name~="Front End Bags";
	class  MBRSHIP_ID division_2017 total_trans_2017;
	var NF_TRANS_cat2017 LL_TRANS_cat2017 ;
	output out=lcl_mch0
	idgroup(max(LL_TRANS_cat2017)out[3](MCH0_name LL_TRANS_cat2017)=max_MK_Cat max_MK_txn)
	idgroup(max(NF_TRANS_cat2017)out[3](MCH0_name NF_TRANS_cat2017)=max_DS_Cat max_DS_txn);
run;

/* check no frills now */
proc summary data=FULL20180614 nway;
	where division_2017 = "primary discount" and MCH0_name~="Front End Bags";
	class  MBRSHIP_ID division_2017 total_trans_2017;
	var NF_TRANS_cat2017 LL_TRANS_cat2017 ;
	output out=nf_mch0
	idgroup(max(LL_TRANS_cat2017)out[3](MCH0_name LL_TRANS_cat2017)=max_MK_Cat max_MK_txn)
	idgroup(max(NF_TRANS_cat2017)out[3](MCH0_name NF_TRANS_cat2017)=max_DS_Cat max_DS_txn);
run;


/* check half half now */
proc summary data=FULL20180614 nway;
	where  MCH0_name~="Front End Bags";
	class  MBRSHIP_ID division_2017 total_trans_2017 NF_TRANS_2017 LL_TRANS_2017;
	var NF_TRANS_cat2017 LL_TRANS_cat2017 total_txn_cat2017 ;
	output out=total_mch0
	idgroup(max(LL_TRANS_cat2017)out[3](MCH0_name LL_TRANS_cat2017 total_txn_cat2017)=max_MK_Cat max_MK_txn MKtotal_txn_cat2017)
	idgroup(max(NF_TRANS_cat2017)out[3](MCH0_name NF_TRANS_cat2017 total_txn_cat2017)=max_DS_Cat max_DS_txn DStotal_txn_cat2017);
run;

/* replace everything by sales */
proc summary data=FULL20180614 nway;
	where  MCH0_name~="Front End Bags";
	class  MBRSHIP_ID division_2017 total_sales_2017 NF_sales_2017 LL_sales_2017;
	var NF_sales_cat2017 LL_sales_cat2017 total_sales_cat2017 ;
	output out=total_mch0
	idgroup(max(LL_sales_cat2017)out[3](MCH0_name LL_sales_cat2017 total_sales_cat2017)=max_MK_Cat max_MK_txn MKtotal_sales_cat2017)
	idgroup(max(NF_sales_cat2017)out[3](MCH0_name NF_sales_cat2017 total_sales_cat2017)=max_DS_Cat max_DS_txn DStotal_sales_cat2017);
run;
