/********************************************************************/
/* check whether there is any brand outstanding from the categories */
/********************************************************************/
/* sgplot histogram is giving the frequency count */
ods graphics on;
proc sgplot data=LCL_Data_Pull_AC_CON1;
	where Subcategory = "ALL OTHER BABY ACCESSORIES" and Brand_name ~="All";
	scatter x=Brand_name y=Sales_Dollars ;
	title "Brand for ALL OTHER BABY ACCESSORIES";
	xaxis display=none;
	yaxis label="sales for certain brand" ;
	footnote "AC Conv";
run;
ods graphics off;

ods select ExtremeObs;
proc univariate data=LCL_Data_Pull_AC_CON1 nextrobs=10;/* difference between nextrobs he nextrval */
	where Subcategory = "ALL OTHER BABY ACCESSORIES" and Brand_name ~="All";;
   var Sales_Dollars;
   id Brand_name;  /*show the name of category */
run;


/*********************************************************/
/* use macro to get the scartter plot and outlier tables */
/*********************************************************/
%macro brand_scatter(data=,subcategory=,y=);
proc sgplot data=&data;
	where Subcategory = &subcategory and Brand_name ~="All";
	scatter x=Brand_name y=&y ;
	title "Brand for ALL OTHER BABY ACCESSORIES";
	xaxis display=none;
	yaxis label="sales for certain brand" ;
	footnote "AC Conv";
run;


title 'Extreme &subcategory Observations';
ods select ExtremeObs;
proc univariate data=&data nextrobs=11;/* difference between nextrobs he nextrval */
	where Subcategory = &subcategory /*and Brand_name ~="All"*/;
   var &y;
   id Brand_name;  /*show the name of category */
run;
%mend brand_scatter;


%brand_scatter(data=LCL_Data_Pull_AC_CON1,subcategory="ALL OTHER BABY ACCESSORIES",y=Sales_Dollars)


/**************************************************************/
/* try to have a do loop for sgplot */
/****************************************/

%macro brand_scatter_look(mylist);

   %let n = %sysfunc(countw(&mylist));
   %do I=1 %to &n;
   %let val = %scan(&mylist,&I);

      data LCL_Data_Pull_AC_CON1_&val;
         set LCL_Data_Pull_AC_CON1;
         where Subcategory = "&val";
      run;

	proc sgplot data=LCL_Data_Pull_AC_CON1_&val;
	where Brand_name ~="All";
	scatter x=Brand_name y=Sales_Dollars ;
	title "Brand for category";
	xaxis display=none;
	yaxis label="sales for certain brand" ;
	footnote "AC Conv";
	run;

	ods select ExtremeObs;
	proc univariate data=LCL_Data_Pull_AC_CON1_&val nextrobs=11;/* difference between nextrobs he nextrval */
   	var Sales_Dollars;
   	id Brand_name;  /*show the name of category */
	run;
   %end;
%mend brand_scatter_look;


%brand_scatter_look(%str(HOSIERY,INNERWEAR,PURGE))



/**************************************************************/
/*   try to have a do loop for sgplot type 2, more options    */
/**************************************************************/

%macro brand_scatter_lookv2(mylist,data=,y=);

   %let n = %sysfunc(countw(&mylist));
   %do I=1 %to &n;
   %let val = %scan(&mylist,&I);

      data LCL_Data_Pull_AC_CON1_&val;
         set &data;
         where Subcategory = "&val";
      run;

	proc sgplot data=LCL_Data_Pull_AC_CON1_&val;
	where Brand_name ~="All";
	scatter x=Brand_name y=&y ;
	title "Brand for category";
	xaxis display=none;
	yaxis label="sales for certain brand" ;
	footnote "AC Conv";
	run;

	ods select ExtremeObs;
	proc univariate data=LCL_Data_Pull_AC_CON1_&val nextrobs=11;/* difference between nextrobs he nextrval */
   	var &y;
   	id Brand_name;  /*show the name of category */
	run;
   %end;
%mend brand_scatter_lookv2;


%brand_scatter_lookv2(%str(HOSIERY,INNERWEAR,PURGE),data=LCL_Data_Pull_AC_CON1,y=Sales_Dollars)