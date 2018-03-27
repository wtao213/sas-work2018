/********************************************/
/* 		rerun everything in MCH0 level    */
/******************************************/

proc sort data=Output4_Cross_Shop_MCH0(rename=(mbrship_id=Mbrship_id));
	by Mbrship_id MCH_0_DESC_E mch_0_cd Yr; /* please remember, some category have same mch0 name but different mch0 code! */
run;

proc transpose data=Output4_Cross_Shop_MCH0 out=full_sales_mch0;
	var SALES   /*Units   Txn  CB_SALES  CB_Units  CB_Txn*/;/* the variable want to see */
	by Mbrship_id MCH_0_DESC_E mch_0_cd; /* the row indicator */
	id Yr cust_grp_cd; /* the id want to change from horizontal to vertical */
run;


/**************************************/
/* get total sales for every customer */
/**************************************/

/* !!! missing discount info in the data set   */
data total;
	set '20180313 shifting result rank by'n;

	keep Mbrship_id totadsl2017 totalds2016 totalmk2016 totalmk2017 ;
run;

proc sort data=total;
	by Mbrship_id;
run;

proc sort data=full_sales_mch0 out=categorysales;
	by Mbrship_id;
run;

data sales_info_full(drop=_name_);
	merge categorysales total;
	by Mbrship_id;

	/*format MtoD2017  	MtoD2016 dollar4.2;*/

	pctMK2017 = '2017MK'n/totalmk2017;
	/*pctDS2017 = '2017DS'n/totadsl2017;*/

	pctMK2016 = '2016MK'n/totalmk2016;
	/*pctDS2016 = '2016DS'n/totadsl2017;*/

	ShiftMK = sum('2016MK'n, - '2017KMK'n); /* using sum a-b to get subtraction contain missing value */
	/*ShiftDS = sum('2016DS'n ,- '2017DS'n);*/

	ShiftMKpct = sum(pctMK2016, - pctMK2017);
	/*ShiftDSpct = sum(pctDS2016,- pctDS2017);*/

run;

/****************************************************/
/* show the top two cateogries increasing/decline */
/***************************************************/
proc sort data=sales_info_full;
	by Mbrship_id;
run;

/* list the max and min two categories */
proc summary data=sales_info_full nway;
	class Mbrship_id totadsl2017 totalds2016 totalmk2017 totalmk2016;
	var ShiftMKpct /*ShiftDSpct*/ ShiftMK /*ShiftDS*/;
	output out=sales_final_mch0 
	idgroup(max(ShiftMKpct)out[5](MCH_0_DESC_E ShiftMKpct ShiftMK )=Mdecline maxShiftMKpct  minShiftMK)
	/*idgroup(min(ShiftDSpct)out[2](MCH_2_DESC_E ShiftMKpct ShiftDSpct ShiftMK ShiftDS)=maxDtoM maxShiftMKpct maxShiftDSpct maxShiftMK maxShiftDS)*/;
run;

proc summary data=sales_info_full nway;
	class Mbrship_id totadsl2017 totalds2016 totalmk2017 totalmk2016;
	var ShiftMKpct /*ShiftDSpct*/ ShiftMK /*ShiftDS*/;
	output out=sales_final_mch0 
	idgroup(max(ShiftMK)out[5](MCH_0_DESC_E ShiftMKpct ShiftMK )=Mdecline maxShiftMKpct  minShiftMK)
	/*idgroup(min(ShiftDSpct)out[2](MCH_2_DESC_E ShiftMKpct ShiftDSpct ShiftMK ShiftDS)=maxDtoM maxShiftMKpct maxShiftDSpct maxShiftMK maxShiftDS)*/;
run;











/*********************************************************************/
/* 					discount part rerun								 */
/*********************************************************************/
/* 		rerun everything in MCH0 level   */
/******************************************/


