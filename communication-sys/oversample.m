function [ out ] = oversample( in, n )
%oversample.m, used to oversample the input vector
    out = zeros(1, n*length(in));
    for x = 1: length(in)
        for y = 1: n
            out(n*(x-1)+y) = in(x);
        end
    end
end

