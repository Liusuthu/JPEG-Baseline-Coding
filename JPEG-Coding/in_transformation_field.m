clear;clc;
construct_Dmatrix;
load('hall.mat');
db_gray=double(hall_gray);

P=db_gray(1:8,1:8);
%直接进行
dct_1=dct2(P-128);

%在变换域进行
full=ones(8,8);
dct_2=dct2(P)-128*dct2(full);

%比较一下结果
sub=dct_1-dct_2;