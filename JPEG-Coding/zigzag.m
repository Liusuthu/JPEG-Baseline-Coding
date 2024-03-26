scan_order=zeros(63,2);
p=1;

for i=2:8
    if(mod(i,2)==0) %偶数
        i_x=1;
        i_y=i;
        for num=1:i
            scan_order(p,1)=i_x;
            scan_order(p,2)=i_y;
            i_x=i_x+1;
            i_y=i_y-1;
            p=p+1;
        end
    else            %奇数
        i_x=i;
        i_y=1;
        for num=1:i
            scan_order(p,1)=i_x;
            scan_order(p,2)=i_y;
            i_x=i_x-1;
            i_y=i_y+1;
            p=p+1;
        end
    end
end

for i=9:15
    if(mod(i,2)==0) %偶数
        i_x=i-7;
        i_y=8;
        for num=1:16-i
            scan_order(p,1)=i_x;
            scan_order(p,2)=i_y;
            i_x=i_x+1;
            i_y=i_y-1;
            p=p+1;
        end        
    else            %奇数
        i_x=8;
        i_y=i-7;
        for num=1:16-i
            scan_order(p,1)=i_x;
            scan_order(p,2)=i_y;
            i_x=i_x-1;
            i_y=i_y+1;
            p=p+1;
        end            
    end    
end