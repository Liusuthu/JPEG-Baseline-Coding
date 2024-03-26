clear;clc;
construct_Dmatrix;
load('hall.mat');
gray=double(hall_gray);

pic_size=size(gray);
num_x=pic_size(1)/8;
num_y=pic_size(2)/8;


%%%%右侧四列置零
p_tmp=gray-128;
c_tmp=zeros(120,168);
D_right=D;
for i_x=1:8
   for i_y=5:8
       D_right(i_x,i_y)=0;
   end
end
%DCT
for i_x=1:num_x
   for i_y=1:num_y
       P=p_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8);
       C=D_right*P*D_right';
       c_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8)=C;       
   end
end
%IDCT
for i_x=1:num_x
   for i_y=1:num_y
       C=c_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8);
       P=D_right'*C*D_right;
       p_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8)=P;       
   end
end
recovery_right=uint8(p_tmp+128);



%%%%左侧四列置零
p_tmp=gray-128;
c_tmp=zeros(120,168);
D_left=D;
for i_x=1:8
   for i_y=1:4
       D_left(i_x,i_y)=0;
   end
end
%DCT
for i_x=1:num_x
   for i_y=1:num_y
       P=p_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8);
       C=D_left*P*D_left';
       c_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8)=C;       
   end
end
%IDCT
for i_x=1:num_x
   for i_y=1:num_y
       C=c_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8);
       P=D_left'*C*D_left;
       p_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8)=P;       
   end
end
recovery_left=uint8(p_tmp+128);


%对比展示
subplot(1,3,1);
imshow(hall_gray);
title('原图');
subplot(1,3,2);
imshow(recovery_left);
title('左侧4列为0');
subplot(1,3,3);
imshow(recovery_right);
title('右侧4列为0');