clear all;
%----- load the audio file --------------------
% take input in the variable original_audio
%Fs [y, Fs, nbits] = wavread('C:\Users\AASHISH\Desktop\sound.wav');
%nbits
[original_audio, Fs, nbits] = wavread('C:\Users\AASHISH\Desktop\abc.wav');
%----------------------------------------------------------------------------
x = original_audio;
delta_min = 1/8;  % change it to some other value
delta = 0;
mq = zeros(1,length(x)); % mq are the quantized values 1,-1
if x(1)>delta
    mq(1) = 1;
else
    mq(1) = -1;
end
delta = delta_min;
x_predicted = mq(1)*delta_min;
for i = 2:length(x)
    if x(i)> x_predicted
        mq(i) = 1;
    else
        mq(i) = -1;
    end
    x_predicted = x_predicted + mq(i)*delta;
    if delta < delta_min
        delta = delta_min;
    else
        delta = delta*(mq(i) + 0.5*mq(i-1))/mq(i);
    end
end
%--------- Demodulator -----------------------
Eb_by_No = [1/4,1/2,1,2,5,10];
Eb = [1,1,1,4,10,100];
No = [4,2,1,2,2,10];
Pe = zeros(1,length(Eb));
x_demod = zeros(1,length(mq));
mq_recovered = zeros(1,length(mq));
for i = 1:1
    E = 100;
    N = No(i);
    noise = N*randn(length(mq),1);
    incorrect = 0;
    for j = 1:length(mq)
        if mq(j)>0
            received_bit = E + noise(j);
            if received_bit>0
                decoded = 1;
            else
                decoded = -1;
                incorrect = incorrect + 1;
            end
        else
            received_bit = -E + noise(j);
            if received_bit>0
                decoded = 1;
                incorrect = incorrect + 1;
            else
                decoded = -1;
            end
        end
        mq_recovered(j) = decoded; 
    end
    x_demod(1) = mq_recovered(1)*delta_min;
    delta = delta_min;
    x_predicted = x_demod(1);
    for k = 2:length(mq)
        x_demod(k) = x_demod(k-1) + mq_recovered(k)*delta;
        if delta < delta_min
            delta = delta_min;
        else
            delta = delta*(mq_recovered(k) + 0.5*mq_recovered(k-1))/mq_recovered(k);
        end
    end
    Pe(i) = incorrect/(length(mq));
end
figure(1);
plot(x);
figure(2);
plot(x_demod);