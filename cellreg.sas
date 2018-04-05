
/************************************/
/*		standardize the cell phone */
/************************************/
data test;
 set phones;

 digit= compress(phone,,'kd');

 lenth=length(digit);

 If lenth=10 then valid_check=digit;
 else			  valid_check=".";	

run;

/* using regex */

data test1;
	set phones;

	/* test whether valid phone, return 1 is valid, 0 is not valid */
	test=prxmatch("/\(?\d{3}\)?\-?\d{3}\-?\d{4}/",phone); /* 11 digit doesn't capture*/
	test1=prxmatch("/^\(?\d{3}\)?\-?\d{3}\-?\d{4}$/",phone); /* string spaces didn't move */
	test3=prxmatch("/^\(*\d{3}\)*\-*\d{3}\-*\d{4}$/",trimn(phone));/* need trim to remove space!!!*/

	valid = prxparse("/^\(?(\d{3})\)?\-?(\d{3}\-?\d{4})$/");

    /* replace regex to a certain string "valid" */
	change= prxchange('s/^\(?\d{3}\)?\-?\d{3}\-?\d{4}$/valid/',-1,trimn(phone));

	/* if it is a valid number, then return area code */
	if prxmatch(valid,trimn(phone)) then area = prxposn(valid,1,trimn(phone));
	else								 area = . ;

run;






/* part 1: solution */
data cell_sd;
	set phones;

	valid = prxparse("/^\(?(\d{3})\)?\-?(\d{3}\-?\d{4})$/");

	if prxmatch(valid,trimn(phone)) then area = prxposn(valid,1,trimn(phone));
	else								 area = . ;

	drop valid;
run;





/************************************/
/* check freq */
/*********************/
proc sort data= cell_sd;
	by area;
run;

proc sort data= ac_region(rename=(areacode=area)) out=new;
 by area;
run;

 data test2;
  merge cell_sd new;
  by area;
run;

proc freq data=test2;
 tables area region/missing;
run;


/***********************************/
/* try to use hash to show results */
/***********************************/
data lookup;
	if 0 then set cell_sd;

	dcl hash province(dataset:'cell_sd');
	province.DefineKey('area'); /* defineKey specifies which variables  used to llokup data from hash table based on the incoming data */
	province.DefineData('phone'); /* specifies what data to grab from the hash table and load into the output data set */
	province.definedone(); /* tells SAS the hash table definition is done.*/
	call missing(area);

	do until (eof);
		set ac_region end=eof;
		/*phone = '';*/
		/*area = areacode;*/
		do lookups = 1 by 1 until (pr ne 0 or lookups>1000);
		pr = province.find(); /* find() performs the hash lookup */
		/*area = region;*/
	end;
	output;
	end;
	stop;
run;

data lookup;
	if _n_=0 then do;

	dcl hash province(dataset:'cell_sd');
	province.DefineKey('area'); /* defineKey specifies which variables  used to llokup data from hash table based on the incoming data */
	province.DefineData('phone'); /* specifies what data to grab from the hash table and load into the output data set */
	province.defineDone(); /* tells SAS the hash table definition is done.*/
    end;
	
	set ac_region;
    pr = province.find(); 
	if pr = 0 then put d=;
	else 			put "not found";
	stop;
run;


data lookup;
	if 0 then set cell_sd;

	dcl hash province(dataset:'cell_sd');
	province.DefineKey('area'); /* defineKey specifies which variables  used to llokup data from hash table based on the incoming data */
	province.DefineData('phone'); /* specifies what data to grab from the hash table and load into the output data set */
	province.definedone(); /* tells SAS the hash table definition is done.*/
	call missing(area);

	do until (eof);
		set ac_region end=eof;
		
		rc = province.find(); /* find() performs the hash lookup */
		if ( rc !=0 ) then rc = province.add();
	output;
	end;
	stop;
run;