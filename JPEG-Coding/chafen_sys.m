clear;clc;
Matrix=[
    1  0  0  0  0  0  0  0;
    1 -1  0  0  0  0  0  0;
    0  1 -1  0  0  0  0  0;
    0  0  1 -1  0  0  0  0;
    0  0  0  1 -1  0  0  0;
    0  0  0  0  1 -1  0  0;
    0  0  0  0  0  1 -1  0;
    0  0  0  0  0  0  1 -1];

sys=ss(Matrix);