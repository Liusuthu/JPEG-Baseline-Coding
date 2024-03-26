clear;clc;

load('JpegCoeff.mat');
load('hall.mat');
length=5;
c_hat=[0 -1 1 3 -52];
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




