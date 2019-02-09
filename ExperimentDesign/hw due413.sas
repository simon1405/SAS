

FILENAME file1 URL "http://www.uvm.edu/~rsingle/stat231/data/kuehl/ex8_2.txt";
 DATA a1;
 INFILE file1 FIRSTOBS=2 EXPANDTABS;
 INPUT TREATMENT BLOCK PHOS;

proc GLM data=a1;
class TREATMENT BLOCK;
model PHOS=TREATMENT BLOCK;
random block/test;
 CONTRAST '1' treatment 1 -0.25 -0.25 -0.25 -0.25;
 CONTRAST '2' treatment 0 1 -1 1 -1;
 CONTRAST '3' treatment 0 1 1 -1 -1;
 CONTRAST '4' treatment 0 1 -1 -1 1;
run;

 FILENAME macro231 URL "http://www.uvm.edu/~rsingle/stat231/macros-stat231.sas";
 %INCLUDE macro231;
* Compute SS(NonAdd);
 %tukey1df(DATA=a1,DEP=phos,INDEP1=treatment,INDEP2=block); 