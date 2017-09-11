function [ w ] = DPCM_decode( bin_seq, Q, tap,a)
%---------decode------------------
n=length(bin_seq);
N=n/Q;
rec_sig=zeros(N,Q);
for i=1:N
    rec_sig(i,:)=bin_seq((i-1)*Q+1:i*Q);
end
maxi=1;
pred_reg_out=zeros(1,tap);
pred_out=0;
w=zeros(1,N);

%a=pred_func(tap,x); %prediction filter coeff

for i=1:N    
%decodes the error into decimals
if rec_sig(i,Q)==1
    rec_sig(i,Q)=0;
    err_out=-1*bi2de(rec_sig(i,:));
else
    err_out=bi2de(rec_sig(i,:));
end
    
    w(i)=pred_out+(err_out/(2^(Q-1)))*maxi;       
    pred_reg_out=[pred_reg_out(2:tap),w(i)];
    pred_out=sum((a').*pred_reg_out);     
end

%wavwrite(w, 'received_signal_final.wav')
end