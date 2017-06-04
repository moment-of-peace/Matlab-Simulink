function out = ham7dec( in )
% [7,4] hamming decoder
%  the input should be binary, and the should be a multiple of 7 
out = zeros(1, 4*floor(length(in)/7));
p = zeros(1,3);

for index = 0:length(in)/7-1
   out(index*4+1) = in(index*7+1);
   out(index*4+2) = in(index*7+2);
   out(index*4+3) = in(index*7+3);
   out(index*4+4) = in(index*7+4);
   % calculate parity
   p(1) = in(index*7+1)+in(index*7+3)+in(index*7+4)+in(index*7+5);
   p(2) = in(index*7+1)+in(index*7+2)+in(index*7+4)+in(index*7+6);
   p(3) = in(index*7+2)+in(index*7+3)+in(index*7+4)+in(index*7+7);
   px = mod(p(1),2)*4 + mod(p(2),2)*2 + mod(p(3),2);
   % correct single error
   switch px
       case 6 
           out(index*4+1) = 1- out(index*4+1);
       case 3 
           out(index*4+2) = 1- out(index*4+2);
       case 5 
           out(index*4+3) = 1- out(index*4+3);
       case 7 
           out(index*4+4) = 1- out(index*4+4);
   end
   
end

end

