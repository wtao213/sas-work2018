/***********************************************/
/*  scatter plot for liquar    */
/********************************/
/***************************************/
/*  Full_Hoppy liquar scartter plot   */
/**************************************/
ods graphics on/width=9in height=8in;
/*symbol1 i=none f=market v=W c=antiquewhite h=1;
symbol2 i=none f=market v=W c=red h=1;*/
proc sgplot data=liquar_full;
	scatter x=Full_Hoppy_skun y=Full_Hoppy_index /datalabel=Store group=Store_info;
/*	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 0.5 by 0.1);*/
/*	loess  x=PLANNED y=IMPULSE /nomarkers;*/ /* add a smoothline to show the relation between the two variables */
	title "Full_Hoppy SKU vs index";
	ellipse x=Full_Hoppy_skun  y=Full_Hoppy_index ; 
run;
ods graphics off;

/***************************************/
/*  Full_Roasted liquar scartter plot   */
/**************************************/
ods graphics on/width=9in height=8in;
/*symbol1 i=none f=market v=W c=antiquewhite h=1;
symbol2 i=none f=market v=W c=red h=1;*/
proc sgplot data=liquar_full;
	scatter x=Full_Roasted_skun y=Full_Roasted_index /datalabel=Store group=Store_info;
/*	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 0.5 by 0.1);*/
/*	loess  x=PLANNED y=IMPULSE /nomarkers;*/ /* add a smoothline to show the relation between the two variables */
	title "Full_Roasted SKU vs index";
	ellipse x=Full_Roasted_skun  y=Full_Roasted_index ; 
run;
ods graphics off;

/***************************************/
/*  Light_Floral liquar scartter plot   */
/**************************************/
ods graphics on/width=9in height=8in;
/*symbol1 i=none f=market v=W c=antiquewhite h=1;
symbol2 i=none f=market v=W c=red h=1;*/
proc sgplot data=liquar_full;
	scatter x=Light_Floral_n  y=Light_Floral_index /datalabel=Store group=Store_info;
/*	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 0.5 by 0.1);*/
/*	loess  x=PLANNED y=IMPULSE /nomarkers;*/ /* add a smoothline to show the relation between the two variables */
	title "Light_Floral SKU vs index";
	ellipse x=Light_Floral_n   y=Light_Floral_index ; 
run;
ods graphics off;


/***************************************/
/*  Light_Fruity liquar scartter plot   */
/**************************************/
ods graphics on/width=9in height=8in;
/*symbol1 i=none f=market v=W c=antiquewhite h=1;
symbol2 i=none f=market v=W c=red h=1;*/
proc sgplot data=liquar_full;
	scatter x=Light_Fruity_skun  y=Light_Fruity_index /datalabel=Store group=Store_info;
/*	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 0.5 by 0.1);*/
/*	loess  x=PLANNED y=IMPULSE /nomarkers;*/ /* add a smoothline to show the relation between the two variables */
	title "Light_Fruity SKU vs index";
	ellipse x=Light_Fruity_skun   y=Light_Fruity_index ; 
run;
ods graphics off;


/***************************************/
/*  Light_Hoppy liquar scartter plot   */
/**************************************/
ods graphics on/width=9in height=8in;
/*symbol1 i=none f=market v=W c=antiquewhite h=1;
symbol2 i=none f=market v=W c=red h=1;*/
proc sgplot data=liquar_full;
	scatter x=Light_Hoppy_skun  y=Light_Hoppy_index /datalabel=Store group=Store_info;
/*	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 0.5 by 0.1);*/
/*	loess  x=PLANNED y=IMPULSE /nomarkers;*/ /* add a smoothline to show the relation between the two variables */
	title "Light_Hoppy SKU vs index";
	ellipse x=Light_Hoppy_skun   y=Light_Hoppy_index ; 
run;
ods graphics off;


/***************************************/
/*  Light_Malty liquar scartter plot   */
/**************************************/
ods graphics on/width=9in height=8in;
/*symbol1 i=none f=market v=W c=antiquewhite h=1;
symbol2 i=none f=market v=W c=red h=1;*/
proc sgplot data=liquar_full;
	scatter x=Light_Malty_sku  y=Light_Malty_index  /datalabel=Store group=Store_info;
/*	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 0.5 by 0.1);*/
/*	loess  x=PLANNED y=IMPULSE /nomarkers;*/ /* add a smoothline to show the relation between the two variables */
	title "Light_Malty SKU vs index";
	ellipse x=Light_Malty_sku   y=Light_Malty_index  ; 
run;
ods graphics off;


/***************************************/
/* Light_Spicy liquar scartter plot   */
/**************************************/
ods graphics on/width=9in height=8in;
/*symbol1 i=none f=market v=W c=antiquewhite h=1;
symbol2 i=none f=market v=W c=red h=1;*/
proc sgplot data=liquar_full;
	scatter x=Light_Spicy_sku  y=Light_Spicy_index  /datalabel=Store group=Store_info;
/*	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 0.5 by 0.1);*/
/*	loess  x=PLANNED y=IMPULSE /nomarkers;*/ /* add a smoothline to show the relation between the two variables */
	title "Light_Spicy SKU vs index";
	ellipse x=Light_Spicy_sku   y=Light_Spicy_index  ; 
