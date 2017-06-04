function out = ham7enc( in )
%[7,4] hamming encoder
%   input should be binary and the length should be a multiple of 4
out = zeros(1, 7*length(in)/4);

for index = 0:length(in)/4-1
   out(index*7+1) = in(index*4+1); 
   out(index*7+2) = in(index*4+2);
   out(index*7+3) = in(index*4+3);
   out(index*7+4) = in(index*4+4);
   out(index*7+5) = mod(in(index*4+1)+in(index*4+3)+in(index*4+4),2);
   out(index*7+6) = mod(in(index*4+1)+in(index*4+2)+in(index*4+4),2);
   out(index*7+7) = mod(in(index*4+2)+in(index*4+3)+in(index*4+4),2);
end

end

