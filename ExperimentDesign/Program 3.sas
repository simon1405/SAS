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
contrast 'pretimed vs average of semi and actuated' trt 1 -0.5 -0.5;
contrast 'semi and actuated' trt 0 1 -1;
estimate 'pretimed vs average of semi and actuated' trt 1 -0.5 -0.5;
estimate 'semi and actuated' trt 0 1 -1;
means trt/BON;
run;

data ch33;
input N_LEVEL	NITROGEN	LETTUCE;
datalines;
1 0 104
1 0 114
1 0 90
1 0	140
2 50 134
2 50 130
2 50 144
2 50 174
3 100 146
3 100 142
3 100 152
3 100 156
4 150 147
4 150 160
4 150 160
4 150 163
5 200 131
5 200 148
5 200 154
5 200 163
;

proc glm data=ch33;
class NITROGEN;
model LETTUCE=NITROGEN;
CONTRAST 'linear' NITROGEN -2 -1 0 1 2;
CONTRAST 'quadratic' NITROGEN 2 -1 -2 -1 2;
CONTRAST 'cubic' NITROGEN -1 2 0 -2 1;
CONTRAST 'quartic' NITROGEN 1 -4 6 -4 1;
run;