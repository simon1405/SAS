 FILENAME file1 URL "http://www.uvm.edu/~rsingle/stat231/data/kuehl/ex5_6.txt";
 DATA a1;
 INFILE file1 FIRSTOBS=2 EXPANDTABS;
 INPUT MANUFACTURER	FILTER	PERCENT;
 RUN;
 data a1;
set a1;
sample = _N_;
tests=(MANUFACTURER-1)*3+FILTER;
run;

 PROC GLM DATA=a1;
 CLASS MANUFACTURER tests sample;
 MODEL percent = MANUFACTURER  tests sample/ E1;
 RANDOM MANUFACTURER tests/ TEST;
 TEST H=MANUFACTURER E=tests / HTYPE=1 ETYPE=1;
 TEST H=tests E=sample / HTYPE=1 ETYPE=1;
 means manufacturer/bon;
 means manufacturer/scheffe;
 RUN;
 QUIT;
 

 
 

FILENAME file1 URL "http://www.uvm.edu/~rsingle/stat231/data/kuehl/ex6_1.txt";
 DATA a2;
 INFILE file1 FIRSTOBS=2 EXPANDTABS;
 INPUT BASE	ALCOHOL	YIELD;
 RUN;

 PROC GLM DATA=a2;
 CLASS ALCOHOL BASE;
 MODEL YIELD = ALCOHOL BASE ALCOHOL*BASE;
 CONTRAST 'A1vA2 ' ALCOHOL 1 0 -1;
 CONTRAST 'A1vA3 ' ALCOHOL*BASE 1 1  0 0  -1 -1;
run;

 data a2;
set a2;
tests=(base-1)*3+alcohol;
run;
 PROC GLM DATA=a2;
 CLASS alcohol base;
 MODEL YIELD = alcohol base alcohol*base;
 MEANS alcohol base/ HOVTEST=LEVENE HOVTEST=BF;
 RUN;
 
proc glm data=a2;
 CLASS alcohol base;
 MODEL yield = alcohol base alcohol*base;
OUTPUT OUT=a42 PREDICTED=pred RESIDUAL=resid;
run;

 PROC UNIVARIATE NORMAL DATA=a42;
 VAR resid;
 QQPLOT resid / normal(MU=EST SIGMA=EST);
 RUN;
 
 PROC GPLOT DATA=a42;
 PLOT resid*pred;
 RUN;


PROC MEANS NOPRINT DATA=a2;
 OUTPUT OUT=temp1 MEAN=mean STD=sd;
 RUN;
*Add the variables logsd and logmean to the dataset;
 DATA temp1;
 SET temp1;
 logsd = LOG(sd);
 logmean = LOG(mean);
 RUN;
*Plot the relationship between logsd and logmean;
 PROC PLOT VPERCENT=50 DATA=temp1;
 PLOT logsd*logmean;
 RUN;
*Find the slope of the estimated regression line;
 PROC GLM DATA=temp1;
 MODEL logsd = logmean;
 RUN;
 QUIT;


FILENAME file1 URL "http://www.uvm.edu/~rsingle/stat231/data/kuehl/exp6_4.txt";
 DATA a3;
 INFILE file1 FIRSTOBS=2 EXPANDTABS;
 INPUT SALINITY	DAYS S_LEVEL D_LEVEL WATER;
 RUN;

 PROC GLM DATA=a3;
 CLASS S_LEVEL D_LEVEL;
 MODEL water = S_LEVEL D_LEVEL S_LEVEL*D_LEVEL;
 CONTRAST 'S_linear' S_LEVEL -1 0 1;
 CONTRAST 'S_quadra' S_LEVEL 1 -2 1; 
 CONTRAST 'D_linear' D_LEVEL -1 0 1;
 CONTRAST 'D_quadra' D_LEVEL 1 -2 1; 
 CONTRAST 'S_linear*D_linear' S_LEVEL*D_LEVEL 1 0 -1 0 0 0 -1 0 1;
 CONTRAST 'S_linear*D_quadra' S_LEVEL*D_LEVEL -1 2 -1 0 0 0  1 -2 1; 
 CONTRAST 'S_quadra*D_linear' S_LEVEL*D_LEVEL -1 0 1 2 0 -2 -1 0 1;
 CONTRAST 'S_quadra*D_quadra' S_LEVEL*D_LEVEL 1 -2 1 -2 4 -2 1 -2 1;
run; 
 
 