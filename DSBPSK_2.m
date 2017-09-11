function [ demod,BER ] = DSBPSK_2( input_bit_stream ,Eb,No,jammer_flag,jammer_energy)
%% DSBPSK modulation
a = sqrt(Eb);
Tb = 1/(64*1000);
Tc = Tb/31;
output = zeros(1,length(input_bit_stream));
noise = sqrt(No/2)*randn(1,length(input_bit_stream));
for i = 1:length(input_bit_stream)
    if input_bit_stream(i) == 0
        output(i) = -a;
    else
        output(i) = a;
    end
end
%% Simulate AWGN Channel
jammer = Jammer(jammer_flag,length(input_bit_stream),jammer_energy);
noisy_output = output + noise + jammer*Tc/Tb;
%% Demodulation
incorrect = 0;
demod = zeros(1,length(input_bit_stream));
for i = 1:length(noisy_output)
    if noisy_output(i) >= 0
        demod(i) = 1;
    end
    if demod(i) ~= input_bit_stream(i)
        incorrect = incorrect + 1;
    end
end
BER = (incorrect)/length(input_bit_stream);
end

