filename file1 url
'http://www.uvm.edu/~rsingle/stat231/data/other/nc_sas.csv';
proc import datafile=file1
 out=nc
 dbms=csv
 replace;
 getnames=yes;
 guessingrows=max;
run;
/*
proc means data=nc maxdec=2;
 var fage mage weeks visits weight gained;
run;
proc freq data=nc;
 tables marital lowbirthweight*habit;
run; 

proc ttest data=nc sides=2 H0=0;
 class habit;
 var weight;
 title "Two-Sample t-test Comparing Birthweights by Smoking Status";
run;
*/
/*Homework2*/
proc ttest data=nc sides=2 H0=0 ALPHA=0.10;
 var weeks;
 title "T-test on weeks of pergnancies";
run;
/*the 90% CI for mean is (38.1819,38.4874)*/

proc univariate data=nc;
 class mature;
 var mage;
run; 
/*It is defined that mature mothers are older than 35 years old.*/

proc ttest data=nc sides=2 H0=0;
 class mature;
 var weight;
 title "t-test Comparing Birthweights by younger mothers and mature mothers";
run;
/*p-value is 0.8403*/
proc GLM data=nc;
class mature;
 model weight=mature;
run;
/*p-value is 0.8403*/


