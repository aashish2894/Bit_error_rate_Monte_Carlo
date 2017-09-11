function [jammer] = Jammer(flag,N,energy)
jammer = zeros(1,N);
%Fs = 8000;
if flag == 1
    for i = 1:N
      jammer(i) = sqrt(energy);
    end
end
%jammer = sqrt(energy/2)*jammer;
end

