function [ demod,BER ] = BFSK( input_bit_stream,Eb,No,jammer_flag,jammer_energy )
%% BFSK modulation
a = sqrt(Eb);
output = zeros(2,length(input_bit_stream));
noise = sqrt(No/2)*randn(2,length(input_bit_stream));
for i = 1:length(input_bit_stream)
    if input_bit_stream(i) == 0
        output(1,i) = a;
    else
        output(2,i) = a;
    end
end
%% Simulate AWGN Channel
jammer = Jammer(jammer_flag,length(input_bit_stream),jammer_energy);
jammer_zero = zeros(1,length(jammer));
noisy_output = output + noise + [jammer;jammer_zero];
%% Demodulation
incorrect = 0;
demod = zeros(1,length(input_bit_stream));
for i = 1:length(noisy_output)
    if noisy_output(1,i) <= noisy_output(2,i)
        demod(i) = 1;
    end
    if demod(i) ~= input_bit_stream(i)
        incorrect = incorrect + 1;
    end
end
BER = (incorrect)/length(input_bit_stream);
end

