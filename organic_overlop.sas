/*********************************************************/
/*      organic overlop with blue menu and free from    */
/*********************************************************/

/**************************************************/
/*	 filter out all 000 in flags 	*/
/*************************************/
data new(drop=Sales1 Sales2 Sales3 Sales4 Units1 Units2 Units3 Units4 Txn1 Txn2 Txn3 Txn4);
	set Organics_pull_nb_2;

	where OrgncShpd =1 or FreeShpd =1 or BlueShpd =1;

	salesorganic =sum(SalesOrgnc1,SalesOrgnc2,SalesOrgnc3 ,SalesOrgnc4);

	salesFF = sum(SalesFF1 ,SalesFF2 ,SalesFF3 ,SalesFF4);

	salesBM = sum(SalesBM1,SalesBM2,SalesBM3,SalesBM4);

	salesTT = sum(SalesTtl1 ,SalesTtl2 ,SalesTtl3 ,SalesTtl4);

	orgtxn = sum(TxnOrgnc1,TxnOrgnc2,TxnOrgnc3,TxnOrgnc4);

	BMtxn = sum(TxnBM1,TxnBM2,TxnBM3,TxnBM4);

	FFtxn = sum(TxnFF1,TxnFF2,TxnFF3,TxnFF4);
	
	healthfood = sum(salesorganic,salesBM,salesFF);

	healthpen= healthfood/salesTT;
run;

data healthy_pen;
	set new;

	where healthpen > 0.2;
run;

/**********************************/
/*	 	distribution check 		*/
/**********************************/
proc univariate data=new ;
	var salesTT salesorganic salesFF salesBM;
	histogram salesTT salesorganic salesFF salesBM/normal;
run;


/*******************************/
/* check the frequency of buying */
/*********************************/
proc tabulate data=new missing;
	class OrgncShpd  FreeShpd  BlueShpd;
	var SalesOrgnc1 SalesOrgnc2 SalesOrgnc3 SalesOrgnc4 SalesFF1 SalesFF2 SalesFF3 SalesFF4 SalesBM1 SalesBM2 SalesBM3 SalesBM4
SalesTtl1 SalesTtl2 SalesTtl3 SalesTtl4 salesorganic salesFF salesBM salesTT orgtxn;

	tables OrgncShpd all,(FreeShpd*BlueShpd all)*(n rowpctn);

	tables OrgncShpd*FreeShpd*BlueShpd all,(salesorganic salesFF salesBM salesTT)*(sum colpctsum n colpctn mean)/
		box='everyone shopped health food';
run;


/***********************************/
/* filter down on organic shopper  */
/***********************************/
/*****************************************/
/* filter1: shopped loblaws each quarter */
/*****************************************/

proc tabulate data=new missing;
	class OrgncShpd  FreeShpd  BlueShpd;
	var SalesOrgnc1 SalesOrgnc2 SalesOrgnc3 SalesOrgnc4 SalesFF1 SalesFF2 SalesFF3 SalesFF4 SalesBM1 SalesBM2 SalesBM3 SalesBM4
SalesTtl1 SalesTtl2 SalesTtl3 SalesTtl4 salesorganic salesFF salesBM salesTT ;

	where SalesTtl1>0 and SalesTtl2>0 and SalesTtl3>0 and SalesTtl4>0;

	tables OrgncShpd*FreeShpd*BlueShpd all,(salesorganic salesFF salesBM salesTT)*(sum colpctsum n colpctn mean)/
		box='shopping every quarter';
run;

/*****************************************/
/* filter1: shopped organic each quarter */
/*****************************************/

proc tabulate data=new missing;
	class OrgncShpd  FreeShpd  BlueShpd;
	var SalesOrgnc1 SalesOrgnc2 SalesOrgnc3 SalesOrgnc4 SalesFF1 SalesFF2 SalesFF3 SalesFF4 SalesBM1 SalesBM2 SalesBM3 SalesBM4
SalesTtl1 SalesTtl2 SalesTtl3 SalesTtl4 salesorganic salesFF salesBM salesTT ;

	where SalesOrgnc1>0 and SalesOrgnc2>0 and SalesOrgnc3>0 and SalesOrgnc4>0;

	tables OrgncShpd*FreeShpd*BlueShpd all,(salesorganic salesFF salesBM salesTT)*(sum colpctsum n colpctn mean)/
		box='shopped organic every quarter';
run;

/*****************************************************/
/* filter2: shopped organic $20 or more each quarter */
/*****************************************************/

proc tabulate data=new missing;
	class OrgncShpd  FreeShpd  BlueShpd;
	var SalesOrgnc1 SalesOrgnc2 SalesOrgnc3 SalesOrgnc4 SalesFF1 SalesFF2 SalesFF3 SalesFF4 SalesBM1 SalesBM2 SalesBM3 SalesBM4
