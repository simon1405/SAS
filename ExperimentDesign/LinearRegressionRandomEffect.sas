data a1;
input Litter X Y;
datalines;
1 1 1.7
1 2 3.6
1 3 10.9
2 1 6.0
2 2 12.8
2 3 13.0
3 1 12.5
3 2 13.0
3 3 19.8
4 1 10.1
4 2 14.5
4 3 15.3
;

proc mixed data=a1 method=REML;
class litter;
model y=x /s;
random litter int /type=vc s;
run;