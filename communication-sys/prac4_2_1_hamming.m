% BPSK QPSK demodulation, Hammig decode
clear;
fs = 2e6;

data1x = read_complex_byte('freq2A.bin');
signal = data1x(1:5000);
preamble = [1 0 1 0 1 0 1 1];   % preamble
syn = pskmod(preamble,2);
syn_over = oversample(syn,16);
a = xcorr(syn_over,signal);   % correlation

subplot(211)
plot(abs(a));
subplot(212)
plot(real(signal));
pause

% sync
position = synch(abs(a), length(signal));
signal1x = data1x(position(1):position(1)+943);
train1x = signal1x(129:384);

x = train1x(1:128);
y = train1x(129:256);
shiftxy = mldivide(y,x);
shiftxy = shiftxy/abs(shiftxy);
fshift1x = 2e6*log(shiftxy) / (128*2*pi*1i);

t = 0:1/fs:(length(signal1x)-1)/fs;
len = floor(length(signal1x)/16)*16;
signal1x = signal1x(1:len);
signal1x_fix = signal1x .*exp(1i*2*pi*fshift1x*transpose(t));
plot(signal1x_fix,'.');
pause;

iq1x = intdump(signal1x_fix(129:end),16); % 16 samples per symbol
pshift = atan(-real(iq1x(1))/imag(iq1x(1)));  %phase shift

training = [3 3 0 3 2 2 0 0];
train_mod = pskmod(training, 4, pshift);
h = deconv(iq1x(1:8), train_mod);   % transfer function

iq1x_recover = deconv(iq1x,h);   % recover
sys1x = pskdemod(iq1x_recover,4,pshift);     % the result of demodulation
value1x = dec2bin(sys1x',2)-'0';
value1x = value1x';
value1x = value1x(1:end);

code_value = ham7dec(value1x(33:end));
code1x = char(group(code_value,8,2));

display(code1x);