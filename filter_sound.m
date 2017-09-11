clear all;
[original_audio, Fs, nbits] = wavread('C:\Users\AASHISH\Desktop\sound_test5.wav');
%----------------------------------------------------------------------------
x = original_audio; 
h = fir1(5,2/32);
y = filtfilt(h',1,x);
wavplay(y,Fs);