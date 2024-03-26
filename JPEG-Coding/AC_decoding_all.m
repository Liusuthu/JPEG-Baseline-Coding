clc;clear;
load('JpegCoeff.mat');
load('scan_order.mat');
load('ac_code.mat');


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
%ac_code="110101011011100001011111100101110011001011011001111111001100101001111111101001010";
matrix=zeros(8,8);
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


