/** replicate for discount info **/
proc sort data=WORK.DS_CUS_0222;
by cons_wallt_id Seg2017 Seg2018 Mike_Class;
run;

proc transpose data=WORK.DS_CUS_0222
	out=ds_ot(drop= _NAME_ _LABEL_) prefix= ds_sales;
by cons_wallt_id Seg2017 Seg2018 Mike_Class;
id CORP_YR_NUM CORP_PD_NUM;
var ds_sales;
run;

data df;
 set ds_cus;
 where ds_sales = 0;
run;

proc datasets library=work;
   delete df;
run;



/** remove duplicate  **/
/**  1,574,071 customers    559,015 are attrition, 1,015,056 are new **/
proc sort data=WORK.DS_CUS_0222
 out=ct nodupkey;
 by cons_wallt_id;
run;

proc freq data=ct;
 tables   Mike_Class;
run;

proc datasets library=work;
   delete ct;
run;



/** combine market and discont info **/



proc sort data=ds_ot;
by cons_wallt_id Seg2017 Seg2018 Mike_Class ;
run;


proc sort data=MK_OT_173_192;
by cons_wallt_id Seg2017 Seg2018 Mike_Class;
run;

/** get the full info of customers **/
data full;
 merge MK_OT_173_192 ds_ot;
 by cons_wallt_id Seg2017 Seg2018 Mike_Class;
run;



/** check the frequency for discount info **/
/** using arrary to sum ds and mk together **/
data full_v2;
	set full;

	array mk{26} '20173'n  '20174'n  '20175'n '20176'n '20177'n '20178'n  '20179'n '201710'n '201711'n '201712'n  '201713'n            
'20181'n	'20182'n	'20183'n	'20184'n	'20185'n	'20186'n	'20187'n	'20188'n	'20189'n	'201810'n	'201811'n	'201812'n	'201813'n	'20191'n '20192'n    ;
	array ds{26} ds_sales20173	ds_sales20174	ds_sales20175	ds_sales20176	ds_sales20177	ds_sales20178	ds_sales20179	ds_sales201710	ds_sales201711	ds_sales201712	ds_sales201713	ds_sales20181	ds_sales20182	ds_sales20183	ds_sales20184	ds_sales20185	ds_sales20186	ds_sales20187	ds_sales20188	ds_sales20189	ds_sales201810	ds_sales201811	ds_sales201812	ds_sales201813	ds_sales20191 ds_sales20192 ;
	array ttl{26} ttl_sales20173	ttl_sales20174	ttl_sales20175	ttl_sales20176	ttl_sales20177	ttl_sales20178	ttl_sales20179	ttl_sales201710	ttl_sales201711	ttl_sales201712	ttl_sales201713	ttl_sales20181	ttl_sales20182	ttl_sales20183	ttl_sales20184	ttl_sales20185	ttl_sales20186	ttl_sales20187	ttl_sales20188	ttl_sales20189	ttl_sales201810	ttl_sales201811	ttl_sales201812	ttl_sales201813	ttl_sales20191 ttl_sales20192 ;

	do i =1 to 26;
	 ttl{i} = sum(mk{i},ds{i});
	end;

	drop i;
run;


/**   Feb 26th, 2019 	**/
/**	sum of only 0-9 no 11,12 13	 makre	**/

data FULL_mk_ds_ttl;
	set FULL_mk_ds_ttl;

	market_sales = sum(of '20173'n-'20192'n,'201710'n,'201711'n,'201712'n,'201713'n,'201810'n,'201811'n,'201812'n,'201813'n);
	ds_sales = sum(of ds_sales20173-ds_sales20192,ds_sales201710,ds_sales201711,ds_sales201712,ds_sales201713,ds_sales201810,ds_sales201811,ds_sales201812,ds_sales201813);
	ttl_sales= sum(of ttl_sales20173-ttl_sales20192,ttl_sales201710,ttl_sales201711,ttl_sales201712,ttl_sales201713,ttl_sales201810,ttl_sales201811,ttl_sales201812,ttl_sales201813);
	drop  '20180'n '20190'n ds_sales20190 ds_sales20180 ttl_sales20180 ttl_sales20190;
run;



/**    merge key attribute together **/
proc sort data=CUS_INFO( keep=cons_wallt_id last_txn_pd first_txn_pd freq_pd);
	by cons_wallt_id ;
run;

proc sort data= FULL_mk_ds_ttl;
	by cons_wallt_id ;
run;

data master_full;
	merge CUS_INFO FULL_mk_ds_ttl;
	by cons_wallt_id ;
run;

