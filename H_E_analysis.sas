/**************************************************************/
/* 

/**		make a macro to run avoid to type multiple times  **/
%let tdlogin=%unquote(user=c_wtao      pwd=welcome1 MODE=Teradata tdpid=tdprod1);     
libname mytd teradata user=c_wtao      pwd=welcome1 MODE=Teradata tdpid=tdprod1 connection=global dbmstemp=yes    bulkload=yes;   /*TPT=YES   fastexport=YES */


/* if trying to create a new table,then run this */
PROC SQL;
     connect to teradata( &tdlogin connection = global);
     execute(

create multiset volatile table otpt, no log, no fallback as
(
select t1.mbrship_id as Mbr_id, lm.value_segment as segment, lm.home_site_num as HomeStore, s.rgn_num, t1.TtlSales, t1.TtlPromSales, t1.TtlTxn, t1.TtlPromTxn, t1.HnESales, t1.HnEPromSales, t1.HnETxn, t1.HnEPromTxn, t2.*
from

(select t.mbrship_id, t.TtlSales, p.TtlPromSales, t.TtlTxn, p.TtlPromTxn, t.HnESales, p.HnEPromSales, t.HnETxn, p.HnEPromTxn      
      from dlcna_cateam.CustTxnDtl_ttl t
            left join dlcna_cateam.CustTxnDtl_ttlProm p
                  on t.mbrship_id = p.mbrship_id) t1    
left join

(select mbrship_id
, sum(case when Cat = 'Electronics Accessories' then TtlSales else 0 end) as Elec_Sales,  sum(case when Cat = 'Electronics Accessories' then PromSales else 0 end) as Elec_PromSales    ,     sum(case when Cat = 'Electronics Accessories' then TtlTxn else 0 end) as Elec_Txn , sum(case when Cat = 'Electronics Accessories' then PromTxn else 0 end) as Elec_PromTxn
, sum(case when Cat = 'Sporting and Outdoor' then TtlSales else 0 end) as Spor_Sales,  sum(case when Cat = 'Sporting and Outdoor' then PromSales else 0 end) as Spor_PromSales      ,     sum(case when Cat = 'Sporting and Outdoor' then TtlTxn else 0 end) as Spor_Txn , sum(case when Cat = 'Sporting and Outdoor' then PromTxn else 0 end) as Spor_PromTxn
, sum(case when Cat = 'Imaging' then TtlSales else 0 end) as Imag_Sales,  sum(case when Cat = 'Imaging' then PromSales else 0 end) as Imag_PromSales   ,     sum(case when Cat = 'Imaging' then TtlTxn else 0 end) as Imag_Txn , sum(case when Cat = 'Imaging' then PromTxn else 0 end) as Imag_PromTxn
, sum(case when Cat = 'Fitness' then TtlSales else 0 end) as Fitn_Sales,  sum(case when Cat = 'Fitness' then PromSales else 0 end) as Fitn_PromSales   ,     sum(case when Cat = 'Fitness' then TtlTxn else 0 end) as Fitn_Txn , sum(case when Cat = 'Fitness' then PromTxn else 0 end) as Fitn_PromTxn
, sum(case when Cat = 'Toys' then TtlSales else 0 end) as Toys_Sales,  sum(case when Cat = 'Toys' then PromSales else 0 end) as Toys_PromSales      ,     sum(case when Cat = 'Toys' then TtlTxn else 0 end) as Toys_Txn , sum(case when Cat = 'Toys' then PromTxn else 0 end) as Toys_PromTxn
, sum(case when Cat = 'office classroom supplies' then TtlSales else 0 end) as offi_Sales,  sum(case when Cat = 'office classroom supplies' then PromSales else 0 end) as offi_PromSales    ,     sum(case when Cat = 'office classroom supplies' then TtlTxn else 0 end) as offi_Txn , sum(case when Cat = 'office classroom supplies' then PromTxn else 0 end) as offi_PromTxn
, sum(case when Cat = 'Small appliances' then TtlSales else 0 end) as Smal_Sales,  sum(case when Cat = 'Small appliances' then PromSales else 0 end) as Smal_PromSales      ,     sum(case when Cat = 'Small appliances' then TtlTxn else 0 end) as Smal_Txn , sum(case when Cat = 'Small appliances' then PromTxn else 0 end) as Smal_PromTxn
, sum(case when Cat = 'Seasonal consumable' then TtlSales else 0 end) as Seas_Sales,  sum(case when Cat = 'Seasonal consumable' then PromSales else 0 end) as Seas_PromSales      ,     sum(case when Cat = 'Seasonal consumable' then TtlTxn else 0 end) as Seas_Txn , sum(case when Cat = 'Seasonal consumable' then PromTxn else 0 end) as Seas_PromTxn
, sum(case when Cat = 'Automotive' then TtlSales else 0 end) as Auto_Sales,  sum(case when Cat = 'Automotive' then PromSales else 0 end) as Auto_PromSales   ,     sum(case when Cat = 'Automotive' then TtlTxn else 0 end) as Auto_Txn , sum(case when Cat = 'Automotive' then PromTxn else 0 end) as Auto_PromTxn
, sum(case when Cat = 'Kitchen n dining' then TtlSales else 0 end) as Kitc_Sales,  sum(case when Cat = 'Kitchen n dining' then PromSales else 0 end) as Kitc_PromSales  ,      sum(case when Cat = 'Kitchen n dining' then TtlTxn else 0 end) as Kitc_Txn , sum(case when Cat = 'Kitchen n dining' then PromTxn else 0 end) as Kitc_PromTxn
, sum(case when Cat = 'Bath' then TtlSales else 0 end) as Bath_Sales,  sum(case when Cat = 'Bath' then PromSales else 0 end) as Bath_PromSales      ,     sum(case when Cat = 'Bath' then TtlTxn else 0 end) as Bath_Txn , sum(case when Cat = 'Bath' then PromTxn else 0 end) as Bath_PromTxn
, sum(case when Cat = 'Patio n Outdoor' then TtlSales else 0 end) as Pati_Sales,  sum(case when Cat = 'Patio n Outdoor' then PromSales else 0 end) as Pati_PromSales ,      sum(case when Cat = 'Patio n Outdoor' then TtlTxn else 0 end) as Pati_Txn , sum(case when Cat = 'Patio n Outdoor' then PromTxn else 0 end) as Pati_PromTxn
, sum(case when Cat = 'Themed decoration and accessories' then TtlSales else 0 end) as Them_Sales,  sum(case when Cat = 'Themed decoration and accessories' then PromSales else 0 end) as Them_PromSales  ,     sum(case when Cat = 'Themed decoration and accessories' then TtlTxn else 0 end) as Them_Txn , sum(case when Cat = 'Themed decoration and accessories' then PromTxn else 0 end) as Them_PromTxn
, sum(case when Cat = 'Home decor n bedding' then TtlSales else 0 end) as HomeDeco_Sales,  sum(case when Cat = 'Home decor n bedding' then PromSales else 0 end) as HomeDeco_PromSales      ,     sum(case when Cat = 'Home decor n bedding' then TtlTxn else 0 end) as HomeDeco_Txn , sum(case when Cat = 'Home decor n bedding' then PromTxn else 0 end) as HomeDeco_PromTxn
, sum(case when Cat = 'Christmas' then TtlSales else 0 end) as Chri_Sales,  sum(case when Cat = 'Christmas' then PromSales else 0 end) as Chri_PromSales   ,     sum(case when Cat = 'Christmas' then TtlTxn else 0 end) as Chri_Txn , sum(case when Cat = 'Christmas' then PromTxn else 0 end) as Chri_PromTxn
, sum(case when Cat = 'Disposable ' then TtlSales else 0 end) as Disp_Sales,  sum(case when Cat = 'Disposable ' then PromSales else 0 end) as Disp_PromSales   ,     sum(case when Cat = 'Disposable ' then TtlTxn else 0 end) as Disp_Txn , sum(case when Cat = 'Disposable ' then PromTxn else 0 end) as Disp_PromTxn
, sum(case when Cat = 'Dollar store' then TtlSales else 0 end) as Doll_Sales,  sum(case when Cat = 'Dollar store' then PromSales else 0 end) as Doll_PromSales    ,     sum(case when Cat = 'Dollar store' then TtlTxn else 0 end) as Doll_Txn , sum(case when Cat = 'Dollar store' then PromTxn else 0 end) as Doll_PromTxn
, sum(case when Cat = 'Gift packaging and cards' then TtlSales else 0 end) as Gift_Sales,  sum(case when Cat = 'Gift packaging and cards' then PromSales else 0 end) as Gift_PromSales    ,     sum(case when Cat = 'Gift packaging and cards' then TtlTxn else 0 end) as Gift_Txn , sum(case when Cat = 'Gift packaging and cards' then PromTxn else 0 end) as Gift_PromTxn
, sum(case when Cat = 'Home improvement' then TtlSales else 0 end) as HomeImp_Sales,  sum(case when Cat = 'Home improvement' then PromSales else 0 end) as HomeImp_PromSales ,     sum(case when Cat = 'Home improvement' then TtlTxn else 0 end) as HomeImp_Txn , sum(case when Cat = 'Home improvement' then PromTxn else 0 end) as HomeImp_PromTxn
, sum(case when Cat = 'Home organization' then TtlSales else 0 end) as HomeOrg_Sales,  sum(case when Cat = 'Home organization' then PromSales else 0 end) as HomeOrg_PromSales ,     sum(case when Cat = 'Home organization' then TtlTxn else 0 end) as HomeOrg_Txn , sum(case when Cat = 'Home organization' then PromTxn else 0 end) as HomeOrg_PromTxn
, sum(case when Cat = 'Apparel' then TtlSales else 0 end) as Appa_Sales,  sum(case when Cat = 'Apparel' then PromSales else 0 end) as Appa_PromSales   ,     sum(case when Cat = 'Apparel' then TtlTxn else 0 end) as Appa_Txn , sum(case when Cat = 'Apparel' then PromTxn else 0 end) as Appa_PromTxn

from

(select cat.mbrship_id, cat.Cat, cat.TtlSales, cat.TtlTxn            , catp.PromSales, catp.PromTxn
      from dlcna_cateam.CustTxnDtl_cat cat
            left join dlcna_cateam.CustTxnDtl_catprom catp
                  on cat.mbrship_id = catp.mbrship_id and cat.cat = catp.cat) t
group by 1
) t2 
on t1.mbrship_id=t2.mbrship_id  
inner join dlcna_cateam.lylty_Mbrship_all_seg2 lm
      on t1.mbrship_id = lm.all_mbrship_id
left join rldmprod_v.site_hier s
      on lm.home_site_num = s.site_num
      ) with data on commit preserve rows;

	 )  by teradata;
	 	disconnect from teradata;
