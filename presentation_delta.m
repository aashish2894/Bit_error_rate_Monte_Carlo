clear all;
correct_input = 0;
while correct_input == 0
    fprintf('Select the appropriate quantizer\n');
    fprintf('Press 1 for DPCM and 2 for delta modulation\n');
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
fprintf('Enter the Value of Eb.');
Eb_input = input(' ');
fprintf('Enter the Value of No.');
No_input = input(' ');

%--------------------------Read the audio file-------------------------------
[original_audio, Fs, nbits] = wavread('sound_test6.wav');
%----------------------------------------------------------------------------
x = original_audio(1:100000);  % Copy the original audio in x. From here on all the operation would be performed on x
jammer_energy_actual = 8;
Tb = 1/(64*1000);
jammer_energy = jammer_energy_actual/2;
jammer_power = jammer_energy_actual/Tb;
%----------------------------------------------------------------------------
if type_quant == 1
    % enter the code for dpcm
    fprintf('Enter the order of prediciton for DPCM')
    tap=input(' ');
    fprintf('Enter the quantisation bits...(less than or equal to 8)')
    Q=input(' ');
    [input_bit_stream,a]=DPCM_encode(x, Q, tap);
    Eb_by_No = [1/4,1/2,1,2,5,10];
    Eb = [1,1,1,4,10,100];
    No = [4,2,1,2,2,10];
    Pe = zeros(1,length(Eb));
    mean_square_error = zeros(1,length(Eb));
    for i_Eb = 1:1
        E = Eb_input;
        N = No_input;
        if type_mod == 1
            [output_bit_stream,Pe(i_Eb)] = BPSK( input_bit_stream ,E,N,type_jammer,jammer_energy);
        elseif type_mod == 2
            [output_bit_stream,Pe(i_Eb)] = BFSK( input_bit_stream,E,N,type_jammer,jammer_energy );
        elseif type_mod == 3
            [output_bit_stream,Pe(i_Eb)] = QPSK( input_bit_stream,E,N,type_jammer,jammer_energy );
        elseif type_mod == 4
            [output_bit_stream,Pe(i_Eb)] = DPSK( input_bit_stream ,E,N,type_jammer,jammer_energy);
        elseif type_mod == 5
            [output_bit_stream,Pe(i_Eb)] = DSBPSK_2( input_bit_stream ,E,N,type_jammer,jammer_energy);
        else
            fprintf('Incorrect value\n');
        end
        %enter the code for inverse dpcm
        x_dpcm_receive=DPCM_decode( output_bit_stream, Q, tap,a);
        %--------------------Mean Square Error--------------------------------------
        % if lpf is used replace x_demod with y
        for i = 1:length(x_dpcm_receive)
            mean_square_error(i_Eb) = mean_square_error(i_Eb) + (x(i)-x_dpcm_receive(i))^2;
        end
        mean_square_error(i_Eb) = mean_square_error(i_Eb)/length(x);
    %---------------------------------------------------------------------------
        wavplay(x_dpcm_receive,Fs);
    end 
%----------------------------------------------------------------------------  
else
%--------------- Adaptive delta modulation ----------------------------------
    delta_quant_error = 0;
    delta_min = 1/4;  % change it to some other value
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
        delta_quant_error = (x(i) - x_predicted - mq(i)*delta)^2;
        x_predicted = x_predicted + mq(i)*delta;
%         if delta < delta_min
%             delta = delta_min;
%         else
%             delta = delta*(mq(i) + 0.5*mq(i-1))/mq(i);
%         end
    end
    delta_quant_error = delta_quant_error/length(x)
%-------------------Tyype of modulation-------------------------------------
    Eb_by_No = [1/4,1/2,1,2,5,10];
    Eb = [1,1,1,4,10,100];
    No = [4,2,1,2,2,10];
    Pe = zeros(1,length(Eb));
    mean_square_error = zeros(1,length(Eb));
    for i_Eb = 1:1
        E = Eb_input;
        N = No_input;
        if type_mod == 1
            [mq_recovered,Pe(i_Eb)] = BPSK_delta( mq,E,N,type_jammer,jammer_energy);
        elseif type_mod == 2
            [mq_recovered,Pe(i_Eb)] = BFSK_delta( mq,E,N,type_jammer,jammer_energy);
        elseif type_mod == 3
            [mq_recovered,Pe(i_Eb)] = QPSK_delta( mq,E,N,type_jammer,jammer_energy);
        elseif type_mod == 4
            [mq_recovered,Pe(i_Eb)] = DPSK_delta( mq,E,N,type_jammer,jammer_energy);
        elseif type_mod == 5
            [mq_recovered,Pe(i_Eb)] = DSBPSK_delta_2( mq,E,N,type_jammer,jammer_energy);
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
%             if delta < delta_min
%                 delta = delta_min;
%             else
%                 delta = delta*(mq_recovered(k) + 0.5*mq_recovered(k-1))/mq_recovered(k);
%             end
        end
%---------------- Optional Low Pass filter ---------------------------------  
        lpf_filter = fir1(40,3/32);
        y = filtfilt(lpf_filter',1,x_demod);
%--------------------Mean Square Error--------------------------------------
        
        % if lpf is used replace x_demod with y
        for i = 1:length(x_demod)
            mean_square_error(i_Eb) = mean_square_error(i_Eb) + (x(i)-y(i))^2;
        end
        mean_square_error(i_Eb) = mean_square_error(i_Eb)/length(x);
%---------------------------------------------------------------------------
        wavplay(y,Fs);
        % calculate Bandwith and store it in array bandwidth
        % claculate SNR and store it in array SNR
    end
end
p = 2;
c=xcorr(x, p, 'unbiased');
signal_variance = c(3)