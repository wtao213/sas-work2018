/******************************************/
/* split and merge  */
/********************************/
%macro trans(YR=,QTR=);


DATA TEMP&YR.&QTR(rename=(NF_SALES=NF_SALES_&YR._&QTR. NF_TRANS=NF_TRANS_&YR._&QTR. 
	LL_SALES=LL_SALES_&YR._&QTR. LL_TRANS=LL_TRANS_&YR._&QTR.) );
	SET 'Toronto Stores 20180524'n;

	where YR=&YR and QTR=&QTR;
run;

proc sort data=TEMP&YR.&QTR;
	by MBRSHIP_ID;
run;

%mend trans;

%trans(YR=2016,QTR=1)
%trans(YR=2016,QTR=2)
%trans(YR=2016,QTR=3)
%trans(YR=2016,QTR=4)
%trans(YR=2017,QTR=1)
%trans(YR=2017,QTR=2)
%trans(YR=2017,QTR=3)
%trans(YR=2017,QTR=4)

data full_info;
	merge TEMP20161 TEMP20162 TEMP20163 TEMP20164 TEMP20171 TEMP20172 TEMP20173 TEMP20174;
	by MBRSHIP_ID;

	drop YR QTR NF_UNITS NF_SALES_PROMO NF_UNITS_PROMO NF_TRANS_PROMO
	LL_UNITS LL_SALES_PROMO LL_UNITS_PROMO LL_TRANS_PROMO;
run;

data everyinfo;
	set full_info;
	/* total sales info */
	total_sales_2016_1 = sum(NF_SALES_2016_1,LL_SALES_2016_1); 
	total_sales_2016_2 = sum(NF_SALES_2016_2,LL_SALES_2016_2);
	total_sales_2016_3 = sum(NF_SALES_2016_3,LL_SALES_2016_3);
	total_sales_2016_4 = sum(NF_SALES_2016_4,LL_SALES_2016_4);

	total_sales_2017_1 = sum(NF_SALES_2017_1,LL_SALES_2017_1); 
	total_sales_2017_2 = sum(NF_SALES_2017_2,LL_SALES_2017_2);
	total_sales_2017_3 = sum(NF_SALES_2017_3,LL_SALES_2017_3);
	total_sales_2017_4 = sum(NF_SALES_2017_4,LL_SALES_2017_4);

	/* total txn info */
	total_TRANS_2016_1 = sum(NF_TRANS_2016_1,LL_TRANS_2016_1); 	
	total_TRANS_2016_2 = sum(NF_TRANS_2016_2,LL_TRANS_2016_2);
	total_TRANS_2016_3 = sum(NF_TRANS_2016_3,LL_TRANS_2016_3);
	total_TRANS_2016_4 = sum(NF_TRANS_2016_4,LL_TRANS_2016_4);
	
	total_TRANS_2017_1 = sum(NF_TRANS_2017_1,LL_TRANS_2017_1); 
	total_TRANS_2017_2 = sum(NF_TRANS_2017_2,LL_TRANS_2017_2);
	total_TRANS_2017_3 = sum(NF_TRANS_2017_3,LL_TRANS_2017_3);
	total_TRANS_2017_4 = sum(NF_TRANS_2017_4,LL_TRANS_2017_4);

	/* total NF info */
	NF_sales_2016= sum(NF_sales_2016_1,NF_sales_2016_2,NF_sales_2016_3,NF_sales_2016_4);	
	NF_sales_2017= sum(NF_sales_2017_1,NF_sales_2017_2,NF_sales_2017_3,NF_sales_2017_4);
	
	NF_TRANS_2016= sum(NF_TRANS_2016_1,NF_TRANS_2016_2,NF_TRANS_2016_3,NF_TRANS_2016_4);
	NF_TRANS_2017= sum(NF_TRANS_2017_1,NF_TRANS_2017_2,NF_TRANS_2017_3,NF_TRANS_2017_4);


	/*total LL info */
	LL_sales_2016= sum(LL_sales_2016_1,LL_sales_2016_2,LL_sales_2016_3,LL_sales_2016_4);	
	LL_sales_2017= sum(LL_sales_2017_1,LL_sales_2017_2,LL_sales_2017_3,LL_sales_2017_4);
	
	LL_TRANS_2016= sum(LL_TRANS_2016_1,LL_TRANS_2016_2,LL_TRANS_2016_3,LL_TRANS_2016_4);
	LL_TRANS_2017= sum(LL_TRANS_2017_1,LL_TRANS_2017_2,LL_TRANS_2017_3,LL_TRANS_2017_4);

	
	/* total total info */
	total_sales_2016= sum(total_sales_2016_1,total_sales_2016_2,total_sales_2016_3,total_sales_2016_4);
	total_sales_2017= sum(total_sales_2017_1,total_sales_2017_2,total_sales_2017_3,total_sales_2017_4);

	total_TRANS_2016= sum(total_TRANS_2016_1,total_TRANS_2016_2,total_TRANS_2016_3,total_TRANS_2016_4);
	total_TRANS_2017= sum(total_TRANS_2017_1,total_TRANS_2017_2,total_TRANS_2017_3,total_TRANS_2017_4);

	if total_sales_2016_1 >0 and total_sales_2016_4 >0 and total_sales_2017_1 >0 and total_sales_2017_4 >0
		then reg_in = "both q1 q4";
	else	 reg_in = "not regular";

	mk_pen_2016 = LL_sales_2016/total_sales_2016;
	mk_pen_2017 = LL_sales_2017/total_sales_2017;

	YOY_TXN = total_TRANS_2017/total_TRANS_2016 -1;

	If -0.3 <= YOY_TXN <= 0.3 then txn_ind="stable txn    ";
	else 						   txn_ind="not stable txn";

run;


/********************************************/
/* manipulate the data to the line you want */
/* 			using transpose 				 */
/********************************************/
proc sort data='Toronto Stores 20180524'n;
 by MBRSHIP_ID YR QTR ;
run;

proc transpose data='Toronto Stores 20180524'n out=customer_info;
	var NF_SALES LL_SALES;
	by MBRSHIP_ID;
	id YR QTR;
run;


proc format;
	value group
    . 		 	 = "missing"
	low -< -1 = "below -1"
	-0.1 -< 0	 = "-0-10%"
	-0.2 -< -0.1 = "-10-20%"
	-0.3 -< -0.2 = "-20-30%"
	-0.4 -< -0.3 = "-30-40%"
	-0.5 -< -0.4 = "-40-50%"
	-0.6 -< -0.5 = "-50-60%"
	-0.7 -< -0.6 = "-60-70%"
	-0.8 -< -0.7 = "-70-80%"
	-0.9 -< -0.8 = "-80-90%"
	-1	 -< -0.9 = "-90-100%"
	0 = "no change"
	 0	 <-< 0.1 = "+ 0-10%"
	0.1	 -< 0.2 = "+10-20%"
	0.2	 -< 0.3 = "+20-30%"
	0.3	 -< 0.4 = "+30-40%"
	0.4	 -< 0.5 = "+40-50%"
	0.5	 -< 0.6 = "+50-60%"
	0.6	 -< 0.7 = "+60-70%"
	0.7	 -< 0.8 = "+70-80%"
	0.8	 -< 0.9 = "+80-90%"
	0.9	 -< 1   = "+90-100%"
	1 < - high = "above 1";
run;

data filted_only_v2;
 set filted_only(drop=yoy_pen yoy_pen_group);
    
    yoy_pen= sum(mk_pen_2017,-mk_pen_2016);
	yoy_pen_group = put(yoy_pen,group.);
run;