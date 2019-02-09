data hw37;
input SUGAR_LEVEL GROWTH;
datalines;
1 45
1 39
1 40
1 45
1 42
2 25
2 28
2 30
2 29
2 33
3 28
3 31
3 24
3 28
3 27
4 31
4 37
4 35
4 33
4 34
;

proc glm data=hw37;
class SUGAR_LEVEL;
model GROWTH=SUGAR_LEVEL;
means SUGAR_LEVEL/ dunnett('1');
run;



data ch31;
input x trt;
datalines;
36.6 1
39.2 1
30.4 1
37.1 1
34.1 1
17.5 2
20.6 2
18.7 2
25.7 2
22 2
15 3
10.4 3
18.9 3
10.5 3
15.2 3
;
proc glm data=ch31;
class trt;
model x=trt;
means trt;
contrast 'pretimed vs average of semi and actuated' trt 1 -0.5 -0.5;
estimate 'pretimed vs average of semi and actuated' trt 1 -0.5 -0.5;
run;

proc glm data=ch31;
class trt;
model x=trt;
contrast 'pretimed vs average of semi and actuated' trt 1 -0.5 -0.5;
contrast 'semi and actuated' trt 0 1 -1;
estimate 'pretimed vs average of semi and actuated' trt 1 -0.5 -0.5;
estimate 'semi and actuated' trt 0 1 -1;
means trt/bon;
means trt/bon cldiff;
means trt/scheffe;
means trt/scheffe cldiff;
run;

data add1;
input hr rt;
datalines;
12 20
12 20
12 17
12 19
12 20
12 19
12 21
12 19
18 21
18 20
18 21
18 22
18 20 
18 20
18 23
18 19
24 25 
24 23
24 22
24 23
24 21
24 22
24 22
24 23
30 26
30 27 
30 24
30 27 
30 25
30 28
30 26
30 27
;

data ch311;
input trt SERUM;
datalines;
1 94.09
1 90.45
1 99.38
1 73.56
1 74.39
2 98.81
2 103.55
2 115.23
2 129.06
2 117.61
3 197.18
3 207.31
3 177.5
3 226.05
3 222.74
4 102.93
4 117.51
4 119.92
4 112.01
4 101.1
5 82.94
5 83.14
5 89.59
5 87.76
5 96.43
run;

proc glm data=ch311;
class trt;
model SERUM=trt;
means trt / snk;
run;

proc glm data=ch311;
class trt;
model SERUM=trt;
MEANS trt / TUKEY;
MEANS trt / LSD;
MEANS trt / TUKEY CLDIFF;
MEANS trt / LSD;
means trt / snk;
run;

proc glm data=add1;
class hr;
model rt=hr;
estimate 'comparing 30hrs and others' hr -1 -1 -1 3 / divisor=3;
estimate 'comparing after a day and less than a day' hr 1 1 -1 -1 / divisor=2;
estimate 'orthogonal to part b and c' hr 1 -1 0 0;
contrast 'Linear' hr       -3 -1  1 3;
contrast 'Quadratic' hr     1 -1 -1 1;
contrast 'Cubic'  hr       -1  3 -3 1;

run;

proc glm data=add1;
class hr;
model rt=hr;
mean hr;
run;