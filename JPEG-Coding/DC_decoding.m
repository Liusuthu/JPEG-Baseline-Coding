clear;clc;
load('JpegCoeff.mat');
load('hall.mat');
load('DC_CODE.mat')

%%%%%%%%%%%%%%%%%%大致思路%%%%%%%%%%%%%%%%%%%
% 1.先根据Huffman码找到category
% 2.根据category的值大小明确c_hat值的位数
% 3.取相应的c_hat二进制，判断正负，并取出该值
% 4.重复1~3直到取完
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

book=["00","010","011", "100", "101", "110", "1110", "11110", "111110", "1111110", "11111110", "111111110"];
c_hat=zeros(1,350);
c_wave=zeros(1,315);
len=strlength(dc_code);
% dc_code="00001000101011111110001011";
% len=strlength(dc_code);


tmp="";
huff_tmp="";
i=1;%作为指向字符串中元素的指针
j=1;%作为存储c_hat的指针
flag=0;%用于判定book中有无huffman码
category=0;%每次返回的category
while(i<len)
    huff_tmp=huff_tmp+extract(dc_code,i);
    for k=1:12
        if(huff_tmp==book(k))
            flag=1;
            category=k-1;
            huff_tmp="";
            break;            
        end    
    end
    %看看有没有匹配成功
    if(flag==0)
        i=i+1;
    else
        if(category==0)
            i=i+2;
            c_hat(j)=0;
            j=j+1;
        else
            num=extractBetween(dc_code,i+1,i+category);
            if(extract(num,1)=="1")%正数
                c_hat(j)=bin2dec(num);
            else%负数
                c_hat(j)=-bin2dec(upside_down(num));
            end
            i=i+category+1;
            j=j+1;
        end
        flag=0;
    end
end

for i=1:315
    if(i==1)
        c_wave(i)=c_hat(i);
    else
        c_wave(i)=c_wave(i-1)-c_hat(i);
    end    
end

%%%%证明了我的DC_decode是正确的
% clear;
% a=load('c_hat_coding');
% b=load('c_hat_decoding');
% a=a.c_hat;
% b=b.c_hat;
% true=zeros(1,315);
% for i=1:315
%     true(i)=a(i)==b(i);
% end

% clear;
% a=load('c_wave_coding');
% b=load('c_wave_decoding');
% a=a.c_wave;
% b=b.c_wave;
% true_cwave=zeros(1,315);
% for i=1:315
%     true_cwave(i)=a(i)==b(i);
% end

