/**************************************************/
/* look at the customer total level info only  */
/************************************************/

data total;
 set Output3_Cross_Shop_MCH2;

 where MCH_2_DESC_E = 'Total';

run;

proc sort data=Output3_Cross_Shop_MCH2 out=full;
	by Mbrship_id MCH_2_DESC_E;
run;

proc transpose data=total out=full_sales;
	var SALES   /*Units   Txn  CB_SALES  CB_Units  CB_Txn*/;/* the variable want to see */
	by Mbrship_id MCH_2_DESC_E; /* the row indicator */
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