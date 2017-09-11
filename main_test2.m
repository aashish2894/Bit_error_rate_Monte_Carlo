clear all;
correct_input= 0;
while correct_input == 0
    fprintf('Select the appropriate quantizer\n');
    fprintf('Press 1 for DPCM and 2 for adaptive delta modulation\n');
    type_quant = input(' ');
    if type_quant == 1 || type_quant == 2
        correct_input = 1;
    else
        fprintf('Incorrect Value. Enter Again\n');
    end
end
correct_input = 0;
while correct_input == 0
    fprintf('Select the appropriate modulation type\n');
    fprintf('Press 1 for BPSK, 2 for BFSK, 3 for QPSK, 4 for DPSK, 5 for Direct Sequence Spread Coherent BPSK\n');
    type_mod = input(' ');
    if type_mod == 1 || type_mod == 2 || type_mod == 3 || type_mod == 4 || type_mod == 5
        correct_input = 1;
    else
        fprintf('Incorrect Value. Enter Again\n');
    end
end
correct_input = 0;
while correct_input == 0
    fprintf('Do want to activate the jammer\n');
    fprintf('Press 1 if Yes and 0 if No\n');
    type_jammer = input(' ');
    if type_jammer == 1 || type_jammer == 0
        correct_input = 1;
    else
        fprintf('Incorrect Value. Enter Again\n');
    end
end
%--------------------------Read the audio file-------------------------------
[original_audio, Fs, nbits] = wavread('C:\Users\AASHISH\Desktop\abc.wav');
%----------------------------------------------------------------------------
x = original_audio;  % Copy the original audio in x. From here on all the operation would be performed on x
%----------------------------------------------------------------------------
if type_quant == 1
    % enter the code for dpcm
    Eb_by_No = [1/4,1/2,1,2,5,10];
    Eb = [1,1,1,4,10,100];
    No = [4,2,1,2,2,10];
    Pe = zeros(1,length(Eb));
    for i_Eb = 1:length(Eb)
        E = Eb(i_Eb);
        N = No(i_Eb);
        if type_mod == 1
            [~,Pe(i_Eb)] = BPSK( input_bit_stream ,E,N,type_jammer);
        elseif type_mod == 2
            [~,Pe(i_Eb)] = BFSK( input_bit_stream,E,N,type_jammer );
        elseif type_mod == 3
            [~,Pe(i_Eb)] = QPSK( input_bit_stream,E,N,type_jammer );
        elseif type_mod == 4
            [~,Pe(i_Eb)] = DPSK( input_bit_stream ,E,N,type_jammer);
        elseif type_mod == 5
            [~,Pe(i_Eb)] = DSBPSK( input_bit_stream ,E,N,type_jammer);
        else
            fprintf('Incorrect value\n');
        end
    end
    %enter the code for inverse dpcm
%----------------------------------------------------------------------------  
else
%--------------- Adaptive delta modulation ----------------------------------
    delta_min = 1/8;  % change it to some other value
    delta = 0;
    mq = zeros(1,length(x)); % mq are the quantized values 1,-1
    if x(1)>delta
        mq(1) = 1;
    else
        mq(1) = -1;
    end
    delta = delta_min;
    x_test = zeros(1,length(x));
    x_predicted = mq(1)*delta_min;
    x_test(1) = x_predicted;
    for i = 2:length(x)
        if x(i)> x_predicted
            mq(i) = 1;
        else
            mq(i) = -1;
        end
        x_predicted = x_predicted + mq(i)*delta;
        x_test(i) = x_predicted;
        if delta < delta_min
            delta = delta_min;
        else
            delta = delta*(mq(i) + 0.5*mq(i-1))/mq(i);
        end
    end
%-------------------Tyype of modulation-------------------------------------
    Eb_by_No = [1/4,1/2,1,2,5,10];
    Eb = [1,1,1,4,10,100];
    No = [4,2,1,2,2,10];
    Pe = zeros(1,length(Eb));
    mean_square_error = zeros(1,length(Eb));
    for i_Eb = 1:1
        E = 1000;
        N = No(i_Eb);
        if type_mod == 1
            [mq_recovered,Pe(i_Eb)] = BPSK_delta( mq,E,N,type_jammer);
        elseif type_mod == 2
            [mq_recovered,Pe(i_Eb)] = BFSK_delta( mq,E,N,type_jammer);
        elseif type_mod == 3
            [mq_recovered,Pe(i_Eb)] = QPSK_delta( mq,E,N,type_jammer);
        elseif type_mod == 4
            [mq_recovered,Pe(i_Eb)] = DPSK_delta( mq,E,N,type_jammer);
        elseif type_mod == 5
            [mq_recovered,Pe(i_Eb)] = DSBPSK_delta( mq,E,N,type_jammer);
        else
            fprintf('Incorrect value\n');
        end
%-------------------inverse delta modulation -------------------------------
        x_demod = zeros(1,length(mq));  % this is the final recovered value. Pass it through a low pass filter
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
%---------------- Optional Low Pass filter ---------------------------------  
        y = zeros(1,length(x));
        y(1) = x_demod(1);
        y(2) = x_demod(2);
        for i = 3:length(x)
            y(i) = (x_demod(i) + x_demod(i-1) + x_demod(i-2))/3;
        end
%--------------------Mean Square Error--------------------------------------
        
        % if lpf is used replace x_demod with y
        for i = 1:length(y)
            mean_square_error(i_Eb) = mean_square_error(i_Eb) + (x(i)-y(i))^2;
        end
        mean_square_error(i_Eb) = mean_square_error(i_Eb)/length(x);
%---------------------------------------------------------------------------
    end
%     figure(1);
%     plot(x);
%     figure(2);
%     plot(x_demod);
%     figure(3);
%     plot(x_test);
%     figure(4);
%     plot(y);
    figure(1);
    plot(Eb_by_No,Pe);
end