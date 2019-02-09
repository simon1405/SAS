*Project;
*Group No.2;
*Felix Torres, Shitao Wang, Zihao Huang;

data data;  
INPUT design ww wl pc rep time;
datalines;
1 1 1 1 1 2.50
1 1 1 1 2 2.45
1 1 1 1 3 2.61
2 1 1 2 1 2.57
2 1 1 2 2 2.23
2 1 1 2 3 2.36
3 2 1 1 1 2.56
3 2 1 1 2 2.43
3 2 1 1 3 2.58
4 2 1 2 1 2.30
4 2 1 2 2 2.13
4 2 1 2 3 2.35
5 1 2 1 1 1.80
5 1 2 1 2 1.82
5 1 2 1 3 2.00
6 1 2 2 1 1.73
6 1 2 2 2 1.95
6 1 2 2 3 1.97
7 2 2 1 1 2.10
7 2 2 1 2 2.13
7 2 2 1 3 2.21
8 2 2 2 1 1.93
8 2 2 2 2 1.85
8 2 2 2 3 1.90
;
RUN;

*ANOVA for experimental designs;
proc GLM data=data;
class WL WW PC ;
model TIME= WL WW PC WL*WW WL*PC WW*PC WL*WW*PC;
OUTPUT OUT=a42 PREDICTED=pred RESIDUAL=resid;
run;
*Test on the homogeneity of Variance;
proc glm data=data;
class design ww wl pc;
model time = design;
MEANS design / HOVTEST=LEVENE HOVTEST=BF;
run;
*Q-Q plot for designs;
 PROC UNIVARIATE NORMAL DATA=a42;
 VAR resid;
 QQPLOT resid / normal(MU=EST SIGMA=EST);
 RUN;
*Residual plot for designs;
 PROC GPLOT DATA=a42;
 PLOT resid*pred;
 RUN;

data a_exp1;
input WW WL PC SUM;
datalines;
1 1 1 2.50
1 1 2 2.36
2 1 1 2.56
2 1 2 2.30
1 2 1 1.82
1 2 2 1.95
2 2 1 2.13
2 2 2 1.90
;
*Assessing 1 d.f. ANOVA; 
proc GLM data=a_exp1;
class WL WW PC ;
model SUM= WL WW PC WL*WW WL*PC WW*PC;
lsmeans WL WW PC/ CL stderr;
run;

