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