proc sort data=Output4_Cross_Shop_MCH0_DS(rename=(mbrship_id=Mbrship_id));
	by Mbrship_id MCH_0_DESC_E mch_0_cd Yr; /* please remember, some category have same mch0 name but different mch0 code! */
run;


proc transpose data=Output4_Cross_Shop_MCH0_DS out=full_sales_mch0;
	var SALES   /*Units   Txn  CB_SALES  CB_Units  CB_Txn*/;/* the variable want to see */
	by Mbrship_id MCH_0_DESC_E mch_0_cd; /* the row indicator */
	id Yr cust_grp_cd; /* the id want to change from horizontal to vertical */
run;


/**************************************/
/* get total sales for every customer */
/**************************************/

/* !!! missing discount info in the data set   */
data total;
	set '20180313 shifting result rank by'n;

	keep Mbrship_id totadsl2017 totalds2016 totalmk2016 totalmk2017 ;
run;

proc sort data=total;
	by Mbrship_id;
run;

proc sort data=full_sales_mch0 out=categorysales;
	by Mbrship_id;
run;

data sales_info_full(drop=_name_);
	merge categorysales total;
	by Mbrship_id;

	/*format MtoD2017  	MtoD2016 dollar4.2;*/

	/*pctMK2017 = '2017MK'n/totalmk2017;*/
	pctDS2017 = '2017DS'n/totadsl2017;

	/*pctMK2016 = '2016MK'n/totalmk2016;*/
	pctDS2016 = '2016DS'n/totadsl2016;

	/*ShiftMK = sum('2016MK'n, - '2017KMK'n);*/ /* using sum a-b to get subtraction contain missing value */
	ShiftDS = sum('2016DS'n ,- '2017DS'n);

	/*ShiftMKpct = sum(pctMK2016, - pctMK2017);*/
	ShiftDSpct = sum(pctDS2016,- pctDS2017);

run;

/****************************************************/
/* show the top two cateogries increasing/decline */
/***************************************************/
proc sort data=sales_info_full;
	by Mbrship_id;
run;

/* list the max and min two categories */
proc summary data=sales_info_full nway;
	class Mbrship_id totadsl2017 totalds2016 totalmk2017 totalmk2016;
	var /*ShiftMKpct*/ ShiftDSpct /*ShiftMK*/ ShiftDS;
	output out=sales_final_mch0 
	/*idgroup(max(ShiftMKpct)out[5](MCH_0_DESC_E ShiftMKpct ShiftMK )=Mdecline maxShiftMKpct  minShiftMK)*/
	  idgroup(min(ShiftDSpct)out[5](MCH_0_DESC_E ShiftDSpct ShiftDS )=DSincr   DSShiftpct  ShiftDS);
run;

proc summary data=sales_info_full nway;
	class Mbrship_id totadsl2017 totalds2016 totalmk2017 totalmk2016;
	var /*ShiftMKpct*/ ShiftDSpct /*ShiftMK*/ ShiftDS;
	output out=sales_final_mch0 
  /*idgroup(max(ShiftMK)out[5](MCH_0_DESC_E ShiftMKpct ShiftMK )=Mdecline maxShiftMKpct  minShiftMK)*/
	idgroup(min(ShiftDS)out[5](MCH_0_DESC_E ShiftDSpct ShiftDS )=DSincr   DSShiftpct  ShiftDS);
run;




/****************************************************************************************/
/* aggreate mch0 info together to get the pectencage change per units by category level */
/*****************************************************************************************/
proc sort data=Output4_Cross_Shop_MCH0_DS;
	by Mbrship_id MCH_0_DESC_E mch_0_cd Yr; /* please remember, some category have same mch0 name but different mch0 code! */
run;

proc sort data=Membership_ID_dist(rename=(MBRSHIP_ID=Mbrship_id));
	by Mbrship_id;
run;

data ds_customer;
	merge Output4_Cross_Shop_MCH0_DS(in=a) Membership_ID_dist;
	by Mbrship_id;

	if a=1;
run;

