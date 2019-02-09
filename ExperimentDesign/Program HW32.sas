FILENAME file1 URL "http://www.uvm.edu/~rsingle/stat231/data/kuehl/ex5_4.txt";
DATA con;
INFILE file1 FIRSTOBS=2 EXPANDTABS;    
INPUT LOT AFLATOXIN;
RUN;

 PROC GLM DATA=con;
 CLASS LOT;
 MODEL AFLATOXIN = LOT;
 RANDOM LOT;
 means Lot;
 OUTPUT OUT=a2 PREDICTED=pred RESIDUAL=resid;
 RUN;
 
 
 
 proc glm data=con;
 CLASS LOT;
 MODEL AFLATOXIN = LOT;
OUTPUT OUT=a42 PREDICTED=pred RESIDUAL=resid;
run;

 PROC UNIVARIATE NORMAL DATA=a42;
 VAR resid;
 QQPLOT resid / normal(MU=EST SIGMA=EST);
 RUN;
 
 PROC GPLOT DATA=a42;
 PLOT resid*pred;
 RUN;

 PROC GLM DATA=con;
 CLASS LOT;
 MODEL AFLATOXIN = LOT;
 MEANS LOT / HOVTEST=LEVENE HOVTEST=BF;
 RUN;
 
 *Save the mean and sd for each group in the dataset 'temp1';
 PROC MEANS NOPRINT DATA=con;
 BY LOT;
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
 
 
 
 
 
 
 DATA temp0;
 df = 27;
 alpha1 = 0.95;
 alpha2 = 0.05;
 quantile_Chisq1 = QUANTILE('CHISQ', alpha1, df);
 quantile_Chisq2 = QUANTILE('CHISQ', alpha2, df);
 RUN;
 PROC PRINT DATA=temp0;
 RUN;

 
 %MACRO doit_power(alpha=, lambda=, df1=, df2=);
 DATA temp1;
 lambda = &lambda;
 quantile_F = QUANTILE('F', 1-&alpha, &df1, &df2);
 x = ( (1/&lambda)**2 ) * quantile_F;
 power = 1 - CDF('F', x, &df1, &df2);
 RUN;
 PROC PRINT DATA=temp1;
 PROC DELETE DATA=temp1; RUN;
%MEND doit;

 %doit_power(alpha=.05, lambda=3, df1=4, df2=45);

  PROC GLM DATA=con;
 CLASS LOT;
 MODEL AFLATOXIN = LOT;
 RANDOM LOT;
 OUTPUT OUT=a2 PREDICTED=pred RESIDUAL=resid;
 RUN;
 
 
 FILENAME file1 URL "http://www.uvm.edu/~rsingle/stat231/data/kuehl/ex5_8.txt";
DATA ch58;
INFILE file1 FIRSTOBS=2 EXPANDTABS;    
INPUT FIELD	SECTION	POROSITY;
RUN;

data ch58;
set ch58;
sample = _N_;
run;

 PROC GLM DATA=CH58;
 CLASS field section sample;
 MODEL porosity = field section sample / E1;
 RANDOM field section sample/ TEST;
 TEST H=field E=section / HTYPE=1 ETYPE=1;
  TEST H=section E=sample / HTYPE=1 ETYPE=1;
 RUN;
 QUIT;
-----------
 