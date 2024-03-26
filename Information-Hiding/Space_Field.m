load('hall.mat');
message=zeros(120,168);
hide_pic=zeros(120,168);

for i=1:120
   if(mod(i,2)==1)
       message(i,1:168)=ones(1,168);   
   end
end

hide_pic=double(hall_gray);
for i=1:120
    if(mod(i,2)==1) %奇数行藏1
        for j=1:168
            if(mod(hide_pic(i,j),2)==0) %像素值为偶，值加一
                hide_pic(i,j)=hide_pic(i,j)+1;
            else                        %像素值为奇，值不变                
            end
        end
    else            %偶数行藏0
        for j=1:168
            if(mod(hide_pic(i,j),2)==0)	%像素值为偶，值不变                
            else                        %像素值为奇，值减一
                hide_pic(i,j)=hide_pic(i,j)-1;
            end
        end
    end    
end
    

hide_pic_show=uint8(hide_pic);
subplot(1,2,1);
imshow(hall_gray);
title('原图');

subplot(1,2,2);
imshow(hide_pic_show);
title('隐藏后图片');


%%%提取信息
message_get=zeros(120,168);
for i=1:120
    for j=1:168
        if(mod(hide_pic(i,j),2)==0) %偶数提取0
            message_get(i,j)=0;
        else                    %奇数提取1
            message_get(i,j)=1;
        end
    end
end