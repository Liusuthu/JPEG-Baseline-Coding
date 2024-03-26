clear;clc;
load('scan_order.mat');
load('snow_C_matrix_after_DCnQuntize.mat');

H=16;
W=20;
codes=zeros(64,H*W);

for i_x=1:H
   for i_y=1:W
       codes(1,i_y+(i_x-1)*W)=C_matrix(i_x*8-7,i_y*8-7); 
   end
end

for i_x=1:H
   for i_y=1:W
       tmp=C_matrix(i_x*8-7:i_x*8,i_y*8-7:i_y*8); 
       for i=1:63
           codes(i+1,i_y+(i_x-1)*W)=tmp(scan_order(i,1),scan_order(i,2));           
       end
   end
end