quit;


/* check the data set info */
proc datasets library=mytd ;
run;

data new;
 set mytd.otpt;
run;

/* get the info for the column names */
proc contents data=new;
run;


/*start your manipulation*/
/* get the sales pen */
data new_1;
	set new;
array cat_txn{*} Elec_Txn	Spor_Txn	Imag_Txn	Fitn_Txn	Toys_Txn	offi_Txn	Smal_Txn	Seas_Txn	Auto_Txn	Kitc_Txn	Bath_Txn	Pati_Txn	Them_Txn	HomeDeco_Txn	Chri_Txn	Disp_Txn	Doll_Txn	Gift_Txn	HomeImp_Txn	HomeOrg_Txn	Appa_Txn;
array tt_pen {*} Elec_pen_tt	Spor_pen_tt	Imag_pen_tt	Fitn_pen_tt	Toys_pen_tt	offi_pen_tt	Smal_pen_tt	Seas_pen_tt	Auto_pen_tt	Kitc_pen_tt	Bath_pen_tt	Pati_pen_tt	Them_pen_tt	HomeDeco_pen_tt	Chri_pen_tt	Disp_pen_tt	Doll_pen_tt	Gift_pen_tt	HomeImp_pen_tt	HomeOrg_pen_tt	Appa_pen_tt
;
array he_pen {*} Elec_pen_he	Spor_pen_he	Imag_pen_he	Fitn_pen_he	Toys_pen_he	offi_pen_he	Smal_pen_he	Seas_pen_he	Auto_pen_he	Kitc_pen_he	Bath_pen_he	Pati_pen_he	Them_pen_he	HomeDeco_pen_he	Chri_pen_he	Disp_pen_he	Doll_pen_he	Gift_pen_he	HomeImp_pen_he	HomeOrg_pen_he	Appa_pen_he;
array promo_sales {*} Elec_PromSales	Spor_PromSales	Imag_PromSales	Fitn_PromSales	Toys_PromSales	offi_PromSales	Smal_PromSales	Seas_PromSales	Auto_PromSales	Kitc_PromSales	Bath_PromSales	Pati_PromSales	Them_PromSales	HomeDeco_PromSales	Chri_PromSales	Disp_PromSales	Doll_PromSales	Gift_PromSales	HomeImp_PromSales	HomeOrg_PromSales	Appa_PromSales;
array sales {*} Elec_Sales	Spor_Sales	Imag_Sales	Fitn_Sales	Toys_Sales	offi_Sales	Smal_Sales	Seas_Sales	Auto_Sales	Kitc_Sales	Bath_Sales	Pati_Sales	Them_Sales	HomeDeco_Sales	Chri_Sales	Disp_Sales	Doll_Sales	Gift_Sales	HomeImp_Sales	HomeOrg_Sales	Appa_Sales;
array promo_pen{*} Elec_promo_pen	Spor_promo_pen	Imag_promo_pen	Fitn_promo_pen	Toys_promo_pen	offi_promo_pen	Smal_promo_pen	Seas_promo_pen	Auto_promo_pen	Kitc_promo_pen	Bath_promo_pen	Pati_promo_pen	Them_promo_pen	HomeDeco_promo_pen	Chri_promo_pen	Disp_promo_pen	Doll_promo_pen	Gift_promo_pen	HomeImp_promo_pen	HomeOrg_promo_pen	Appa_promo_pen;

