function out = ham15dec( in )
% [15,11] hamming decoder
%  the input should be binary, and the should be a multiple of 15 
out = zeros(1, 11*floor(length(in)/15));
p = zeros(1,4);
 
for index = 0:length(in)/15-1
    for x = 1:11
        out(index*11+x) = in(index*15+x);
    end
   % calculate parity
   p(1) = in(index*15+1)+in(index*15+2)+in(index*15+3)+in(index*15+5)+in(index*15+6)+in(index*15+10)+in(index*15+11)+in(index*15+12);
   p(2) = in(index*15+1)+in(index*15+2)+in(index*15+4)+in(index*15+5)+in(index*15+7)+in(index*15+8)+in(index*15+11)+in(index*15+13);
   p(3) = in(index*15+1)+in(index*15+3)+in(index*15+4)+in(index*15+6)+in(index*15+8)+in(index*15+9)+in(index*15+11)+in(index*15+14);
   p(4) = in(index*15+2)+in(index*15+3)+in(index*15+4)+in(index*15+7)+in(index*15+9)+in(index*15+10)+in(index*15+11)+in(index*15+15);
   px = mod(p(1),2)*8 + mod(p(2),2)*4 + mod(p(3),2)*2 + mod(p(4),2);
   % correct single error
   switch px
       case 14 
           out(index*11+1) = 1- out(index*11+1);
       case 13 
           out(index*11+2) = 1- out(index*11+2);
       case 11 
           out(index*11+3) = 1- out(index*11+3);
       case 7 
           out(index*11+4) = 1- out(index*11+4);
       case 12 
           out(index*11+5) = 1- out(index*11+5);
        case 10 
           out(index*11+6) = 1- out(index*11+6);
       case 5 
           out(index*11+7) = 1- out(index*11+7);
       case 6 
           out(index*11+8) = 1- out(index*11+8);
       case 3 
           out(index*11+9) = 1- out(index*11+9);
       case 9 
           out(index*11+10) = 1- out(index*11+10);
       case 15 
           out(index*11+11) = 1- out(index*11+11);
   end
   
end
 
end
