function values = group_up( in, bits, M )
%   group bits in the input sequence
%   the length of raw sequence must be an integer multiple of bits
%   if the input is binary, M should be 2, if hex, M is 16, and so on
    raw = zeros(1,ceil(length(in)/bits)*bits);
    raw(1:length(in)) = in;
    values = raw(1:bits:length(raw));
    for index = 1:bits-1
        values = values .* M + raw(1+index:bits:length(raw));
    end
end
