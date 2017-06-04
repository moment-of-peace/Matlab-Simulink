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

freq_shift = 2;
data1_shift2 = circshift(data1_shift,freq_shift);

data1_ifft = ifft(data1_shift2);     % ifft
pre = data1_ifft(end-7:end);
data1_pre = [pre data1_ifft];

t = 0:1/fs:(length(data1_pre)-1)/fs;

signal_cut = data1_pre(9:end);
signal_fft = fft(signal_cut);
signal_shift = fftshift(signal_fft);
plot(abs(signal_shift));
pause

a = xcorr(data1_pad,signal_shift);
[m,index] = max(a);

shift = length(data1_pad) - index;
signal_recover = circshift(signal_shift,0-shift);
plot(abs(signal_recover));
pause

signal_fix = signal_recover(7:end-6);
signal_dem1 = pskdemod(signal_fix,4);

display((data1==signal_dem1));