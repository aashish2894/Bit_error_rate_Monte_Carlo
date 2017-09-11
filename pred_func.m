function [ a ] = pred_func(p,y1)
 %y1=wavread('sound_test1.wav');
% y2=wavread('sound_test2.wav');
% y3=wavread('sound_test3.wav');
% y4=wavread('sound_test4.wav');
% y5=wavread('sound_test5.wav');
% y=[y1;y2;y3;y4;y5];
 
% t=1:1000;
% y=sin(2*pi*4*(t/1000));

c=xcorr(y1, p, 'unbiased');
rxx=c((length(c)+1)/2:length(c));
R_x=zeros(p,p);
for i=1:p
    R_x(i,i)=rxx(1);
    for j=i+1:p
            R_x(i,j)=rxx(abs(j-i)+1);
            R_x(j,i)=rxx(abs(j-i)+1);
    end
end

r_x=(rxx(p+1:-1:2));
a=inv(R_x)*r_x ;  %inverse of R_x


% %extra
% for i=p+1:N
%     z(i)=0;
%     for j=1:p
%         z(i)=z(i)+a(j)*y1(i-p-1+j);
%     end
% end
% 
% t=z-y1;
% t1=t(1:floor(N/1000));
% plot(t1)
end

