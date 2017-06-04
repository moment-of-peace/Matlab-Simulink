function values = group( in, bits, M )
%   group bits in the input sequence
%   the length of raw sequence must be an integer multiple of bits
%   if the input is binary, M should be 2, if hex, M is 16, and so on
    len = floor(length(in)/bits)*bits;
    raw = in(1:len);
    values = raw(1:bits:length(raw));
    for index = 1:bits-1
        values = values .* M + raw(1+index:bits:length(raw));
    end
    
    if len < length(in)
        r = in(len+1:end);
        rx = 0;
        for index = 1:length(r)
            rx = rx*M + r(index);
        end
        values = [values, rx];
    end
end