do i=1 to 21;
tt_pen[i] = cat_txn[i]/TtlTxn;
he_pen[i] = cat_txn[i]/HnETxn;
promo_pen[i] = promo_sales[i]/sales[i];

drop i;
end;

run;

/* delete the dataset to make more space */
proc datasets library=work;
	delete new;
run;



/* check the size of the dataset */
proc contents data=new_1;
run;


/* summary tables */
/* check how many customers buy this category, total 21 categories + 1 H&E overall */
data want;
   set new_1 end=done;

   array in {*} HnETxn Elec_Txn	Spor_Txn	Imag_Txn	Fitn_Txn	Toys_Txn	offi_Txn	Smal_Txn	Seas_Txn	Auto_Txn	Kitc_Txn	Bath_Txn	Pati_Txn	Them_Txn	HomeDeco_Txn	Chri_Txn	Disp_Txn	Doll_Txn	Gift_Txn	HomeImp_Txn	HomeOrg_Txn	Appa_Txn;
   array out {*}HnE_count Elec_count	Spor_count	Imag_count	Fitn_count	Toys_count	offi_count	Smal_count	Seas_count	Auto_count	Kitc_count	Bath_count	Pati_count	Them_count	HomeDeco_count	Chri_count	Disp_count	Doll_count	Gift_count	HomeImp_count	HomeOrg_count	Appa_count;

   retain HnE_count  Elec_count	Spor_count	Imag_count	Fitn_count	Toys_count	offi_count	Smal_count	Seas_count	Auto_count	Kitc_count	Bath_count	Pati_count	Them_count	HomeDeco_count	Chri_count	Disp_count	Doll_count	Gift_count	HomeImp_count	HomeOrg_count	Appa_count 0;


   do _i_=1 to 22;

      if in{_i_} not in (., 0) then out{_i_} + 1;

   end;

   if done;

   keep HnE_count Elec_count	Spor_count	Imag_count	Fitn_count	Toys_count	offi_count	Smal_count	Seas_count	Auto_count	Kitc_count	Bath_count	Pati_count	Them_count	HomeDeco_count	Chri_count	Disp_count	Doll_count	Gift_count	HomeImp_count	HomeOrg_count	Appa_count
