clear;clc;
load('snow_Codes_after_sacn.mat');
load('JpegCoeff.mat');
load('scan_order.mat');



AC_CODE='';

for s=1:320
scan_result=codes(1:64,s);
%%%%单次AC编码扫描%%%%%%若要复用，每次更新scan_result数组即可%%%%
ac_code="";
huff="";
run=0;
for i=1:63    
    if(scan_result(i+1)==0)%若遇到0
        run=run+1;        
    else%遇到非0的数
        value=scan_result(i+1);
        size=floor(log2(abs(value)))+1;
        if(run<16)%run不足zof编码
            for j=1:160
                if(ACTAB(j,1)==run && ACTAB(j,2)==size)
                   for k=1:ACTAB(j,3)
                       huff=huff+string(ACTAB(j,3+k));
                   end
                end
            end
            ac_code=ac_code+huff;
            if(value>=0)
                ac_code=ac_code+dec2bin(value);                
            else
                ac_code=ac_code+upside_down(dec2bin(-value));                
            end
            
        else%run超过zof编码
            while(run>=16)%先把所有zof编掉
                ac_code=ac_code+'11111111001';
                run=run-16;
            end
            %然后正常编码该非零整数
            for j=1:160
                if(ACTAB(j,1)==run && ACTAB(j,2)==size)
                   for k=1:ACTAB(j,3)
                       huff=huff+string(ACTAB(j,3+k));
                   end
                end
            end
            ac_code=ac_code+huff;
            if(value>=0)
                ac_code=ac_code+dec2bin(value);                
            else
                ac_code=ac_code+upside_down(dec2bin(-value));                
            end            
        end
        run=0;huff='';%每编完一个非零整数，刷新一下中间变量        
    end    
end
ac_code=ac_code+'1010';%结束编码eob
run=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AC_CODE=AC_CODE+ac_code;
end

ac_code=AC_CODE;
