% perform a 35-point (N=35) Cooley-Tukey FFT
clear;
N = 35;     % length of dft
L = 5;      % rows of reshaped array
M = 7;      % columns of reshaped array

array = rand(N,1);
array2 = reshape(array,L,M);    % arrange array in a matix
dft = zeros(L,M);
dft2 = zeros(L,M);
% apply dft in each row
for x = 0:L-1
    for y = 0:M-1
        for n = 0:M-1
            dft(x+1,y+1) = dft(x+1,y+1) + array2(x+1,n+1) * exp(-1i*2*pi*y*n/M);
        end
        % mutiply by a twiddle factor
        dft(x+1,y+1) = dft(x+1,y+1) * exp(-1i*2*pi*y*x/N);
    end
end
% apply dft in each column
for y = 0:M-1
    for x = 0:L-1
        for n = 0:L-1
            dft2(x+1,y+1) = dft2(x+1,y+1) + dft(n+1,y+1) * exp(-1i*2*pi*x*n/L);
        end
    end
end
dft_cooley = reshape(dft2',35,1);
dft_theoretical = fft(array);