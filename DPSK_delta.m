function [ demod,BER ] = DPSK_delta( input_bit_stream ,Eb,No,jammer_flag,jammer_energy)
%% BPSK modulation
a = sqrt(Eb);
output = zeros(1,length(input_bit_stream));
noise = sqrt(No/2)*randn(1,length(input_bit_stream));
output(1,1) = a;
for i = 2:length(input_bit_stream)
    if input_bit_stream(i) == -1
        output(i) = output(i-1);
    else
        output(i) = -output(i-1);
    end
end
%% Simulate AWGN Channel
jammer = Jammer(jammer_flag,length(input_bit_stream),jammer_energy);
noisy_output = output + noise + jammer;
%% Demodulation
incorrect = 0;
demod = zeros(1,length(input_bit_stream));
demod(1) = input_bit_stream(1);
for i = 2:length(noisy_output)
    if (noisy_output(i-1) >= 0 && noisy_output(i) < 0) || (noisy_output(i-1) < 0 && noisy_output(i) >= 0)
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

