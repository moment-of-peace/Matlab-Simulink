function out = rmzeros( in )
% remove zeros at beginning and end
%   in is a vector
start = 1;
ending = length(in);
for index = 1:length(in)
   if in(index) ~= 0
      start = index;
      break;
   end
end

for index = length(in):-1:1
   if in(index) ~= 0
      ending = index;
      break;
   end
end
out = in(start:ending);

end

