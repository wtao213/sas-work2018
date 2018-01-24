
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
/*			 creating template  		   */
/*******************************************/
proc template; *STARTS PROC TEMPLATE;
define statgraph scatdens2; *DEFINES A GRAPH TO BE CALL SCATDENS;
	begingraph; *BEGIN DEFINING THE GRAPH;
		entrytitle "planned vs impulse Scatter plot with density plots"; *CREATE A TITLE;
			layout lattice/columns = 2 rows = 2 columnweights = (.8 .2) rowweights = (.8 .2)
			columndatarange= union rowdatarange = union;
			/*LAYOUT LATTICE/COLUMNS = 2 ROWS = 2 SETS UP A GRID, OR LATTICE, OF GRAPHS*/
			/*COLUMNWEIGHTS AND ROWWEIGHTS SETS THE RELATIVE SIZE OF THE INDIVIDUAL COLUMNS AND ROWS*/
			columnaxes;
			columnaxis /label = "PLANNED (%)" griddisplay = on linearopts=(tickvaluelist=(0 .2 .4 .6 .8 1.0)); /* label under first column*/

			columnaxis /label = "" griddisplay = on; /* label under the second column */
			endcolumnaxes;
			*COLUMNAXES SETS THE CHARACTERISTICS OF COLUMNS;
			/*THE SECOND ONE HAS NO LABEL (NONE WOULD FIT)*/
			rowaxes;
			rowaxis /label = "IMPULSE (%)" griddisplay = on linearopts=(tickvaluelist=(0 .2 .4 .6 .8 1.0)) ;
			rowaxis /label = "" griddisplay = on;
			endrowaxes;


				layout overlay/xaxisopts=(griddisplay=on linearopts=(tickvaluelist= (0 .2 .4 .6 .8 1.0)))           /* list of tick values to      */
				yaxisopts=(griddisplay=on linearopts=(tickvaluelist=(0 .2 .4 .6 .8 1.0)))  ; /*STARTS THE ACTUAL GRAPHING OF DOTS AND SUCH*/
				scatterplot x = PLANNED y = IMPULSE//*datalabel=LEVEL_OF_PLANNING*/ group=groups ; *GRAPHS THE DOTS;
				title "planned vs. impulse";
				/*loessplot x =PLANNED y = IMPULSE/smooth = 1 nomarkers;*/
				ellipse x = PLANNED y = IMPULSE/ type = predicted alpha=0.1;
			endlayout;

				densityplot IMPULSE/group=groups orient = horizontal;
				densityplot PLANNED/group=groups;
			endlayout;
		endgraph;
	end;
run;

ods graphics on/width=9in height=8in;
proc sgrender data = sampleplan_impulse template = scatdens2;
run;
ods graphics off;


/***************************************/
/* liquar scartter plot   */
/*****************************/
ods graphics on/width=9in height=8in;
/*symbol1 i=none f=market v=W c=antiquewhite h=1;
symbol2 i=none f=market v=W c=red h=1;*/
proc sgplot data=light_fruity_liquar;
	scatter x=Sum_of_Nb_of_beer_sku y=Sum_of_Style_index /datalabel=Store group=Store_info;
/*	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 0.5 by 0.1);*/
/*	loess  x=PLANNED y=IMPULSE /nomarkers;*/ /* add a smoothline to show the relation between the two variables */
	title "SKU vs index";
	ellipse x=Sum_of_Nb_of_beer_sku y=Sum_of_Style_index ; 
run;
ods graphics off;






/********************************************************************/
/* 		macro ploting scatter plot with density plotings 			*/
/********************************************************************/
%macro scartter_density(x=,y=);

proc template; *STARTS PROC TEMPLATE;
define statgraph scatdens4; *DEFINES A GRAPH TO BE CALL SCATDENS;
	begingraph; *BEGIN DEFINING THE GRAPH;
		entrytitle "&x  vs. &y Scatter plot with density plots"; *CREATE A TITLE;
			layout lattice/columns = 2 rows = 2 columnweights = (.8 .2) rowweights = (.8 .2)
			columndatarange= union rowdatarange = union;
			/*LAYOUT LATTICE/COLUMNS = 2 ROWS = 2 SETS UP A GRID, OR LATTICE, OF GRAPHS*/
			/*COLUMNWEIGHTS AND ROWWEIGHTS SETS THE RELATIVE SIZE OF THE INDIVIDUAL COLUMNS AND ROWS*/
			columnaxes;
			columnaxis /label = "&x  (%)" griddisplay = on linearopts=(tickvaluelist=(0 .2 .4 .6 .8 1.0)); /* label under first column*/

			columnaxis /label = "" griddisplay = on; /* label under the second column */
			endcolumnaxes;
			*COLUMNAXES SETS THE CHARACTERISTICS OF COLUMNS;
			/*THE SECOND ONE HAS NO LABEL (NONE WOULD FIT)*/
			rowaxes;
			rowaxis /label = "&y(%)" griddisplay = on linearopts=(tickvaluelist=(0 .2 .4 .6 .8 1.0)) ;
			rowaxis /label = "" griddisplay = on;
			endrowaxes;


				layout overlay/xaxisopts=(griddisplay=on linearopts=(viewmax=1 viewmin=0 tickvaluelist= (0 .2 .4 .6 .8 1.0)))           /* list of tick values to      */
				yaxisopts=(griddisplay=on linearopts=(viewmax=1 viewmin=0 tickvaluelist=(0 .2 .4 .6 .8 1.0)))  ; /*STARTS THE ACTUAL GRAPHING OF DOTS AND SUCH*/
				scatterplot x = &x  y = &y/ datalabel=LEVEL_OF_PLANNING group=GROUPS  ; *GRAPHS THE DOTS;
				title "&x  vs. &y";
				/*loessplot x =PLANNED y = IMPULSE/smooth = 1 nomarkers;*/
				ellipse x = &x y = &y/ type = predicted alpha=0.1;
			endlayout;

				densityplot &y/group=GROUPS  orient = horizontal;
				densityplot &x /group=GROUPS ;
			endlayout;
		endgraph;
	end;
run;

ods graphics on/width=9in height=8in;
proc sgrender data = neilson_scatter1 template = scatdens4;
run;
ods graphics off;

%mend scartter_density;


%scartter_density(x=ENGAGED,y=AUTOPILOT )
%scartter_density(x=PLANNED,y=unplanned)
%scartter_density(x=Price_Not_Consider,y=Price_Consider)
%scartter_density(x=AUTOPILOT,y=PLANNED )
%scartter_density(x=AUTOPILOT,y=Price_Not_Consider )
%scartter_density(x=PLANNED,y=Price_Not_Consider)


/***************************************************/
/*	 densityplot in sas   */
/**************************/

%macro densityplot(value=);
proc sgplot data=neilson_scatter;
  title "&value Distribution By Category Types";

  density &value/group=GROUPS  scale= percentage;
  xaxis values=(0 to 1 by 0.2) ;
  yaxis label="Percentage Of Category";
  keylegend / location=inside position=topright;

run;

proc sgplot data=neilson_scatter;
	title "&value Distribution";
	histogram &value;
	density &value/scale= count;
  xaxis values=(0 to 1 by 0.2) ;
  yaxis label="Percentage Of Category";

run;

title 'Extreme &value Observations';
ods select ExtremeObs;
proc univariate data=neilson_scatter nextrval=10;
   var &value;
   id LEVEL_OF_PLANNING;  /*show the name of category */
run;

%mend densityplot;

%densityplot(value=PLANNED)
%densityplot(value=AUTOPILOT)
%densityplot(value=Price_Not_Consider)
