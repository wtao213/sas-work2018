/**************************************************/
/* look at the customer total level info only  */
/************************************************/
proc sort data=Output_Value_Segments(rename=(mbrship_id=Mbrship_id));
	by Mbrship_id;
run;



data certain_customer;
	merge Output_Value_Segments(in=a) Output3_Cross_Shop_MCH2(in=b);
	by Mbrship_id;

	if a=1;
run;

data total;
 set certain_customer;

 where MCH_2_DESC_E = 'Total';

run;

proc sort data=certain_customer out=full;
	by Mbrship_id MCH_2_DESC_E Value_Segment2016 Value_Segment2017;
run;

proc transpose data=full out=full_sales;
	var SALES   /*Units   Txn  CB_SALES  CB_Units  CB_Txn*/;/* the variable want to see */
	by Mbrship_id MCH_2_DESC_E Value_Segment2016 Value_Segment2017; /* the row indicator */
	id Yr cust_grp_cd; /* the id want to change from horizontal to vertical */
run;

/***********************************/
/* transpose data set */
/***************************/
proc sort data=total;
	by Mbrship_id;
run;

proc transpose data=total out=total_by_customer(drop=MCH_2_DESC_E);
	var SALES   Units   Txn  CB_SALES  CB_Units  CB_Txn;/* the variable want to see */
	by Mbrship_id; /* the row indicator */
	id Yr cust_grp_cd; /* the id want to change from horizontal to vertical */
run;

/***************************************/
/* get proportion for category slaes  */
/**************************************/

/* get total sales for every customer */
data total(rename=('2017MK'n=totalmk2017 '2017DS'n=totadsl2017 '2016MK'n=totalmk2016 '2016DS'n=totalds2016));
	set full_sales;

	where MCH_2_DESC_E = 'Total';
run;

proc sort data=total(drop=_NAME_ MCH_2_DESC_E);
	by Mbrship_id;
run;

proc sort data=full_sales out=categorysales;
	where MCH_2_DESC_E ~= 'Total';
	by Mbrship_id;
run;

data sales_info_full;
	merge categorysales total;
	by Mbrship_id;

	/*format MtoD2017  	MtoD2016 dollar4.2;*/

	pctMK2017 = '2017MK'n/totalmk2017;
	pctDS2017 = '2017DS'n/totadsl2017;

	pctMK2016 = '2016MK'n/totalmk2016;
	pctDS2016 = '2016DS'n/totadsl2017;

	ShiftMK = sum('2016MK'n, - '2017KMK'n); /* using sum a-b to get subtraction contain missing value */
	ShiftDS = sum('2016DS'n ,- '2017DS'n);

	ShiftMKpct = sum(pctMK2016, - pctMK2017);
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
	var ShiftMKpct ShiftDSpct ShiftMK ShiftDS;
	output out=sales_final 
	idgroup(max(ShiftMKpct)out[2](MCH_2_DESC_E ShiftMKpct ShiftDSpct ShiftMK ShiftDS)=minMtoD minShiftMKpct minShiftDSpct minShiftMK minShiftDS)
	idgroup(min(ShiftDSpct)out[2](MCH_2_DESC_E ShiftMKpct ShiftDSpct ShiftMK ShiftDS)=maxDtoM maxShiftMKpct maxShiftDSpct maxShiftMK maxShiftDS);
run;

/* rerun it, filter out the category doesn't really matter */
proc summary data=sales_info_full nway;
	class Mbrship_id totadsl2017 totalds2016 totalmk2017 totalmk2016;
	var ShiftMKpct ShiftDSpct ShiftMK ShiftDS;
	
	where MCH_2_DESC_E not in ('OTC','Home','HBA','Apparel','Garden','Floral');

	output out=sales_final_sevcat_only 
	idgroup(max(ShiftMKpct)out[2](MCH_2_DESC_E ShiftMKpct ShiftDSpct ShiftMK ShiftDS)=minMtoD minShiftMKpct minShiftDSpct minShiftMK minShiftDS)
	idgroup(min(ShiftDSpct)out[2](MCH_2_DESC_E ShiftDSpct ShiftMKpct ShiftMK ShiftDS)=maxDtoM maxShiftDSpct maxShiftMKpct maxShiftMK maxShiftDS);
run;


/* try to ranking by absolute dollar this time */
proc summary data=sales_info_full nway;
	class Mbrship_id totadsl2017 totalds2016 totalmk2017 totalmk2016;
	var ShiftMKpct ShiftDSpct ShiftMK ShiftDS;
	
	where MCH_2_DESC_E not in ('OTC','Home','HBA','Apparel','Garden','Floral');

	output out=sales_final_sevcat_only 
	idgroup(max(ShiftMK)out[2](MCH_2_DESC_E ShiftMKpct ShiftDSpct ShiftMK ShiftDS)=minMtoD minShiftMKpct minShiftDSpct minShiftMK minShiftDS)
	idgroup(min(ShiftDS)out[2](MCH_2_DESC_E ShiftDSpct ShiftMKpct ShiftMK ShiftDS)=maxDtoM maxShiftDSpct maxShiftMKpct maxShiftMK maxShiftDS);
