clc;clear;
load('JpegCoeff.mat');
load('scan_order.mat');
load('jpegcodes_dct_2.mat');
load('hall.mat');
load('DCT_Field_Hiding_C_matrixs.mat');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%先进行AC解码%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%创建对照书%%%%%%%%%%
book=repmat("",16,10);%注：对于book，其中竖向1~16分别对应run0~15，横向10则表示size1~10
for i=1:16
    for j=1:10
        num=ACTAB(j+(i-1)*10,3);
        tmp='';
        for k=1:num
            tmp=tmp+string(ACTAB(j+(i-1)*10,3+k));
        end
        book(i,j)=tmp;
    end   
end
clear i j k num tmp;
%%%%%%%%从编码中逐步解码%%%%%
code_len=strlength(ac_code);
recover_result=zeros(64,315);
ac_decode_num=1;%用于决定写入哪块方格
pointer=2;%用于写入recover_result数组，作为写入位置指针
flag=0;%0表示没有检索到，1表示zof，2表示eob，3表示正常编码

tmp='';
i=1;
while(i<=code_len)
    tmp=tmp+extract(ac_code,i);
    %判断是否是某个Huffman编码
    if(tmp=="11111111001")  %zof
        flag=1;
    elseif(tmp=="1010")     %eob
        flag=2;
    end
    for m=1:16              %普通
        for n=1:10
            if(flag==0 && tmp==book(m,n))
                run=m-1;
                size=n;
                flag=3;
            end
        end
    end
    
    if(flag==0)         %如果没有找到huffman码，则加一位继续
        i=i+1;
    else                %找到Huffman码，进行写入操作
        if(flag==1)     %zof
            for k=pointer:pointer+15
                recover_result(k,ac_decode_num)=0;
            end
            pointer=pointer+16;
            i=i+1;
        elseif(flag==2) %eob
            for k=pointer:64
                recover_result(k,ac_decode_num)=0;
            end
            i=i+1;
            pointer=2;
            ac_decode_num=ac_decode_num+1;
        else            %正常编码
            num_tmp="";
            if(run~=0)  %先把run的0补齐  
                for k=pointer:pointer+run-1
                    recover_result(k,ac_decode_num)=0;
                end
                pointer=pointer+run;
            end
            num_tmp=extractBetween(ac_code,i+1,i+size);
            if(extract(num_tmp,1)=="1") %正数
                recover_result(pointer,ac_decode_num)=bin2dec(num_tmp);
            else                        %负数
                recover_result(pointer,ac_decode_num)=-bin2dec(upside_down(num_tmp));
            end
            pointer=pointer+1;
            i=i+size+1; 
        end
        %写完后对一些必要的中间变量做reset
        num_tmp="";
        flag=0;run=0;size=0;
        tmp='';
    end
end
clear ac_decode_num code_len flag i k m n num_tmp pointer run size tmp book;
%%%%%结果存在recover_result中,第一行准备被DC系数填补%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%再进行DC解码%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
book=["00","010","011", "100", "101", "110", "1110", "11110", "111110", "1111110", "11111110", "111111110"];
c_hat=zeros(1,315);
c_wave=zeros(1,315);
len=strlength(dc_code);
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
clear i j k flag huff_tmp book category len num tmp c_hat;
%将结果c_wave存入recover_result中
for i=1:315
    recover_result(1,i)=c_wave(i);
end
clear i;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%复原得到原量化后矩阵%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H=H_full/8;W=W_full/8;
C_matrix_rcv=zeros(H_full,W_full);
%交流分量赋值
for i_x=1:H
    for i_y=1:W
        c_tmp=zeros(8,8);
        recover_tmp=recover_result(1:64,i_y+(i_x-1)*W);
        for i=1:63
            c_tmp(scan_order(i,1),scan_order(i,2))=recover_tmp(i+1);
        end
        C_matrix_rcv(i_x*8-7:i_x*8,i_y*8-7:i_y*8)=c_tmp;
    end
end
%直流分量赋值
for i_x=1:H
    for i_y=1:W
        C_matrix_rcv(i_x*8-7,i_y*8-7)=recover_result(1,i_y+(i_x-1)*W);
    end
end
clear c_tmp c_wave i i_x i_y recover_tmp


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%经过处理得到原图像%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C_matrix_iQuantize=zeros(120,168);
P_matrix=zeros(120,168);
%反量化
for i_x=1:H
    for i_y=1:W
        C_matrix_iQuantize(i_x*8-7:i_x*8,i_y*8-7:i_y*8)=C_matrix_rcv(i_x*8-7:i_x*8,i_y*8-7:i_y*8).*QTAB;      
    end
end
%逆DCT变换
for i_x=1:H
    for i_y=1:W
        P_matrix(i_x*8-7:i_x*8,i_y*8-7:i_y*8)=idct2(C_matrix_iQuantize(i_x*8-7:i_x*8,i_y*8-7:i_y*8));    
    end
end
%加回去128
P_matrix=P_matrix+128;
%回到灰度图像
P_matrix=uint8(P_matrix);
clear i_x i_y C_matrix_iQuantize hall_color



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%评价图像的压缩效果%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(1,2,1);
imshow(hall_gray);
title('原图');

subplot(1,2,2);
imshow(P_matrix);
title('隐藏信息后图片');


MSE=0;
for i_x=1:120
    for i_y=1:168
        MSE=MSE+(double(P_matrix(i_x,i_y))-double(hall_gray(i_x,i_y)))^2;
    end
end
MSE=MSE/120/168;
PSNR=10*log10(255^2/MSE);
clear i_x i_y 

YSB=120*168*8/(strlength(ac_code)+strlength(dc_code));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%提取隐藏信息%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
back=C_matrix_rcv;
%%%dct1的提取
% message_rcv=zeros(120,168);
% for i=1:120
%     for j=1:168
%         if(mod(back(i,j),2)==0) %偶数提取0
%             message_rcv(i,j)=0;
%         else                    %奇数提取1
%             message_rcv(i,j)=1;
%         end
%     end
% end

%%%dct2的提取
% message_rcv=zeros(120,168);
% for i=1:120
%     for j=1:168
%         if(mod(i,8)==0 || mod(i,8)==7)
%             if(mod(back(i,j),2)==0) %偶数提取0
%                 message_rcv(i,j)=0;
%             else                    %奇数提取1
%                 message_rcv(i,j)=1;
%             end
%         end
%     end
% end

%%%dct3的提取
message_rcv=zeros(15,21);
for i_x=1:15
    for i_y=1:21
        i=63;
        tmp=back(i_x*8-7:i_x*8,i_y*8-7:i_y*8);
        while(i>=1)
            if(tmp(scan_order(i,1),scan_order(i,2))~=0)
                message_rcv(i_x,i_y)=tmp(scan_order(i,1),scan_order(i,2));
                break;
            else
                i=i-1;
            end            
        end
    end    
end
zz_message=zeros(15,21);
for i=1:15
   if(mod(i,2)==1)
       zz_message(i,1:21)=ones(1,21);   
   else
       zz_message(i,1:21)=zeros(1,21)-ones(1,21);
   end
end
message_rcv=zz_message;

