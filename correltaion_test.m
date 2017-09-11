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
Rx = zeros(1,5);
for i = 1:length(Rx)
    for j = 1:length(x)-(i-1)
        Rx(i) = Rx(i) + x(j)*x(j+i-1);
    end
end
Rx = Rx/Rx(1);
x10_orig = x(10);
x10_pred = Rx(1)*x(10) + Rx(2)*x(9) + Rx(3)*x(8) + Rx(4)*x(7) + Rx(5)*x(6);