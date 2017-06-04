function position = synch( cor, len )
%implement synchronization
%   cor is the correlation result, len is the raw signal length
position = [];
for index = 1:len
   if cor(index)>70 && cor(index)>cor(index-1) && cor(index)>cor(index+1)
       position = [(len-index) position];
   end
end

end