proc sort data=ds_customer;
	by Mbrship_id MCH_0_DESC_E mch_0_cd Yr 'Var dist seg'n; /* please remember, some category have same mch0 name but different mch0 code! */
run;

proc summary data=ds_customer nway;
	class MCH_0_DESC_E mch_0_cd Yr 'Var dist seg'n;
	var Sales Txn Units CB_Txn cb_sales CB_Units ;
	output out=category_ds_summary(rename=(_FREQ_=cust_count_ds)) 
		sum(Sales Txn Units cb_sales CB_Txn CB_Units)= DSSales DSTxn DSUnits DScb_sales DSCB_Txn DSCB_Units ; 
run;


/*** merge full version */
data mch0_full;
 merge Output4_Cross_Shop_MCH0_DS Output4_Cross_Shop_MCH0(rename=(Sales=MKSales Txn=MKTxn Units=MKUnits cb_sales=mkcb_sales CB_Txn=MKCB_txn CB_Units=MKCB_Units));
 by Mbrship_id MCH_0_DESC_E mch_0_cd Yr;
run;


/*********************************************************/
/* get the same thing from MK data set */
/*******************************************/
proc sort data=Output4_Cross_Shop_MCH0;
	by Mbrship_id MCH_0_DESC_E mch_0_cd Yr; /* please remember, some category have same mch0 name but different mch0 code! */
run;

proc sort data=Membership_ID_dist(rename=(MBRSHIP_ID=Mbrship_id));
	by Mbrship_id;
run;

data mk_customer;
	merge Output4_Cross_Shop_MCH0(in=a) Membership_ID_dist;
	by Mbrship_id;

	if a=1;
run;

/* */
proc sort data=mk_customer;
	by Mbrship_id MCH_0_DESC_E mch_0_cd Yr 'Var dist seg'n; /* please remember, some category have same mch0 name but different mch0 code! */
run;

proc summary data=mk_customer nway;
	class MCH_0_DESC_E mch_0_cd Yr 'Var dist seg'n;
	var Sales Txn Units CB_Txn cb_sales CB_Units;
	output out=category_mk_summary(rename=(_FREQ_=cust_count_MK)) 
		sum(Sales Txn Units cb_sales CB_Txn CB_Units)= MKSales MKTxn MKUnits MKcb_sales MKCB_Txn MKCB_Units ; 
run;

/******************************************/
/*		 merge ds and mk together 		*/
/******************************************/
proc sort data=category_mk_summary;
	by MCH_0_DESC_E mch_0_cd Yr 'Var dist seg'n;
run;

proc sort data=category_ds_summary;
	by MCH_0_DESC_E mch_0_cd Yr 'Var dist seg'n;
run;

data category_compare;
 merge category_ds_summary category_mk_summary;
 	by MCH_0_DESC_E mch_0_cd Yr 'Var dist seg'n;

	mk_sale_unit = MKSales/MKUnits;
	ds_sale_unit = DSSales/DSUnits;
	price_diff   = mk_sale_unit/ds_sale_unit -1;
run;


/***********************************************************************/
/* check the price per units for every customer, in certain categories */
/***********************************************************************/
data customer_top5_compare;
	set mch0_full;
	
	where MCH_0_DESC_E in ("Fresh-Beef","Fresh-Poultry","Cheese","Milk","Deli Cheese");
	
	mk_sale_unit = MKSales/MKUnits;
	ds_sale_unit = Sales/Units;
	price_diff   = mk_sale_unit/ds_sale_unit -1;
	
run;

/*************************************************************/
/*				add customer seg  info in					 */
/*************************************************************/
proc sort data=customer_top5_compare ;
	by Mbrship_id;
run;

proc sort data=Membership_ID_dist(rename=(MBRSHIP_ID=Mbrship_id));
	by Mbrship_id;
run;

data cut_top5_compare_with_seg;
	merge customer_top5_compare(in=a) Membership_ID_dist;
	by Mbrship_id;
	
	if a =1;
run;
	
