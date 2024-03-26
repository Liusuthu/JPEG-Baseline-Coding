clear;clc;
construct_Dmatrix;
load('hall.mat');
gray=double(hall_gray);

pic_size=size(gray);
num_x=pic_size(1)/8;
num_y=pic_size(2)/8;

p_tmp=gray-128;
c_tmp=zeros(120,168);
%DCT
for i_x=1:num_x
   for i_y=1:num_y
       P=p_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8);
       C=D*P*D';
       c_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8)=C;       
   end
end

%IDCT
for i_x=1:num_x
   for i_y=1:num_y
       C=c_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8);
       P=D'*C*D;
       p_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8)=P;       
   end
end

recovery=uint8(p_tmp+128);

%对比展示
% imshow(log(abs(c_tmp)),[])
% colormap parula
% colorbar
figure();
subplot(1,2,1);
imshow(hall_gray);
subplot(1,2,2);
imshow(recovery);
