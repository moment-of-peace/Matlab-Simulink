% BPSK, QPSK demodulation, Reed-Solomon decode, CRC check
clear;
fs = 2e6;

data3y = read_complex_byte('freq2C.bin');
signal = data3y(65000:94000);
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
position = synch(abs(a)-2, length(signal));
signal3y = signal(position(1):position(1)+13599);
train3y = signal3y(129:384);
x = train3y(1:128);
y = train3y(129:256);

shiftxy = mldivide(y,x);
shiftxy = shiftxy/abs(shiftxy);
freqshift = 2e6*log(shiftxy) / (128*2*pi*1i);

t = 0:1/fs:(length(signal3y)-1)/fs;
fshift3y = 2048; 
signal3y_fix = signal3y .*exp(1i*2*pi*fshift3y*transpose(t));
plot(signal3y_fix,'.');
pause;

iq3y = intdump(signal3y_fix(129:end),16); % 16 samples per symbol
pshift = atan(-real(iq3y(1))/imag(iq3y(1)));  %phase shift

training = [3 3 0 3 2 2 0 0];
train_mod = pskmod(training, 4, pshift);
h = deconv(iq3y(1:8), train_mod);   % transfer function

iq3y_recover = deconv(iq3y,h);   % recover
sys3y = pskdemod(iq3y_recover,4,pshift);     % the result of demodulation
value3y = dec2bin(sys3y',2)-'0';
value3y = value3y';
value3y = value3y(1:end);

% remove train(1:32), type(33:36), crc(end-15:end)
info3y = group(value3y(37:end-16),8,2);
raw = zeros(1,255);
raw(end-length(info3y)+1:end) = info3y;
dec3y = rsdec(gf(raw,8),255,239);
code_value3y = dec3y.x;
code_3y = char(rmzeros(code_value3y));  % remove zeros and convert to char

display(code_3y);   % the first message
pause

signal3y = signal(position(2):position(2)+13599);
t = 0:1/fs:(length(signal3y)-1)/fs;
signal3y_fix = signal3y .*exp(1i*2*pi*fshift3y*transpose(t));

iq3y = intdump(signal3y_fix(129:end),16); % 16 samples per symbol
pshift = atan(-real(iq3y(1))/imag(iq3y(1)));  %phase shift

train_mod = pskmod(training, 4, pshift);
h = deconv(iq3y(1:8), train_mod);   % transfer function

iq3y_recover = deconv(iq3y,h);   % recover
sys3y = pskdemod(iq3y_recover,4,pshift);     % the result of demodulation
value3y = dec2bin(sys3y',2)-'0';
value3y = value3y';
value3y = value3y(1:end);

% remove train(1:32), type(33:36), crc(end-15:end)
info3y = group(value3y(37:end-16),8,2);
raw = zeros(1,255);
raw(end-length(info3y)+1:end) = info3y;
dec3y = rsdec(gf(raw,8),255,239);
code_value3y = dec3y.x;
code_3y = char(rmzeros(code_value3y));  % remove zeros and convert to char

display(code_3y);
%raw = zeros(1,239);
%raw(end-2:end) = [97 98 99];
%msg3 = gf(raw,8);
%code3 = rsenc(msg3,255,239);
%coderaw = zeros(1,255);
%coderaw(end-18:end) = group(rs(1:76),4,4);
%dec = rsdec(gf(coderaw,8),255,239);