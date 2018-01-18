
/***********************************************/
/* test normal distribution */
/********************************/

proc univariate data=normal_check ;
	var Conventional       Discount  'All Channel'n  'LCL Market'n   'All Channel_0002'n
        Conventional_0001  Discount_0001 'All Channel_0001'n 'LCL Market_0001'n 'LCL Market_0002'n I J;
	histogram Conventional       Discount  'All Channel'n  'LCL Market'n   'All Channel_0002'n
        Conventional_0001  Discount_0001 'All Channel_0001'n 'LCL Market_0001'n 'LCL Market_0002'n I J /normal;
run;


/*********************************************/
/* plots for the survey  planned vs impulse  */
/*********************************************/
/*********************************************************************************/
/* if only want to show the outliers, create a list, only show names for outliers*/
/*********************************************************************************/

data sampleplan_impulse;
	set sampleplan_impulse1;

do i=1 to 180;
   x = PLANNED;
   y = IMPULSE;
   dist = euclid(x,y);
   if dist <= 0.5 then dist = .;
   output;
end;
run;

ods graphics on/width=9in height=8in;
/*symbol1 i=none f=market v=W c=antiquewhite h=1;
symbol2 i=none f=market v=W c=red h=1;*/
proc sgplot data=sampleplan_impulse1;
	scatter x=PLANNED y=IMPULSE /datalabel=LEVEL_OF_PLANNING group=groups;
	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 0.5 by 0.1);
	title "category planned vs impulse";
	/*ellipse x=PLANNED y=IMPULSE /type=mean;*/
run;
ods graphics off;


ods graphics on/width=9in height=8in;
/*symbol1 i=none f=market v=W c=antiquewhite h=1;
symbol2 i=none f=market v=W c=red h=1;*/
proc sgplot data=sampleplan_impulse;
	scatter x=PLANNED y=IMPULSE /datalabel=LEVEL_OF_PLANNING group=groups;
	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 0.5 by 0.1);
/*	loess  x=PLANNED y=IMPULSE /nomarkers;*/ /* add a smoothline to show the relation between the two variables */
	title "category planned vs impulse";
	ellipse x=PLANNED y=IMPULSE ; 
run;
ods graphics off;


/********************************************/
/*			 creating template  			*/
/*******************************************/
proc template; *STARTS PROC TEMPLATE;
define statgraph scatdens2; *DEFINES A GRAPH TO BE CALL SCATDENS;
begingraph; *BEGIN DEFINING THE GRAPH;
entrytitle "planned vs impulse Scatter plot with density plots"; *CREATE A TITLE;
layout lattice/columns = 2 rows = 2 columnweights = (.8 .2) rowweights = (.8 .2)
columndatarange = union rowdatarange = union;
/*LAYOUT LATTICE/COLUMNS = 2 ROWS = 2 SETS UP A GRID, OR LATTICE, OF GRAPHS*/
/*COLUMNWEIGHTS AND ROWWEIGHTS SETS THE RELATIVE SIZE OF THE INDIVIDUAL COLUMNS AND ROWS*/
columnaxes;
columnaxis /label = "PLANNED (%)" griddisplay = on;
columnaxis /label = "" griddisplay = on;
endcolumnaxes;
*COLUMNAXES SETS THE CHARACTERISTICS OF COLUMNS;
/*THE SECOND ONE HAS NO LABEL (NONE WOULD FIT)*/
rowaxes;
rowaxis /label = "IMPULSE (%)" griddisplay = on;
rowaxis /label = "" griddisplay = on;
endrowaxes;


layout overlay; /*STARTS THE ACTUAL GRAPHING OF DOTS AND SUCH*/
scatterplot x = PLANNED y = IMPULSE/datalabel=LEVEL_OF_PLANNING group=groups; *GRAPHS THE DOTS;
title "planned vs. impulse";
/*loessplot x = PLANNED y = IMPULSE/nomarkers;
loessplot x =PLANNED y = IMPULSE/smooth = 1 nomarkers;*/
ellipse x = PLANNED y = IMPULSE/type = predicted alpha=0.1;
endlayout;

densityplot IMPULSE/orient = horizontal;
densityplot PLANNED;
endlayout;
endgraph;
end;
run;

ods graphics on/width=9in height=8in;
proc sgrender data = sampleplan_impulse template = scatdens2;
run;
ods graphics off;
