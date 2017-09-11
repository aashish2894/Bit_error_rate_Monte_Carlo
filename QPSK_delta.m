function [ demod,BER ] = QPSK_delta( input_bit_stream,Eb,No,jammer_flag,jammer_energy)
a = sqrt(Eb/2);
%% QPSK modulation
output = zeros(2,length(input_bit_stream));
noise = sqrt(No/2)*randn(2,length(input_bit_stream));
for i = 1:2:length(input_bit_stream)
    if input_bit_stream(i) == -1 && input_bit_stream(i+1) == -1
        output(1,i) = -a;
        output(2,i) = -a;   
    end
    if input_bit_stream(i) == -1 && input_bit_stream(i+1) == 1
        output(1,i) = -a;
        output(2,i) =  a;   
    end
    if input_bit_stream(i) == 1 && input_bit_stream(i+1) == 1
        output(1,i) =  a;
        output(2,i) =  a;   
    end
    if input_bit_stream(i) == 1 && input_bit_stream(i+1) == -1
        output(1,i) =  a;
        output(2,i) = -a;   
    end
end
%% Simulate AWGN Channel
jammer = Jammer(jammer_flag,length(input_bit_stream),jammer_energy);
jammer_odd = zeros(1,length(input_bit_stream));
jammer_even = zeros(1,length(input_bit_stream));
for i = 1:2:length(input_bit_stream)
    jammer_odd(i) = jammer(i);
    jammer_even(i) = jammer(i+1);
end
noisy_output = output + noise + [jammer_odd;jammer_even];
%% Demodulation
incorrect = 0;
demod = zeros(1,length(input_bit_stream));
for i = 1:2:length(noisy_output)
    if noisy_output(1,i) <= 0 && noisy_output(2,i) <= 0
        demod(i) = -1;
        demod(i+1) = -1;
    end
    if noisy_output(1,i) < 0 && noisy_output(2,i) > 0
        demod(i) = -1;
        demod(i+1) = 1;
    end
    if noisy_output(1,i) > 0 && noisy_output(2,i) > 0
        demod(i) = 1;
        demod(i+1) = 1;
    end
    if noisy_output(1,i) > 0 && noisy_output(2,i) < 0
        demod(i) = 1;
        demod(i+1) = -1;
    end
    if demod(i) ~= input_bit_stream(i) || demod(i+1) ~= input_bit_stream(i+1)
        incorrect = incorrect + 1;
    end
    if demod(i) ~= input_bit_stream(i) && demod(i+1) ~= input_bit_stream(i+1)
        incorrect = incorrect + 1;
    end
end
BER = (incorrect)/length(input_bit_stream);
end