;

run;


/* tabulate to see some raw stat, like promo pen, txn pen etc */



/***************************************/
/* look at the distribution plots */
/************************************/

ods graphics on;
proc univariate data= new_1 noprint;
   histogram Elec_pen_he	Spor_pen_he	Imag_pen_he	Fitn_pen_he	Toys_pen_he	offi_pen_he	Smal_pen_he	Seas_pen_he	Auto_pen_he	Kitc_pen_he	Bath_pen_he	Pati_pen_he	Them_pen_he	HomeDeco_pen_he	Chri_pen_he	Disp_pen_he	Doll_pen_he	Gift_pen_he	HomeImp_pen_he	HomeOrg_pen_he	Appa_pen_he
			/ /*odstitle = title*/;
   /*inset n = 'Number of Homes' / position=ne;*/
run;
ods graphics off;

ods graphics on;
proc univariate data= new_1 noprint;
   histogram Elec_promo_pen	Spor_promo_pen	Imag_promo_pen	Fitn_promo_pen	Toys_promo_pen	offi_promo_pen	Smal_promo_pen	Seas_promo_pen	Auto_promo_pen	Kitc_promo_pen	Bath_promo_pen	Pati_promo_pen	Them_promo_pen	HomeDeco_promo_pen	Chri_promo_pen	Disp_promo_pen	Doll_promo_pen	Gift_promo_pen	HomeImp_promo_pen	HomeOrg_promo_pen	Appa_promo_pen
