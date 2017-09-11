function [ output ] = PN_sequence_gen( )
output = zeros(1,31);
register = ones(1,5);
for i = 1:length(output)
    temp = double(xor(register(2),register(5)));
    output(i) = register(5);
    register(5) = register(4);
    register(4) = register(3);
    register(3) = register(2);
    register(2) = register(1);
    register(1) = temp;
end
end

