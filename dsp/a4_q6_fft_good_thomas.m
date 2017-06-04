% Good-Thomas (Prime Factor) algorithm to perform the FFT
clear;
N = 35;     % length of dft
L = 5;      % rows of reshaped array
M = 7;      % columns of reshaped array

% here L1*L + M1*M = 1
[g,L1,M1] = gcd(5,7);
array = rand(N,1);
array2 = zeros(L,M);

% 
for m = 0:L-1
    for n = 0:M-1
        array2(m+1,n+1) = array(mod(m*M*M1+n*L*L1,N)+1);
    end
end
dft1 = zeros(L,M);
for y = 0:M-1
    for x = 0:L-1
        for n = 0:L-1
            dft1(x+1,y+1) = dft1(x+1,y+1) + array2(n+1,y+1) * exp(-1i*2*pi*x*n/L);
        end
    end
end
dft2 = zeros(L,M);
for x = 0:L-1
    for y = 0:M-1
        for n = 0:M-1
            dft2(x+1,y+1) = dft2(x+1,y+1) + dft1(x+1,n+1) * exp(-1i*2*pi*y*n/M);
        end
    end
end
dft_good = zeros(N,1);
for k1 = 0:L-1
    for k2 = 0:M-1
        dft_good(mod(k1*M+k2*L,N)+1) = dft2(k1+1,k2+1);
    end
end
dft_theoretical = fft(array);