
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
%macro scartter_density(data=,CHANNEL=,x=,y=);

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
				footnote &CHANNEL;
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
proc sgrender data = &data template = scatdens4;
	where CHANNEL= &CHANNEL;
run;
ods graphics off;

%mend scartter_density;

%scartter_density(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",x=ENGAGED,y=AUTOPILOT)
%scartter_density(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",x=PLANNED,y=unplanned)
%scartter_density(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",x=Price_Not_Consider,y=Price_Consider)

%scartter_density(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",x=AUTOPILOT,y=PLANNED )
%scartter_density(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",x=AUTOPILOT,y=Price_Not_Consider )
%scartter_density(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",x=PLANNED,y=Price_Not_Consider)

%scartter_density(data=neilson_different_channels2,CHANNEL="LCL CONV",x=AUTOPILOT,y=PLANNED )
%scartter_density(data=neilson_different_channels2,CHANNEL="LCL CONV",x=AUTOPILOT,y=Price_Not_Consider )
%scartter_density(data=neilson_different_channels2,CHANNEL="LCL CONV",x=PLANNED,y=Price_Not_Consider)

%scartter_density(data=neilson_different_channels2,CHANNEL="GROCERY STORE(Conventional)",x=AUTOPILOT,y=PLANNED )
%scartter_density(data=neilson_different_channels2,CHANNEL="GROCERY STORE(Conventional)",x=AUTOPILOT,y=Price_Not_Consider )
%scartter_density(data=neilson_different_channels2,CHANNEL="GROCERY STORE(Conventional)",x=PLANNED,y=Price_Not_Consider)


/***************************************************/
/*	 densityplot in sas   */
/**************************/
%macro densityplot(data=,CHANNEL=,value=);
proc sgplot data=&data;
  where CHANNEL = &CHANNEL;
  title "&value Distribution By Category Types";
  histogram &value/group=GROUPS scale= percent transparency=0.8;
  density &value/group=GROUPS scale= percent;
  xaxis values=(0 to 1 by 0.2) TICKVALUEFORMAT= percent10.;
  yaxis label="Percentage Of Category" ;
  keylegend / location=inside position=topright;
  footnote &CHANNEL;
run;

proc sgplot data=&data;
	where CHANNEL = &CHANNEL;
	title "Total categories' &value Distribution";
	histogram &value;
	density &value/scale= count;
  xaxis values=(0 to 1 by 0.2) TICKVALUEFORMAT= percent10.;/* use tickvalueformat to decide the format */
  yaxis label="Count Of Category";
run;

title 'Extreme &value Observations';
ods select ExtremeObs;
proc univariate data=&data nextrobs=10;/* difference between nextrobs he nextrval */
	where CHANNEL = &CHANNEL;
   var &value;
   id LEVEL_OF_PLANNING;  /*show the name of category */
run;

%mend densityplot;

%densityplot(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",value=PLANNED)
%densityplot(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",value=AUTOPILOT)
%densityplot(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",value=Price_Not_Consider)

%densityplot(data=neilson_different_channels2,CHANNEL="LCL CONV",value=PLANNED)
%densityplot(data=neilson_different_channels2,CHANNEL="LCL CONV",value=AUTOPILOT)
%densityplot(data=neilson_different_channels2,CHANNEL="LCL CONV",value=Price_Not_Consider)

%densityplot(data=neilson_different_channels2,CHANNEL="GROCERY STORE(Conventional)",value=PLANNED)
%densityplot(data=neilson_different_channels2,CHANNEL="GROCERY STORE(Conventional)",value=AUTOPILOT)
%densityplot(data=neilson_different_channels2,CHANNEL="GROCERY STORE(Conventional)",value=Price_Consider)

/****************************************/
/* compare metrics in different markets */
/****************************************/
%densityplot(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",value=PLANNED)
%densityplot(data=neilson_different_channels2,CHANNEL="LCL CONV",value=PLANNED)
%densityplot(data=neilson_different_channels2,CHANNEL="GROCERY STORE(Conventional)",value=PLANNED)


%densityplot(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",value=AUTOPILOT)
%densityplot(data=neilson_different_channels2,CHANNEL="LCL CONV",value=AUTOPILOT)
%densityplot(data=neilson_different_channels2,CHANNEL="GROCERY STORE(Conventional)",value=AUTOPILOT)

%densityplot(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",value=Price_Not_Consider)
%densityplot(data=neilson_different_channels2,CHANNEL="LCL CONV",value=Price_Not_Consider)
%densityplot(data=neilson_different_channels2,CHANNEL="GROCERY STORE(Conventional)",value=Price_Not_Consider)

/***************************************************/
/* macro scatter plot  with label only on outliers */
/***************************************************/

%macro scartter(data=,CHANNEL=,x=,y=);

proc rank data=&data out=new groups=20;
	where CHANNEL=&CHANNEL;
	var &x;
	ranks rank_of_x;
run;

proc rank data=new out=new1 groups=20;
	var &y;
	ranks rank_of_y;
run;

data new2;
	set new1;
	format category_outlier $32.;

	if  0< rank_of_y <19 and 0< rank_of_x <19	then category_outlier = "";
	else											 category_outlier = LEVEL_OF_PLANNING;

run;

ods graphics on//*width=9in height=8in*/;
proc sgplot data=new2;
	scatter x=&x y=&y /datalabel=category_outlier group=GROUPS;
	xaxis values= (0 to 1 by 0.2);
	yaxis values= (0 to 1 by 0.2);
	title "Relation Between &x and &y";
	footnote &CHANNEL;
	ellipse x=&x y=&y ;
run;
ods graphics off;

%mend scartter;

%scartter(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",x=AUTOPILOT,y=PLANNED )
%scartter(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",x=AUTOPILOT,y=Price_Not_Consider )
%scartter(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",x=PLANNED,y=Price_Not_Consider)

%scartter(data=neilson_different_channels2,CHANNEL="LCL CONV",x=AUTOPILOT,y=PLANNED )
%scartter(data=neilson_different_channels2,CHANNEL="LCL CONV",x=AUTOPILOT,y=Price_Not_Consider )
%scartter(data=neilson_different_channels2,CHANNEL="LCL CONV",x=PLANNED,y=Price_Not_Consider)

%scartter(data=neilson_different_channels2,CHANNEL="GROCERY STORE(Conventional)",x=AUTOPILOT,y=PLANNED )
%scartter(data=neilson_different_channels2,CHANNEL="GROCERY STORE(Conventional)",x=AUTOPILOT,y=Price_Not_Consider )
%scartter(data=neilson_different_channels2,CHANNEL="GROCERY STORE(Conventional)",x=PLANNED,y=Price_Not_Consider)



/************************************/
/* testing for factor analysis   */
/*********************************/
ods graphics on;
proc factor data=neilson_scatter1 out=final_data nfactors=2 outstat=c plots=all rotate=varimax m=ml;
	var PLANNED  ENGAGED Price_Not_Consider;
 /*REMINDER   IMPULSE  UNPLANNED  ENGAGED  AUTOPILOT Price_Not_Consider Price_Consider BEST_PRICE_IN_BRAND_SET 
	BEST_QUALITY_IN_PRICE_SET BEST_VALUE_IN_PRICE_RANGE LOWEST_PRICE_PER_UNIT LOWEST_POSSIBLE_PRICE ;*/
run;
ods graphics off;





/*****************************************/
/* tonnage distribution by food/non food */
/******************************************/

%macro densitytonnage(data=,CHANNEL=,group=,value=);
proc sgplot data=&data ;
  where BenchMarket = &CHANNEL;
  title "&value Distribution By Category Types";
  histogram &value/group=&group transparency=0.8;
  density &value/group=&group scale= count;
  /*xaxis values=(0 to 1 by 0.2) TICKVALUEFORMAT= percent10.;*/
  /*yaxis label="Percentage Of Category" ;*/
  keylegend / location=inside position=topright;
  footnote &CHANNEL;
run;

proc sgplot data=&data;
	where BenchMarket = &CHANNEL;
	title "Total categories' &value Distribution";
	histogram &value/scale=count;
	density &value/scale= count;
 /* xaxis values=(0 to 1 by 0.2) TICKVALUEFORMAT= percent10.;*//* use tickvalueformat to decide the format */
  yaxis label="Count Of Category";
run;

title 'Extreme &value Observations';
ods select ExtremeObs;
proc univariate data=&data nextrobs=10;/* difference between nextrobs he nextrval */
	where BenchMarket = &CHANNEL;
   var &value;
   id MCH0 ;  /*show the name of category */
run;

%mend densitytonnage;


%densitytonnage(data=Nielsen_Data_Distribution_Curves,CHANNEL="LCL Conv",group=FoodVsNonFood,value=YoYTonnage)
%densitytonnage(data=Nielsen_Data_Distribution_Curves,CHANNEL="LCL Conv",group=FoodVsNonFood,value=YoYPromoTonnage)
%densitytonnage(data=Nielsen_Data_Distribution_Curves,CHANNEL="LCL Conv",group=FoodVsNonFood,value=YoYNonPromoTonnage)


%densitytonnage(data=Nielsen_Data_Distribution_Curves,CHANNEL="AC Conv",group=FoodVsNonFood,value=YoYTonnage)
%densitytonnage(data=Nielsen_Data_Distribution_Curves,CHANNEL="AC Conv",group=FoodVsNonFood,value=YoYPromoTonnage)
%densitytonnage(data=Nielsen_Data_Distribution_Curves,CHANNEL="AC Conv",group=FoodVsNonFood,value=YoYNonPromoTonnage)

%densitytonnage(data=Nielsen_Data_Distribution_Curves,CHANNEL="AC",group=FoodVsNonFood,value=YoYTonnage)
%densitytonnage(data=Nielsen_Data_Distribution_Curves,CHANNEL="AC",group=FoodVsNonFood,value=YoYPromoTonnage)
%densitytonnage(data=Nielsen_Data_Distribution_Curves,CHANNEL="AC",group=FoodVsNonFood,value=YoYNonPromoTonnage)


%densitytonnage(data=Nielsen_Data_Distribution_Curves,CHANNEL="GDM",group=FoodVsNonFood,value=YoYTonnage)
%densitytonnage(data=Nielsen_Data_Distribution_Curves,CHANNEL="GDM",group=FoodVsNonFood,value=YoYPromoTonnage)
%densitytonnage(data=Nielsen_Data_Distribution_Curves,CHANNEL="GDM",group=FoodVsNonFood,value=YoYNonPromoTonnage)


proc sgplot data=Nielsen_Data_Distribution_Curves;
  where BenchMarket = "GDM";
  title "value Distribution By Category Types";

  histogram YoYPromoTonnage/transparency=0.8 scale=percent;
 
  /*xaxis values=(0 to 1 by 0.2) TICKVALUEFORMAT= percent10.;*/
  density YoYPromoTonnage/group=FoodVsNonFood scale=percent;
  keylegend / location=inside position=topright;
  
run;


/*********************************************/
/*				3D PLOTTING 				*/
/*********************************************/

goptions reset=all border;
title1 "3D Plotting";

footnote1 j=r "Sepal Width not Shown";
axis1 order=(0 to 1 by 0.2);
proc g3d data=neilson_different_channels2;
	
	where CHANNEL= "ALL CHANNEL"; 

  	scatter PLANNED*AUTOPILOT=Price_Consider /noneedle shape="balloon"
    color="light blue" size=1 xaxis=axis1 yaxis=axis1 zaxis=axis1 
	xticknum=5 yticknum=5 zticknum=5;

run;

proc g3d data=neilson_different_channels2;
	
	where CHANNEL= "ALL CHANNEL"; 

  	scatter PLANNED*AUTOPILOT=Price_Consider //*noneedle*/ shape="balloon"
    color="light blue" size=1 xaxis=axis1 yaxis=axis1 zaxis=axis1 
	xticknum=5 yticknum=5 zticknum=5 rotate=90;

run;

quit;

data list;
	set neilson_different_channels2;

	/*where PLANNED > 0.5 and AUTOPILOT >0.5 and  Price_Consider>0.5;*/

	where 0.4< Price_Consider <0.6;
run;

/************************************************/
/* create label for only certain category    */
/*********************************************/
data Class;
set Sashelp.Class;
Label = Name;
if Name not in ("Joyce", "Judy", "Philip") then
   Label = " ";
run;


/****************************************/
/* scartter plot for certain categories */
/****************************************/
%macro scartter_ca(data=,CHANNEL=,x=);
/*create label for certain categories */
data new;
	set &data;
	where CHANNEL=&CHANNEL;
	Label = LEVEL_OF_PLANNING;
if LEVEL_OF_PLANNING not in ("DELI CHEESE", "FROZEN SEAFOOD", "FRESH SEAFOOD","FRESH MEAT & POULTRY","CHOCOLATE"
,"CARBONATED SOFT DRINKS","TEA","Bananas","Berries") then
   Label = " ";
run;

/* ploting them by category */
proc sgplot data=new;
	scatter x=&x y=LEVEL_OF_PLANNING /datalabel=Label group=GROUPS markerattrs=(symbol=Circlefilled);
	xaxis values= (0 to 1 by 0.2);
	yaxis display=none;
	title "scatter on &x";
	footnote &CHANNEL;
run;
/* histogram distribution */
proc sgplot data=&data;
	where CHANNEL = &CHANNEL;
	title "Total categories' &x Distribution";
	histogram &x/group=GROUPS transparency=0.8 scale=count;
	density &x/group=GROUPS scale=count;
  xaxis values=(0 to 1 by 0.2) TICKVALUEFORMAT= percent10.;/* use tickvalueformat to decide the format */
  yaxis label="Count Of Category";
  footnote &CHANNEL;
run;
/* list the  highest and lowest value */
title 'Extreme &x Observations';
ods select ExtremeObs;
proc univariate data=&data nextrobs=2;/* difference between nextrobs he nextrval */
	where CHANNEL = &CHANNEL;
   var &x;
   id LEVEL_OF_PLANNING;  /*show the name of category */
run;
/* find value for our target categories */
proc print data=new (keep= &x  LEVEL_OF_PLANNING);
	where LEVEL_OF_PLANNING in ("DELI CHEESE", "FROZEN SEAFOOD", "FRESH SEAFOOD","FRESH MEAT & POULTRY","CHOCOLATE"
,"CARBONATED SOFT DRINKS","TEA","Bananas","Berries");
run;

%mend scartter_ca;

%scartter_ca(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",x=AUTOPILOT)
%scartter_ca(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",x=PLANNED)
%scartter_ca(data=neilson_different_channels2,CHANNEL="ALL CHANNEL",x=Price_Consider)

