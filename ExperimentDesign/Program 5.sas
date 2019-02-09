data ch42;
input STRAIN EGGS;
 x1 = ABS(EGGS);
 x2 = SQRT(EGGS);
 x3 = EGGS**(1/2);
 x4 = EGGS**2;
 IF (EGGS > 0) THEN x5 = LOG(EGGS);
datalines;
1 448
1 906
1 28
1 277
1 634
1 48
1 369
1 137
1 29
1 522
1 319
1 242
1 261
1 566
1 734
2 211
2 276
2 415
2 787
2 18
2 118
2 1
2 151
2 0
2 253
2 61
2 0
2 275
2 0
2 153
3 0
3 9
3 143
3 1
3 26
3 127
3 161
3 294
3 0
3 348
3 0
3 14
3 21
3 0
3 218
；

PROC UNIVARIATE DATA=a1; 
   VAR newnum;
   QQPLOT newnum / normal(MU=EST SIGMA=EST); 
   RUN;
 
proc glm data=ch42;
class STRAIN;
model EGGS=STRAIN;
means STRAIN;
OUTPUT OUT=a42 PREDICTED=pred RESIDUAL=resid;
run;

 PROC UNIVARIATE NORMAL DATA=a42;
 VAR resid;
 QQPLOT resid / normal(MU=EST SIGMA=EST);
 RUN;
 
 PROC GPLOT DATA=a42;
 PLOT resid*pred;
 RUN;

 PROC GLM DATA=ch42;
 CLASS STRAIN;
 MODEL EGGS=STRAIN;
 MEANS STRAIN / HOVTEST=LEVENE HOVTEST=BF;
 RUN;
 
 *Save the mean and sd for each group in the dataset 'temp1';
 PROC MEANS NOPRINT DATA=ch42;
 BY STRAIN;
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
 *Note that there is no CLASS statement for GLM here;
 *This gives a regression rather than ANOVA model;


 DATA a1;
 SET ch42;
 newnum = sqrt(EGGS);
 RUN;
*Save the residuals and predicted values in the dataset 'a3';
 PROC GLM DATA=a1;
 CLASS STRAIN;
 MODEL newnum = STRAIN;
 OUTPUT OUT=a3 PREDICTED=pred RESIDUAL=resid;
 RUN;
*Plot of residuals vs. predicted values;
 PROC PLOT DATA=a3;
 PLOT resid*pred;
 RUN;

*Compute Levene's and Brown & Forsythe's HOV tests;
 PROC GLM DATA=a1;
 CLASS STRAIN;
 MODEL newnum = STRAIN;
 MEANS STRAIN / HOVTEST=LEVENE HOVTEST=BF;
 RUN;
 QUIT;

*Compute Levene's and Brown & Forsythe's HOV tests;
 PROC GLM DATA=ch42;
 CLASS STRAIN;
 MODEL EGGS = STRAIN;
 MEANS STRAIN / HOVTEST=LEVENE HOVTEST=BF;
 RUN;
 


data ch46;
input obs;
datalines;
2
3
4
5
10
28
34
35
39
63
87
97
112
156
188
253
;
DATA temp2;
   SET ch46 END=final;
   i = _N_;
   IF final THEN CALL SYMPUT('n_tot',_N_);
   RUN;

 DATA temp3;
   SET temp2;   
   Q_obs = obs;             *Observed  Quantiles;
   p = i/( &n_tot + 1 ) ; 
   Q_exp = PROBIT(p);     *Expected  Quantiles  (PROBIT is the inverse of the PROBNORM function); 
   RUN;                   


 PROC GPLOT DATA=temp3;
   PLOT Q_obs*Q_exp;
   RUN;
   


PROC UNIVARIATE DATA=ch46; 
   VAR obs;
   QQPLOT obs / normal(MU=EST SIGMA=EST); 
   RUN;