clear;clc;
load('JpegCoeff.mat');
%load('hall.mat');
load('snow.mat');

pic=double(snow);
pic=pic-128;
pic_size=size(pic);
H=pic_size(1)/8;
W=pic_size(2)/8;
C_matrix=zeros(128,160);


%%%%%%%%%%DCT+量化%%%%%%%%%%
for i_x=1:H
    for i_y=1:W
        tmp=pic(8*i_x-7:8*i_x,8*i_y-7:8*i_y);
        c_tmp=dct2(tmp);
        C_matrix(8*i_x-7:8*i_x,8*i_y-7:8*i_y)=round(c_tmp./QTAB);
    end
end


%%%%%%%%%%DC编码%%%%%%%%%%
length=H*W;
c_wave=zeros(1,length);
for i_x=1:H
    for i_y=1:W
        c_wave(i_y+(i_x-1)*W)=C_matrix(8*i_x-7,8*i_y-7);
    end
end
c_hat=zeros(1,length);
for i=1:length
    if(i==1)
        c_hat(i)=c_wave(i);
    else
        c_hat(i)=c_wave(i-1)-c_wave(i);
    end
end

category=zeros(1,length);
%%%%对每个元素编码
%先算出所有category
for i=1:length
    if(c_hat(i)==0)
       category(i)=0;       
    else
        category(i)=floor(log2(abs(c_hat(i))))+1;
    end
end
%再根据category查表得到编码
dc_code='';
for i=1:length
    huff_length=DCTAB(category(i)+1,1);
    tmp='';    
    %category的huffman码
    for j=1:huff_length
        tmp=tmp+string(DCTAB(category(i)+1,j+1));       
    end
    %值的编码
    if(c_hat(i)>=0)
        dc_code=dc_code+tmp+dec2bin(c_hat(i));
    else
        dc_code=dc_code+tmp+upside_down(dec2bin(-c_hat(i)));
    end   
end













% %%%IDCT解码，用于验证计算是正确的%%%
% for i_x=1:H
%     for i_y=1:W
%         c_tmp=C_matrix(8*i_x-7:8*i_x,8*i_y-7:8*i_y);
%         p_tmp=idct2(c_tmp);
%         P(8*i_x-7:8*i_x,8*i_y-7:8*i_y)=p_tmp;
%     end
% end
% pic2=uint8(P);
% imshow(pic2);
