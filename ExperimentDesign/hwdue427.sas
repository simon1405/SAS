FILENAME file1 URL "http://www.uvm.edu/~rsingle/stat231/data/kuehl/ex14_1.txt";
 DATA a1;
 INFILE file1 FIRSTOBS=2 EXPANDTABS;
 INPUT HYBRID BLOCK DENSITY_LEVEL WEIGHT DENSITY;
 
 proc Glm data=a1;
 class HYBRID BLOCK DENSITY_LEVEL ;
 model WEIGHT=BLOCK DENSITY_LEVEL BLOCK*DENSITY_LEVEL HYBRID DENSITY_LEVEL*HYBRID;
 random block BLOCK*DENSITY_LEVEL;
 means hybrid density_level DENSITY_LEVEL*HYBRID;
lsmeans hybrid density_level DENSITY_LEVEL*HYBRID block/stderr;

 contrast 'linear Den' density_level -0.546 -0.327 0.109 0.764;
 contrast 'quad Den' density_level 0.513 -0.171 -0.741 0.399;
 contrast 'cubic Den' density_level -0.435 0.783 -0.435 0.087;
 contrast 'H*linear Den' density_level*HYBRID -0.546 -0.327 0.109 0.764 0.546 0.327 -0.109 -0.764 0 0 0 0,
                         density_level*HYBRID  0 0 0 0 -0.546 -0.327 0.109 0.764  0.546 0.327 -0.109 -0.764;
 contrast 'H*quad Den' density_level*HYBRID 0.513 -0.171 -0.741 0.399 -0.513 0.171 0.741 -0.399 0 0 0 0,
                         density_level*HYBRID  0 0 0 0 0.513 -0.171 -0.741 0.399 -0.513 0.171 0.741 -0.399;                       
 contrast 'H*cubic Den' density_level*HYBRID -0.435 0.783 -0.435 0.087 0.435 -0.783 0.435 -0.087 0 0 0 0,
                         density_level*HYBRID  0 0 0 0 -0.435 0.783 -0.435 0.087 0.435 -0.783 0.435 -0.087;                        
 run;
 
 