SalesTtl1 SalesTtl2 SalesTtl3 SalesTtl4 salesorganic salesFF salesBM salesTT ;

	where SalesOrgnc1>=20 and SalesOrgnc2>=20 and SalesOrgnc3>=20 and SalesOrgnc4>=20;

	tables OrgncShpd*FreeShpd*BlueShpd all,(salesorganic salesFF salesBM salesTT)*(sum colpctsum n colpctn mean)/
		box='organic >$20 every quarter';
run;

/*****************************************************/
/* filter3: shopped organic more than 52 time a year */
/*****************************************************/

proc tabulate data=new missing;
	class OrgncShpd  FreeShpd  BlueShpd;
	var SalesOrgnc1 SalesOrgnc2 SalesOrgnc3 SalesOrgnc4 SalesFF1 SalesFF2 SalesFF3 SalesFF4 SalesBM1 SalesBM2 SalesBM3 SalesBM4
SalesTtl1 SalesTtl2 SalesTtl3 SalesTtl4 salesorganic salesFF salesBM salesTT orgtxn ;

	where orgtxn>=52 and SalesOrgnc1>=20 and SalesOrgnc2>=20 and SalesOrgnc3>=20 and SalesOrgnc4>=20;

	tables OrgncShpd*FreeShpd*BlueShpd all,(salesorganic salesFF salesBM salesTT)*(sum='sales' colpctsum='sales pct' n='cus count' colpctn='count pct' mean='sales/cus')/
		box='organic txn >52';
run;







/*************************************************/
/* 		check to another way: FF,BM				*/
/************************************************/
/*****************************************/
/* filter1: shopped loblaws each quarter */
/*****************************************/

proc tabulate data=new missing;
	class OrgncShpd  FreeShpd  BlueShpd;
	var SalesOrgnc1 SalesOrgnc2 SalesOrgnc3 SalesOrgnc4 SalesFF1 SalesFF2 SalesFF3 SalesFF4 SalesBM1 SalesBM2 SalesBM3 SalesBM4
SalesTtl1 SalesTtl2 SalesTtl3 SalesTtl4 salesorganic salesFF salesBM salesTT ;

	where SalesTtl1>0 and SalesTtl2>0 and SalesTtl3>0 and SalesTtl4>0;

	tables OrgncShpd*FreeShpd*BlueShpd all,(salesorganic salesFF salesBM salesTT)*(sum colpctsum n colpctn mean)/
		box='shopping every quarter';
run;

/*****************************************/
/* filter1: shopped FF each quarter */
/*****************************************/

proc tabulate data=new missing;
	class OrgncShpd  FreeShpd  BlueShpd;
	var SalesOrgnc1 SalesOrgnc2 SalesOrgnc3 SalesOrgnc4 SalesFF1 SalesFF2 SalesFF3 SalesFF4 SalesBM1 SalesBM2 SalesBM3 SalesBM4
SalesTtl1 SalesTtl2 SalesTtl3 SalesTtl4 salesorganic salesFF salesBM salesTT ;

	where SalesFF1>0 and SalesFF2>0 and SalesFF3>0 and SalesFF4>0;

	tables OrgncShpd*FreeShpd*BlueShpd all,(salesorganic salesFF salesBM salesTT)*(sum colpctsum n colpctn mean)/
		box='shopped FF every quarter';
run;

/*****************************************************/
/* filter2: shopped FF $20 or more each quarter  */
/*****************************************************/

proc tabulate data=new missing;
	class OrgncShpd  FreeShpd  BlueShpd;
	var SalesOrgnc1 SalesOrgnc2 SalesOrgnc3 SalesOrgnc4 SalesFF1 SalesFF2 SalesFF3 SalesFF4 SalesBM1 SalesBM2 SalesBM3 SalesBM4
SalesTtl1 SalesTtl2 SalesTtl3 SalesTtl4 salesorganic salesFF salesBM salesTT ;

	where SalesFF1>=20 and SalesFF2>=20 and SalesFF3>=20 and SalesFF4>=20;

	tables OrgncShpd*FreeShpd*BlueShpd all,(salesorganic salesFF salesBM salesTT)*(sum colpctsum n colpctn mean)/
		box='FF >$20 every quarter';
run;

/*****************************************************/
/* filter3: shopped organic more than 52 time a year */
/*****************************************************/

proc tabulate data=new missing;
	class OrgncShpd  FreeShpd  BlueShpd;
	var SalesOrgnc1 SalesOrgnc2 SalesOrgnc3 SalesOrgnc4 SalesFF1 SalesFF2 SalesFF3 SalesFF4 SalesBM1 SalesBM2 SalesBM3 SalesBM4
SalesTtl1 SalesTtl2 SalesTtl3 SalesTtl4 salesorganic salesFF salesBM salesTT orgtxn BMtxn FFtxn;

	where FFtxn>=52 and SalesFF1>=20 and SalesFF2>=20 and SalesFF3>=20 and SalesFF4>=20;

	tables OrgncShpd*FreeShpd*BlueShpd all,(salesorganic salesFF salesBM salesTT)*(sum='sales' colpctsum='sales pct' n='cus count' colpctn='count pct' mean='sales/cus')/
		box='FF txn >52';
