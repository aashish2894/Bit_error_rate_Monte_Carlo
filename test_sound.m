clear all;
rec = audiorecorder(64000,16,1);
disp('Start Speaking');
recordblocking(rec,10);
disp('End of recording');
play(rec);
myrecord = getaudiodata(rec);
wavwrite(myrecord,64000,16,'sound_test6.wav');