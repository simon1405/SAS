 FILENAME file1 URL "http://www.uvm.edu/~rsingle/stat231/data/other/fabric.dat";
 DATA a1;
 INFILE file1 FIRSTOBS=2 EXPANDTABS;
 INPUT fabric $ loss;
 RUN;
 
 proc glm data=a1;
class fabric;
model loss=fabric;
contrast 'fabric B vs average of C and D' fabric 0 1 -0.5 -0.5;
*contrast 'semi and actuated' trt 0 1 -1;
estimate 'fabric B vs average of C and D' fabric 0 1 -0.5 -0.5;
*estimate 'semi and actuated' trt 0 1 -1;
means fabric/tukey;

run;

 proc glm data=a1;
 CLASS fabric;
 MODEL loss = fabric;
OUTPUT OUT=a42 PREDICTED=pred RESIDUAL=resid;
run;

 PROC UNIVARIATE NORMAL DATA=a42;
 VAR resid;
 QQPLOT resid / normal(MU=EST SIGMA=EST);
 RUN;
 
 PROC GPLOT DATA=a42;
 PLOT resid*pred;
 RUN;

 PROC GLM DATA=a1;
 CLASS fabric;
 MODEL loss = fabric;
 MEANS fabric / HOVTEST=LEVENE HOVTEST=BF;
 RUN;
 
 *Save the mean and sd for each group in the dataset 'temp1';
 PROC MEANS NOPRINT DATA=a1;
 BY fabric;
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