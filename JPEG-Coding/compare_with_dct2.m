clear;clc;
construct_Dmatrix;
load('hall.mat');

db_gray=double(hall_gray);

P=db_gray(1:8,1:8);
my_dct=D*P*D';
ml_dct=dct2(P);

sub=my_dct-ml_dct;
test=(my_dct-ml_dct<0.000000001);


