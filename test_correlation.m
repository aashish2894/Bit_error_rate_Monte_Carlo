clear all;
[original_audio, Fs, nbits] = wavread('sound_test1.wav');
%----------------------------------------------------------------------------
x = original_audio;
p = 10;
x_corr = xcorr(x,p,'unbiased');
x_corr = x_corr(p+1:2*p+1);
x_rhs = x_corr(2:p+1);
%x_rhs = x_rhs';
%x_matrix = [x_corr(1) x_corr(2) x_corr(3) x_corr(4); x_corr(2) x_corr(1) x_corr(2) x_corr(3); x_corr(3) x_corr(2) x_corr(1) x_corr(2); x_corr(4) x_corr(
x_matrix = zeros(p,p);
for i = 1:p
    for j = 1:p
        x_matrix(i,j) = x_corr(abs(i-j)+1);
    end
end
a_matrix = inv(x_matrix)*x_rhs;