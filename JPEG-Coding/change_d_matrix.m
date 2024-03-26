clear;clc;
construct_Dmatrix;
load('hall.mat');
gray=double(hall_gray);

pic_size=size(gray);
num_x=pic_size(1)/8;
num_y=pic_size(2)/8;


%%%%转置
p_tmp=gray-128;
c_tmp=zeros(120,168);
D_1=D';
%DCT
for i_x=1:num_x
   for i_y=1:num_y
       P=p_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8);
       C=D_1*P*D_1';
       c_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8)=C;       
   end
end
%IDCT
for i_x=1:num_x
   for i_y=1:num_y
       C=c_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8);
       P=D_1'*C*D_1;
       p_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8)=P;       
   end
end
recovery_1=uint8(p_tmp+128);



%%%%旋转90度
p_tmp=gray-128;
c_tmp=zeros(120,168);
D_2=rot90(D);
%DCT
for i_x=1:num_x
   for i_y=1:num_y
       P=p_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8);
       C=D_2*P*D_2';
       c_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8)=C;       
   end
end
%IDCT
for i_x=1:num_x
   for i_y=1:num_y
       C=c_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8);
       P=D_2'*C*D_2;
       p_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8)=P;       
   end
end
recovery_2=uint8(p_tmp+128);


%%%%旋转180度
p_tmp=gray-128;
c_tmp=zeros(120,168);
D_3=rot90(rot90(D));
%DCT
for i_x=1:num_x
   for i_y=1:num_y
       P=p_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8);
       C=D_3*P*D_3';
       c_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8)=C;       
   end
end
%IDCT
for i_x=1:num_x
   for i_y=1:num_y
       C=c_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8);
       P=D_3'*C*D_3;
       p_tmp(i_x*8-7:i_x*8,i_y*8-7:i_y*8)=P;       
   end
end
recovery_3=uint8(p_tmp+128);


%展示
subplot(1,4,1);
imshow(hall_gray);
subplot(1,4,2);
imshow(recovery_1);
subplot(1,4,3);
imshow(recovery_2);
subplot(1,4,4);
imshow(recovery_3);