data master_full;
	set master_full;

 If (ds_sales >0 or ds_sales< 0) then shop_type = "cross";
 else				 			      shop_type = "";

 If ds_sales = . or ds_sales =0  then main = "mk only";
 else if ds_sales > market_sales then main = "ds";
 else						          main = "mk";	
run;

/** check your number **/
data xx;
 set master_full;
where shop_type = "" and main in ("ds","mk");
run;


proc datasets library=work;
   delete xx FULL_mk_ds_ttl;
run;


data master_full;
 set master_full;

 if Mike_Class = "new" and first_txn_pd in(201703:201709,201710:201713,201801:201808) 	   then def = "new shopped before";
 else if Mike_Class = "attrition" and last_txn_pd in (201809,201810:201813,201902,201901) then def = "att shopped after";
 else 													  									def = "";

run;



/** tabulate check results **/
proc tabulate data=master_full missing;
	class cons_wallt_id shop_type main Seg2017 Seg2018 Mike_Class def last_txn_pd first_txn_pd;
	var ds_sales  market_sales  freq_pd;
	
	table shop_type all,Mike_Class*(n colpctn);
	table main all,Mike_Class*(n colpctn);
	table Seg2017 all,Mike_Class*(n colpctn);
	table Seg2018,Mike_Class*(n colpctn);
	table first_txn_pd all,Mike_Class*(n colpctn);
	table last_txn_pd all,Mike_Class*(n colpctn);
	
	table def, Mike_Class*(n colpctn);
	table def*(shop_type all), Mike_Class*(n colpctn);
	table def*(main all), Mike_Class*(n colpctn);
	table def*(Seg2017 all),Mike_Class*(n colpctn);
	table def*(Seg2018 all),Mike_Class*(n colpctn);

run;


/** check whether the customer is true attrition **/
proc tabulate data=master_full missing;
	class cons_wallt_id shop_type main Seg2017 Seg2018 Mike_Class def last_txn_pd first_txn_pd;
	var ds_sales  market_sales  freq_pd;
	
	where def = "" and Seg2017 in ("SuperHigh","High");

	table shop_type all,Mike_Class*(n colpctn);
	
	table main all,Mike_Class*(n colpctn);
run;

/**			**/
data att;
	set master_full;
where def = "" and Seg2017 in ("SuperHigh","High");

ds_sales_af = sum(of ds_sales201810,ds_sales201811,ds_sales201812,ds_sales201813,ds_sales20192,ds_sales20191);

if ds_sales_af = . or ds_sales_af = 0 then  at_type = "real attrition";
else 										at_type = "ds shop after";

af_freq = 6 - cmiss(ds_sales201810,ds_sales201811,ds_sales201812,ds_sales201813,ds_sales20192,ds_sales20191);
run;


proc tabulate data=att missing;
	class cons_wallt_id shop_type main Seg2017 Seg2018 Mike_Class def last_txn_pd first_txn_pd at_type af_freq ;
	var ds_sales  market_sales  freq_pd ds_sales_af;

	table main all,Mike_Class*(n colpctn);
	table at_type all,Mike_Class*(n colpctn);
	
	table af_freq all,Mike_Class*(n colpctn);
run;


/** return the last column'name of the last txn period **/
data att;
 set att;
array list{26} ttl_sales20173	ttl_sales20174	ttl_sales20175	ttl_sales20176	ttl_sales20177	ttl_sales20178	ttl_sales20179	ttl_sales201710	ttl_sales201711	ttl_sales201712	ttl_sales201713	ttl_sales20181	ttl_sales20182	ttl_sales20183	ttl_sales20184	ttl_sales20185	ttl_sales20186	ttl_sales20187	ttl_sales20188	ttl_sales20189	ttl_sales201810	ttl_sales201811	ttl_sales201812	ttl_sales201813	ttl_sales20191 ttl_sales20192 ;
where Mike_Class = "attrition";

ttl = "none shop record for ttl";
do i = 1 to 26;
if missing (list[i]) then ttl = ttl;
else					   ttl = vname(list[i]);
end;
drop i;
run;


proc tabulate data=new missing;
	class cons_wallt_id shop_type main Seg2017 Seg2018 Mike_Class def last_txn_pd first_txn_pd at_type af_freq ttl;
	var ds_sales  market_sales  freq_pd ds_sales_af;

	table main all,Mike_Class*(n colpctn);
	table at_type all,Mike_Class*(n colpctn);
	table af_freq all,Mike_Class*(n colpctn);

	table last_txn_pd all,Mike_Class*(n colpctn);
	table ttl all,Mike_Class*(n colpctn);

run;

proc freq data= new;
 where at_type = "real attrition";
 tables last_txn_pd ttl;
run;