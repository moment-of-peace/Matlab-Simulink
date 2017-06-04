% simulate an OFDM system
clear;
fs = 2e6;
sc = 52; % number of sub carriers

data1 = randi([0,3],1,52);
data1(1) = 0;   % pilots
data1(18) = 1;
data1(35) = 2;
data1(52) = 3;

zero = zeros(1,6);
data1_mod = pskmod(data1,4); % qpsk demod
data1_pad = [zero data1_mod zero];  % pad zeros
data1_shift = fftshift(data1_pad);  % fft shift

data1_ifft = ifft(data1_shift);     % ifft
pre = data1_ifft(end-7:end);
data1_pre = [pre data1_ifft];

t = 0:1/fs:(length(data1_pre)-1)/fs;
plot(t,real(data1_pre));
hold on
plot(t,imag(data1_pre));
hold off
pause

[fxx1,f1] = pwelch(data1_pre,[],[],[],fs);
plot(f1-(mean(f1)),fftshift(10*log10(fxx1)));