/ /*odstitle = title*/;
   /*inset n = 'Number of Homes' / position=ne;*/
run;
ods graphics off;

/* check some categories with promo */
ods graphics on;
proc univariate data= new_1 noprint;
	where 0 <= Auto_promo_pen <= 1; /* make sure no weired number shows up */
   histogram 	Auto_promo_pen;
   /*inset n = 'Number of Homes' / position=ne;*/
run;
ods graphics off;

/* drop all the negative numbers 9,772,801 observations left, before is 9,785,700 observations */
/* intesting, even index is a function for string,but can still run in number,sas will convert them to string first,but output is still numberic */
data new_2;
	set new_1;
    array filter_list {*} Elec_Sales	Spor_Sales	Imag_Sales	Fitn_Sales	Toys_Sales	offi_Sales	Smal_Sales	Seas_Sales	Auto_Sales	Kitc_Sales	Bath_Sales	Pati_Sales	Them_Sales	HomeDeco_Sales	Chri_Sales	Disp_Sales	Doll_Sales	Gift_Sales	HomeImp_Sales	HomeOrg_Sales	Appa_Sales;

	do i=1 to dim(filter_list);
	if index(filter_list[i],'-') then delete;
	drop i;
	end;
run;



/* correlation test for categories well... using txn as testing if you buy A also buy B*/
proc corr data=new_2 pearson spearman kendall hoeffding;
   var Elec_Txn	Spor_Txn	Imag_Txn	Fitn_Txn	Toys_Txn	offi_Txn	Smal_Txn	Seas_Txn	Auto_Txn	Kitc_Txn	Bath_Txn	Pati_Txn	Them_Txn	HomeDeco_Txn	Chri_Txn	Disp_Txn	Doll_Txn	Gift_Txn	HomeImp_Txn	HomeOrg_Txn	Appa_Txn;
run;



/* testing out the plots look */
ods graphics on;
proc corr data=new_2 pearson spearman kendall hoeffding;
   var Elec_Sales Spor_Sales;
run;
ods graphics off;



%macro distribution(x=)
ods graphics on;
proc univariate data= new_1 noprint;
   where &x not in (., 0);
   histogram &x	/ normal/*odstitle = title*/;
   /*inset n = 'Number of Homes' / position=ne;*/
run;
ods graphics off;
%mend distribution;

%macro distribution(x=)
