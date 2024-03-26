clc;clear;
load('C_matrix_after_DCnQuntize.mat');
load('scan_order');
%%第一种隐藏方法：每位都替换之前的message信息
dct_1=C_matrix;
for i=1:120
    if(mod(i,2)==1) %奇数行藏1
        for j=1:168
            if(mod(dct_1(i,j),2)==0) %像素值为偶，值加一
                dct_1(i,j)=dct_1(i,j)+1;
            else                        %像素值为奇，值不变                
            end
        end
    else            %偶数行藏0
        for j=1:168
            if(mod(dct_1(i,j),2)==0)	%像素值为偶，值不变                
            else                        %像素值为奇，值减一
                dct_1(i,j)=dct_1(i,j)-1;
            end
        end
    end    
end

%%第二种隐藏方法：只对每个分块的7~8行进行数据隐藏，方法同上
dct_2=C_matrix;
for i=1:120
    if(mod(i,2)==1 && mod(i,8)==7)	%奇数行藏1
        for j=1:168
            if(mod(dct_2(i,j),2)==0) %像素值为偶，值加一
                dct_2(i,j)=dct_2(i,j)+1;
            else                        %像素值为奇，值不变                
            end
        end
    elseif(mod(i,8)==0)             %偶数行藏0
        for j=1:168
            if(mod(dct_2(i,j),2)==0)	%像素值为偶，值不变                
            else                        %像素值为奇，值减一
                dct_2(i,j)=dct_2(i,j)-1;
            end
        end
    end    
end

%%第三种隐藏方法：每个分块只有一个信息
dct_3=C_matrix;
zz_message=zeros(15,21);
for i=1:15
   if(mod(i,2)==1)
       zz_message(i,1:21)=ones(1,21);   
   else
       zz_message(i,1:21)=zeros(1,21)-ones(1,21);
   end
end

for i_x=1:15
    for i_y=1:21
        tmp=C_matrix(i_x*8-7:i_x*8,i_y*8-7:i_y*8);
        i=63;
        while(i>=1)
            if(tmp(scan_order(i,1),scan_order(i,2))~=0)
                tmp(scan_order(i,1),scan_order(i,2))=zz_message(i_x,i_y);
                C_matrix(i_x*8-7:i_x*8,i_y*8-7:i_y*8)=tmp;
                break;
            else
                i=i-1;
            end
        end
    end    
end

clear i i_x i_y j scan_order C_matrix tmp 