run;
ods graphics off;


/***************************************/
/* Medium_Floral liquar scartter plot   */
/**************************************/
ods graphics on/width=9in height=8in;
/*symbol1 i=none f=market v=W c=antiquewhite h=1;
symbol2 i=none f=market v=W c=red h=1;*/
proc sgplot data=liquar_full;
	scatter x=Medium_Floral_sku  y=Medium_Floral_index  /datalabel=Store group=Store_info;
/*	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 0.5 by 0.1);*/
/*	loess  x=PLANNED y=IMPULSE /nomarkers;*/ /* add a smoothline to show the relation between the two variables */
	title "Medium_Floral SKU vs index";
	ellipse x=Medium_Floral_sku   y=Medium_Floral_index  ; 
run;
ods graphics off;



/***************************************/
/* Medium_Fruity liquar scartter plot   */
/**************************************/
ods graphics on/width=9in height=8in;
/*symbol1 i=none f=market v=W c=antiquewhite h=1;
symbol2 i=none f=market v=W c=red h=1;*/
proc sgplot data=liquar_full;
	scatter x=Medium_Fruity_sku  y=Medium_Floral_index  /datalabel=Store group=Store_info;
/*	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 0.5 by 0.1);*/
/*	loess  x=PLANNED y=IMPULSE /nomarkers;*/ /* add a smoothline to show the relation between the two variables */
	title "Medium_Fruity SKU vs index";
	ellipse x=Medium_Fruity_sku   y=Medium_Fruity_index  ; 
run;
ods graphics off;


/***************************************/
/* Medium_Hoppy liquar scartter plot   */
/**************************************/
ods graphics on/width=9in height=8in;
/*symbol1 i=none f=market v=W c=antiquewhite h=1;
symbol2 i=none f=market v=W c=red h=1;*/
proc sgplot data=liquar_full;
	scatter x=Medium_Hoppy_sku  y=Medium_Hoppy_index  /datalabel=Store group=Store_info;
/*	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 0.5 by 0.1);*/
/*	loess  x=PLANNED y=IMPULSE /nomarkers;*/ /* add a smoothline to show the relation between the two variables */
	title "Medium_Hoppy SKU vs index";
	ellipse x=Medium_Hoppy_sku   y=Medium_Hoppy_index  ; 
run;
ods graphics off;


/***************************************/
/* Medium_Malty liquar scartter plot   */
/**************************************/
ods graphics on/width=9in height=8in;
/*symbol1 i=none f=market v=W c=antiquewhite h=1;
symbol2 i=none f=market v=W c=red h=1;*/
proc sgplot data=liquar_full;
	scatter x=Medium_Malty_sku   y=Medium_Malty_index /datalabel=Store group=Store_info;
/*	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 0.5 by 0.1);*/
/*	loess  x=PLANNED y=IMPULSE /nomarkers;*/ /* add a smoothline to show the relation between the two variables */
	title "Medium_Malty SKU vs index";
	ellipse x=Medium_Malty_sku    y=Medium_Malty_index  ; 
run;
ods graphics off;


/***************************************/
/* Medium_Roasted liquar scartter plot   */
/**************************************/
ods graphics on/width=9in height=8in;
/*symbol1 i=none f=market v=W c=antiquewhite h=1;
symbol2 i=none f=market v=W c=red h=1;*/
proc sgplot data=liquar_full;
	scatter x=Medium_Roasted_sku    y=Medium_Roasted_index  /datalabel=Store group=Store_info;
/*	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 0.5 by 0.1);*/
/*	loess  x=PLANNED y=IMPULSE /nomarkers;*/ /* add a smoothline to show the relation between the two variables */
	title "Medium_Roasted SKU vs index";
	ellipse x=Medium_Roasted_sku   y=Medium_Roasted_index   ; 
run;
ods graphics off;



/***************************************/
/* Medium_Spicy liquar scartter plot   */
/**************************************/
ods graphics on/width=9in height=8in;
/*symbol1 i=none f=market v=W c=antiquewhite h=1;
symbol2 i=none f=market v=W c=red h=1;*/
proc sgplot data=liquar_full;
	scatter x=Medium_Spicy_sku    y=Medium_Spicy_index  /datalabel=Store group=Store_info;
/*	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 0.5 by 0.1);*/
/*	loess  x=PLANNED y=IMPULSE /nomarkers;*/ /* add a smoothline to show the relation between the two variables */
	title "Medium_Spicy SKU vs index";
	ellipse x=Medium_Spicy_sku  y=Medium_Spicy_index  ; 
run;
ods graphics off;






/*****************************************/
/* method2: macro to draw the graphs  */
/*******************************/
%Macro scartterliquar(x=,y=);
	ods graphics on/width=9in height=8in;

proc sgplot data=liquar_full;
	scatter x=&x    y=&y  /datalabel=Store group=Store_info;
	title "&x SKU vs index";
	ellipse x=&x    y=&y   ; 
run;
ods graphics off;
%mend scartterliquar;

%scartterliquar(x=Medium_Spicy_sku ,y=Medium_Spicy_index )