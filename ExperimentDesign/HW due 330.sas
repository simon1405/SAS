*1;
 FILENAME file1 URL "http://www.uvm.edu/~rsingle/stat231/data/kuehl/ex6_3.txt";
 DATA a1;
 INFILE file1 FIRSTOBS=2 EXPANDTABS;
 INPUT FABRIC TEMP_LEVEL SHRINKAGE DEGREES;
 RUN;
 PROC GLM DATA=a1;
 CLASS FABRIC DEGREES;
 MODEL SHRINKAGE = FABRIC DEGREES FABRIC*DEGREES;
 contrast 'temp_linear' DEGREES -3 -1 1 3; 
 contrast 'temp_quadratic' DEGREES 1 -1 -1 1;
 contrast 'temp_linear * fabric' FABRIC*DEGREES -3 -1 1 3 0 0 0 0 0 0 0 0 3 1 -1 -3, 
                        FABRIC*DEGREES  0 0 0 0 -3 -1 1 3 0 0 0 0 3 1 -1 -3, 
                        FABRIC*DEGREES  0 0 0 0 0 0 0 0 -3 -1 1 3 3 1 -1 -3; 
                        
 contrast 'temp_quadratic * fabric' FABRIC*DEGREES 1 -1 -1 1 0 0 0 0 0 0 0 0 -1 1 1 -1, 
                        FABRIC*DEGREES  0 0 0 0 1 -1 -1 1 0 0 0 0 -1 1 1 -1, 
                        FABRIC*DEGREES  0 0 0 0 0 0 0 0 1 -1 -1 1 -1 1 1 -1; 
 
 LSMEANS  FABRIC*DEGREES / slice=FABRIC;
 RUN;
 
 PROC GLM DATA=a1;
 CLASS  DEGREES FABRIC;
 MODEL SHRINKAGE = DEGREES FABRIC  DEGREES*FABRIC;
 run;
 
  *2;
 FILENAME file1 URL "http://www.uvm.edu/~rsingle/stat231/data/kuehl/ex6_8.txt";
 DATA a2;
 INFILE file1 FIRSTOBS=2 EXPANDTABS;
 INPUT HEIGHT CLAMP THICKNESS;
 RUN;
 PROC GLM DATA=a2;
 CLASS CLAMP HEIGHT;
 MODEL THICKNESS = CLAMP HEIGHT CLAMP*HEIGHT;
run;

 FILENAME macro231 URL "http://www.uvm.edu/~rsingle/stat231/macros-stat231.sas";
 %INCLUDE macro231; 
* Compute SS(NonAdd);
 %tukey1df(DATA=a2,DEP=THICKNESS,INDEP1=CLAMP,INDEP2=HEIGHT);

* Look for a transformation to remove any multiplicative non-addititvity;
 %tukey1df_transf(DATA=a2,DEP=THICKNESS,INDEP1=CLAMP,INDEP2=HEIGHT); 
 
 *3;
FILENAME file1 URL "http://www.uvm.edu/~rsingle/stat231/data/kuehl/ex6_11.txt";
 DATA a3;
 INFILE file1 FIRSTOBS=2 EXPANDTABS;
 INPUT BASE	ALCOHOL	YIELD;
 RUN;
 PROC GLM DATA=a3;
 CLASS BASE	ALCOHOL;
 MODEL YIELD = BASE	ALCOHOL BASE*ALCOHOL/E3;
 MEANS BASE ALCOHOL;
 LSMEANS BASE ALCOHOL/ STDERR;
 LSMEANS BASE*ALCOHOL/ SLICE=ALCOHOL;
 ESTIMATE 'A1' BASE 1 -1 BASE*ALCOHOL 1 0 0 -1 0 0;
 ESTIMATE 'A2' BASE 1 -1 BASE*ALCOHOL 0 1 0 0 -1 0;
 ESTIMATE 'A3' BASE 1 -1 BASE*ALCOHOL 0 0 1 0 0 -1;
run;
