N=8;
D=zeros(8,8);

%第1行
for j=1:N
   i=1;
   D(i,j)=sqrt(1/2);
end

%第2~8行
for i=2:N
   for j=1:N
       D(i,j)=cos( (2*j-1)*(i-1)*pi/(2*N) );
   end
end

%补上一个系数1/2
D=0.5*D;

clear i j;