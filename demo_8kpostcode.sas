/********************************************************/
/* 			get the postcode info  						*/
/********************************************************/
proc sort data=panel8kdemo(keep='qmktsize_ca (q82_1)'n MembershipID) out=postcode;
	by MembershipID;
run;

proc sort data= masterlist_8k;
	by MembershipID;
run;

data panel8k_full;
 merge masterlist_8k(in=a) postcode;
 by MembershipID;

 if a=1;
run;


/**************************************/
/*	 standardize the post code  	 */
/************************************/
data postcode8ksd;
	set panel8k_full;

	format city $8.;

	postcode=upcase('qmktsize_ca (q82_1)'n);

	/*regex = "/\[A-Z]\d\[A-Z]\s?\d\[A-Z]\d/";*/

	if prxmatch("/[M]\d\w\s?\d\w\d/",trimn(postcode)) then city = "GTA";
	else							 								city = "others";

run;

