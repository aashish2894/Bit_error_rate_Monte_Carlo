function [ trans_sig,a ] = DPCM_encode(y, Q, tap )

N= length(y);
trans_sig=zeros(1,N*Q);
predic_sig=0;
pred_reg=zeros(1,tap);
a=pred_func(tap,y); %prediction filter coeff calculator

quantization_error = 0;
% ERR=zeros(1,N);
for i=1:N
    inbuf=y(i);
    err=inbuf-predic_sig;

    %quantiser
    
    temp=(err+1)/2; %shifted err so that all values are positive 
    
    if temp>=1
        temp=1;
    elseif (temp)<=0
        temp=0;
    end 
    
    temp=floor(temp*(2^Q))-2^(Q-1); %quantised signal in binary

    qnt_err=temp/2^(Q-1); 
    quantization_error = (qnt_err - err)^2 + quantization_error;
    %predictor        
    new_in=predic_sig+qnt_err;    
    pred_reg=[pred_reg(2:tap),new_in];
    predic_sig=sum((a').*pred_reg);
    
    %converting to binary values
    trans_sig_bin=de2bi(abs(int8(temp)),Q);
    if temp<0
        trans_sig_bin(Q)=1;
    end         
    
    trans_sig((i-1)*Q+1:i*Q)=trans_sig_bin;% bit stream
    
   
end
quantization_error = quantization_error/length(y)


