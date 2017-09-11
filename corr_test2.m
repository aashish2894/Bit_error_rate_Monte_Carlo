clear all;
%----- load the audio file --------------------
% take input in the variable original_audio
%Fs [y, Fs, nbits] = wavread('C:\Users\AASHISH\Desktop\sound.wav');
%nbits
[original_audio, Fs, nbits] = wavread('C:\Users\AASHISH\Desktop\abc.wav');
%----------------------------------------------
y = original_audio;  % From here on x will be our input function
x = y(1:length(y),1);
% Rx0 = 0;
% for i = 1:length(x)
%     Rx0 = Rx0 + x(i)*x(i);
% end
% Rx1 = 0;
% for i = 1:length(x)-1
%     Rx1 = Rx1 + x(i)*x(i+1);
% end
% Rx2 = 0;
% for i = 1:length(x)-2
%     Rx2 = Rx2 + x(i)*x(i+2);
% end
% Rx15 = 0;
% for i = 1:(length(x)-15)
%     Rx15 = Rx15 + x(i)*x(i+15);
% end
n = 1000;
Rx = zeros(1,length(x)-n);
for j = 1:length(x)-n
    Rx(j) =  x(j)*x(j+n);
end
% minimum = min(Rx);
% maximum = max(Rx);
% range = (maximum-minimum)/10;
% region = zeros(1,10);
% prob_dist = hist(Rx);
% for i = 1:10
%     region(i) = i*range;
% end
% new_var = zeros(1,length(Rx));
% for i = 1:length(x)-n
%     if Rx(i)>=minimum && Rx(i)<minimum + region(1)
%         new_var(i) = Rx(i)*prob_dist(1);
%     elseif Rx(i)>=minimum + region(1) && Rx(i)<minimum + region(2)
%         new_var(i) = Rx(i)*prob_dist(2);
%     elseif Rx(i)>=minimum + region(2) && Rx(i)<minimum + region(3)
%         new_var(i) = Rx(i)*prob_dist(3);
%     elseif Rx(i)>=minimum + region(3) && Rx(i)<minimum + region(4)
%         new_var(i) = Rx(i)*prob_dist(4);
%     elseif Rx(i)>=minimum + region(4) && Rx(i)<minimum + region(5)
%         new_var(i) = Rx(i)*prob_dist(5);
%     elseif Rx(i)>=minimum + region(5) && Rx(i)<minimum + region(6)
%         new_var(i) = Rx(i)*prob_dist(6);
%     elseif Rx(i)>=minimum + region(6) && Rx(i)<minimum + region(7)
%         new_var(i) = Rx(i)*prob_dist(7);
%     elseif Rx(i)>=minimum + region(7) && Rx(i)<minimum + region(8)
%         new_var(i) = Rx(i)*prob_dist(8);
%     elseif Rx(i)>=minimum + region(8) && Rx(i)<minimum + region(9)
%         new_var(i) = Rx(i)*prob_dist(9);
%     elseif Rx(i)>=minimum + region(9) && Rx(i)<minimum + region(10)
%         new_var(i) = Rx(i)*prob_dist(10);
%     end
% end
% S = sum(new_var);
% S2 = sum(prob_dist);
% final_answer = S/S2;
prob_dist = hist(Rx);
minimum = min(Rx);
maximum = max(Rx);
range = (maximum-minimum)/10;
region = zeros(1,10);
prob_dist = hist(Rx);
for i = 1:10
    region(i) = i*range;
end
r = zeros(1,10);
r(1) = (2*minimum + region(1))/2;
r(2) = (2*minimum + region(1) + region(2))/2;
r(3) = (2*minimum + region(2) + region(3))/2;
r(4) = (2*minimum + region(3) + region(4))/2;
r(5) = (2*minimum + region(4) + region(5))/2;
r(6) = (2*minimum + region(5) + region(6))/2;
r(7) = (2*minimum + region(6) + region(7))/2;
r(8) = (2*minimum + region(7) + region(8))/2;
r(9) = (2*minimum + region(8) + region(9))/2;
r(10) = (2*minimum + region(9) + region(10))/2;
sum1 = 0;
for i = 1:10
    sum1 = sum1 + r(i)*prob_dist(i);
end
sum2 = sum(prob_dist);
sum1 = sum1/sum2;