run;






/*************************************************/
/* 		check to another way: FF,BM				*/
/************************************************/

/*****************************************/
/* filter1: shopped loblaws each quarter */
/*****************************************/

proc tabulate data=new missing;
	class OrgncShpd  FreeShpd  BlueShpd;
	var SalesOrgnc1 SalesOrgnc2 SalesOrgnc3 SalesOrgnc4 SalesFF1 SalesFF2 SalesFF3 SalesFF4 SalesBM1 SalesBM2 SalesBM3 SalesBM4
SalesTtl1 SalesTtl2 SalesTtl3 SalesTtl4 salesorganic salesFF salesBM salesTT ;

	where SalesTtl1>0 and SalesTtl2>0 and SalesTtl3>0 and SalesTtl4>0;

	tables OrgncShpd*FreeShpd*BlueShpd all,(salesorganic salesFF salesBM salesTT)*(sum colpctsum n colpctn mean)/
		box='shopping every quarter';
run;

/*****************************************/
/* filter1: shopped BM each quarter */
/*****************************************/

proc tabulate data=new missing;
	class OrgncShpd  FreeShpd  BlueShpd;
	var SalesOrgnc1 SalesOrgnc2 SalesOrgnc3 SalesOrgnc4 SalesFF1 SalesFF2 SalesFF3 SalesFF4 SalesBM1 SalesBM2 SalesBM3 SalesBM4
SalesTtl1 SalesTtl2 SalesTtl3 SalesTtl4 salesorganic salesFF salesBM salesTT ;

	where SalesBM1>0 and SalesBM2>0 and SalesBM3>0 and SalesBM4>0;

	tables OrgncShpd*FreeShpd*BlueShpd all,(salesorganic salesFF salesBM salesTT)*(sum colpctsum n colpctn mean)/
		box='shopped BM every quarter';
run;

/*****************************************************/
/* filter2: shopped BM $20 or more each quarter 	*/
/*****************************************************/

proc tabulate data=new missing;
	class OrgncShpd  FreeShpd  BlueShpd;
	var SalesOrgnc1 SalesOrgnc2 SalesOrgnc3 SalesOrgnc4 SalesFF1 SalesFF2 SalesFF3 SalesFF4 SalesBM1 SalesBM2 SalesBM3 SalesBM4
SalesTtl1 SalesTtl2 SalesTtl3 SalesTtl4 salesorganic salesFF salesBM salesTT ;

	where SalesBM1>=20 and SalesBM2>=20 and SalesBM3>=20 and SalesBM4>=20;

	tables OrgncShpd*FreeShpd*BlueShpd all,(salesorganic salesFF salesBM salesTT)*(sum colpctsum n colpctn mean)/
		box='BM >$20 every quarter';
run;

/*****************************************************/
/* filter3: shopped B more than 52 time a year */
/*****************************************************/

proc tabulate data=new missing;
	class OrgncShpd  FreeShpd  BlueShpd;
	var SalesOrgnc1 SalesOrgnc2 SalesOrgnc3 SalesOrgnc4 SalesFF1 SalesFF2 SalesFF3 SalesFF4 SalesBM1 SalesBM2 SalesBM3 SalesBM4
SalesTtl1 SalesTtl2 SalesTtl3 SalesTtl4 salesorganic salesFF salesBM salesTT orgtxn ;

	where BMtxn>=52 and SalesBM1>=20 and SalesBM2>=20 and SalesBM3>=20 and SalesBM4>=20;

	tables OrgncShpd*FreeShpd*BlueShpd all,(salesorganic salesFF salesBM salesTT)*(sum='sales' colpctsum='sales pct' n='cus count' colpctn='count pct' mean='sales/cus')/
		box='BM txn >52';
run;



/*******************************************************/
/* full filter on best of three */
/*****************************************************/
/*****************************************************/
/* filter2: shopped organic/BB/FM $20 or more each quarter */
/*****************************************************/

proc tabulate data=new missing;
	class OrgncShpd  FreeShpd  BlueShpd;
	var SalesOrgnc1 SalesOrgnc2 SalesOrgnc3 SalesOrgnc4 SalesFF1 SalesFF2 SalesFF3 SalesFF4 SalesBM1 SalesBM2 SalesBM3 SalesBM4
SalesTtl1 SalesTtl2 SalesTtl3 SalesTtl4 salesorganic salesFF salesBM salesTT ;

	where SalesOrgnc1>=20 and SalesOrgnc2>=20 and SalesOrgnc3>=20 and SalesOrgnc4>=20 and SalesBM1>=20 
	and SalesBM2>=20 and SalesBM3>=20 and SalesBM4>=20 and SalesFF1>=20 and SalesFF2>=20 and SalesFF3>=20 and SalesFF4>=20;

	tables OrgncShpd*FreeShpd*BlueShpd all,(salesorganic salesFF salesBM salesTT)*(sum colpctsum n colpctn mean)/
		box='organic >$20 every quarter';
run;