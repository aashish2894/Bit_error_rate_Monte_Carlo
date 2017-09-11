clear all;
%----- load the audio file --------------------
% take input in the variable original_audio
%Fs [y, Fs, nbits] = wavread('C:\Users\AASHISH\Desktop\sound.wav');
%nbits
%[original_audio, Fs, nbits] = wavread('C:\Users\AASHISH\Desktop\abc.wav');
%----------------------------------------------


%-----DPCM (delta modulator)------------------
n = (1:500);
x = 127*sin(2*pi*100*n/40000);
x_quant = zeros(1,length(x));
x_quant(1) = floor(x(1));
x_predicted  = x_quant(1);
for i = 2:length(x)
     x_in_to_quant = x(i) - x_predicted;
     x_quant(i) = floor(x_in_to_quant);
     x_predicted = x_quant(i) + x_predicted;
end
%---- x_quant stores the output of DPCM---------
%----------- BPSK-------------------------------
Eb_by_No = [1/4,1/2,1,2,5,10];
Eb = [1,1,1,4,10,100];
No = [4,2,1,2,2,10];
Pe = zeros(1,length(Eb));
x_bin = zeros(length(x_quant),8);
x_reconstructed = zeros(1,length(x_quant));
decoded = zeros(1,8);
incorrect = 0;
for i = 1:length(x_quant)
    x_bin(i,:) = de2bi(abs(x_quant(i)),8);
    if x_quant(i)<0
        x_bin(i,8) = 1;
    end
end
for i = 1:1
    E = 100;
    N = 1;
    noise = N*randn(length(x_quant)*8,1);
    incorrect = 0;
    for j = 1:length(x_quant)
        for k = 1:8
            if x_bin(j,k)>0
                received_bit = E + noise(j);
                if received_bit>0
                    decoded(k) = 1;
                else
                    decoded(k) = 0;
                    incorrect = incorrect + 1;
                end
            else
                received_bit = -E + noise(j);
                if received_bit>0
                    decoded(k) = 1;
                    incorrect = incorrect + 1;
                else
                    decoded(k) = 0;
                end
            end
        end
        if decoded(8)>0
            x_reconstructed(j) = -1*bi2de(decoded(1:7));
        else
            x_reconstructed(j) = bi2de(decoded(1:7));
        end
    end
    %--------------- DPCM decoder------------------
    x_decode_predicted = 0;
    x_received = zeros(1,length(x_quant));
    x_received(1) = x_decode_predicted + x_reconstructed(1);
    x_decode_predicted = x_received(1);
    for l = 2:length(x_quant)
        x_received(l) = x_reconstructed(l) + x_decode_predicted;
        x_decode_predicted = x_received(l);
    end
    Pe(i) = incorrect/(length(x_quant)*8);
end
figure(1);
plot(x);
figure(2);
plot(x_received);
%wavplay(x,Fs);
%plot(Eb_by_No,Pe);
