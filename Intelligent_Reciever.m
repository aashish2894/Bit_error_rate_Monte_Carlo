clear all;
%% Aquiring Audio
[original_audio, Fs, nbits] = wavread('sound_test1.wav');
x = original_audio(1:100000);  % Copy the original audio in x
%% Define Parameters
Eb = 10;
No = 2;
Tb = 1/(64*1000);
jammer_energy_actual = 12;
jammer_energy = jammer_energy_actual/2;
jammer_power = jammer_energy_actual/Tb;
%% Performing DPCM
Q = 8;
tap = 1;
[bit_stream,a] = DPCM_encode(x,Q,tap);
%% Adding an Initial PN Sequence for Initial Handshaking
PN_sequence = PN_sequence_gen(); %% Generate PN sequence of length 31
%% Jammer addition
jammer_flag = input('Do you want to add the jammer?(1 for Yes 0 for No) : ');
%% Initialising Handshake through a BPSK Transmission
handshake_input = [];
for k = 1:6
    handshake_input = [handshake_input,PN_sequence];
end
[handshake_output,~] = BPSK( handshake_input ,Eb,No,jammer_flag,jammer_energy);
correct = 0;
for i = 1:length(handshake_input)
    if handshake_output(i) == handshake_input(i)
        correct = correct + 1;
    end
end
if correct > 170
    fprintf('No jammer present. Using BPSK.\n');
    [demod_output,~] = BPSK( bit_stream ,Eb,No,jammer_flag,jammer_energy);
else
    fprintf('Jammer Detected! Switch to DS based Modulation scheme!\n');
    [demod_output,Pe] = DSBPSK_2( bit_stream ,Eb,No,jammer_flag,jammer_energy);
end
x_dpcm_receive=DPCM_decode( demod_output, Q, tap,a);
wavplay(x_dpcm_receive,Fs);