function [ demod,BER ] = DSBPSK_delta( input_bit_stream ,Eb,No,jammer_flag,jammer_energy)
%% BPSK modulation
a = sqrt(Eb);
Tb = 1/(8*1000);
Tc = Tb/31;
PN_sequence = PN_sequence_gen();
bipolar_PN = (PN_sequence - 0.5)*2;
output = zeros(1,31*length(input_bit_stream));
noise = sqrt(Tc/Tb)*sqrt(No/2)*randn(1,31*length(input_bit_stream));
%% Spectrum Spreading by Multiplying a PN Sequence and Modulation
for i = 1:length(input_bit_stream)
    if input_bit_stream(i) == -1
        output((i-1)*31+1:i*31) = -(a/sqrt(31))*bipolar_PN;
    else
        output((i-1)*31+1:i*31) =  (a/sqrt(31))*bipolar_PN;
    end
end
%% Simulate AWGN Channel
jammer = Jammer(jammer_flag,31*length(input_bit_stream),jammer_energy);
noisy_output = output/sqrt(31) + noise + jammer*Tc/Tb; % jk = sqrt(E)*sqrt(Tc/Tb);
%% Demodulation
% Multiplication my PN_sequence
incorrect = 0;
demod = zeros(1,length(input_bit_stream));
for i = 1:length(input_bit_stream)
    temp_demod = noisy_output((i-1)*31+1:i*31).*bipolar_PN;
    sum_temp = sum(temp_demod);
    %count = length(find(temp_demod>0));
    if sum_temp>=0
        demod(i) = 1;
    else
        demod(i) = -1;
    end
    if demod(i) ~= input_bit_stream(i)
        incorrect = incorrect + 1;
    end
end
BER = (incorrect)/length(input_bit_stream);
end

