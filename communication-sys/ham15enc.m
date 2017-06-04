function out = ham15enc( input )
%[15,11] hamming encoder
%   input should be binary and the length should be a multiple of 11
in = zeros(1, ceil(length(input)/11)*11);
in(1:length(input)) = input;
out = zeros(1, 15*length(in)/11);

for index = 0:length(in)/11-1
    for x = 1:11
        out(index*15+x) = in(index*11+x);
    end
   out(index*15+12) = mod(in(index*11+1)+in(index*11+2)+in(index*11+3)+in(index*11+5)+in(index*11+6)+in(index*11+10)+in(index*11+11),2);
   out(index*15+13) = mod(in(index*11+1)+in(index*11+2)+in(index*11+4)+in(index*11+5)+in(index*11+7)+in(index*11+8)+in(index*11+11),2);
   out(index*15+14) = mod(in(index*11+1)+in(index*11+3)+in(index*11+4)+in(index*11+6)+in(index*11+8)+in(index*11+9)+in(index*11+11),2);
   out(index*15+15) = mod(in(index*11+2)+in(index*11+3)+in(index*11+4)+in(index*11+7)+in(index*11+9)+in(index*11+10)+in(index*11+11),2);
end

end