run;

/* 	check the frequency to category name 	*/
ods graphics on;
proc freq data=sales_final_sevcat_only order=freq;
	tables maxDtoM_1 maxDtoM_2 minMtoD_1 minMtoD_2/plots=all;
run;
ods graphics off;


/***************************/
/* filter out the customer */
/***************************/
proc sort data=ID;
	by Mbrship_id;
run;

proc sort data=sales_final_sevcat_only;
	by Mbrship_id;
run;

data final_v2;
	merge ID(in=a) sales_final_sevcat_only(in=b);
	by Mbrship_id;

	if a=1 and b=1;
run;

/* 	check the frequency to category name 	*/
ods graphics on;
proc freq data=final_v2 order=freq;
	tables maxDtoM_1 maxDtoM_2 minMtoD_1 minMtoD_2/plots=freqplot;
run;
ods graphics off;



/********************************************************/
/*														*/
/* 	repeat the whole processing by txn info  			*/
/*														*/
/********************************************************/
proc transpose data=full out=full_txn;
	var Txn   /*Units   SALES  Txn  CB_SALES  CB_Units  CB_Txn*/;/* the variable want to see */
	by Mbrship_id MCH_2_DESC_E Value_Segment2016 Value_Segment2017; /* the row indicator */
	id Yr cust_grp_cd; /* the id want to change from horizontal to vertical */
run;

/* get total sales for every customer */
data total(rename=('2017MK'n=totalmk2017 '2017DS'n=totadsl2017 '2016MK'n=totalmk2016 '2016DS'n=totalds2016));
	set full_txn;

	where MCH_2_DESC_E = 'Total';
run;

proc sort data=total(drop=_NAME_ MCH_2_DESC_E);
	by Mbrship_id;
run;

proc sort data=full_txn out=categorytxn;
	where MCH_2_DESC_E ~= 'Total';
	by Mbrship_id;
run;

data txn_info_full;
	merge categorytxn total;
	by Mbrship_id;

	/*format MtoD2017  	MtoD2016 dollar4.2;*/

	pctMK2017 = '2017MK'n/totalmk2017;
	pctDS2017 = '2017DS'n/totadsl2017;

	pctMK2016 = '2016MK'n/totalmk2016;
	pctDS2016 = '2016DS'n/totadsl2017;

	ShiftMK = sum('2016MK'n, - '2017KMK'n); /* using sum a-b to get subtraction contain missing value */
	ShiftDS = sum('2016DS'n ,- '2017DS'n);

	ShiftMKpct = sum(pctMK2016, - pctMK2017);
	ShiftDSpct = sum(pctDS2016,- pctDS2017);

run;

/****************************************************/
/* show the top two cateogries increasing/decline */
/***************************************************/
proc sort data=txn_info_full;
	by Mbrship_id;
run;

proc summary data=txn_info_full nway;
	class Mbrship_id totadsl2017 totalds2016 totalmk2017 totalmk2016 Value_Segment2016 Value_Segment2017;
	var ShiftMKpct ShiftDSpct ShiftMK ShiftDS;
	
	where MCH_2_DESC_E not in ('OTC','Home','HBA','Apparel','Garden','Floral','Entertainment','Tobacco','Gas Bar');

	output out=txn_final_sevcat_only 
	idgroup(max(ShiftMKpct)out[2](MCH_2_DESC_E ShiftMKpct ShiftDSpct ShiftMK ShiftDS)=minMtoD minShiftMKpct minShiftDSpct minShiftMK minShiftDS)
	idgroup(min(ShiftDSpct)out[2](MCH_2_DESC_E ShiftDSpct ShiftMKpct ShiftMK ShiftDS)=maxDtoM maxShiftDSpct maxShiftMKpct maxShiftMK maxShiftDS);
run;

/* on absolute dollar change */
proc summary data=txn_info_full nway;
	class Mbrship_id totadsl2017 totalds2016 totalmk2017 totalmk2016 Value_Segment2016 Value_Segment2017;
	var ShiftMKpct ShiftDSpct ShiftMK ShiftDS;
	
	where MCH_2_DESC_E not in ('OTC','Home','HBA','Apparel','Garden','Floral','Entertainment','Tobacco','Gas Bar');

	output out=txn_final_sevcat_only 
	idgroup(max(ShiftMK)out[2](MCH_2_DESC_E ShiftMKpct ShiftDSpct ShiftMK ShiftDS)=minMtoD minShiftMKpct minShiftDSpct minShiftMK minShiftDS)
	idgroup(min(ShiftDS)out[2](MCH_2_DESC_E ShiftDSpct ShiftMKpct ShiftMK ShiftDS)=maxDtoM maxShiftDSpct maxShiftMKpct maxShiftMK maxShiftDS);
run;
/***************************/
/* filter out the customer */
/***************************/
proc sort data=ID;
	by Mbrship_id;
run;

proc sort data=txn_final_sevcat_only ;
	by Mbrship_id;
run;

data txn_shift_pct;
	merge ID(in=a) txn_final_sevcat_only (in=b);
	by Mbrship_id;

	if a=1 and b=1;
run;

