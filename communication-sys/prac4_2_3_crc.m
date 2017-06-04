% BPSK, QPSK demodulation, Hamming decode, CRC check
clear;
fs = 2e6;

data2x = read_complex_byte('freq2B.bin');
signal = data2x(3001:11000);
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
signal2x = signal(position(1):position(1)+2191);
train2x = signal2x(129:384);
x = train2x(1:128);
y = train2x(129:256);

shiftxy = mldivide(y,x);
shiftxy = shiftxy/abs(shiftxy);
fshift2x = 2e6*log(shiftxy) / (128*2*pi*1i);

t = 0:1/fs:(length(signal2x)-1)/fs;
signal2x_fix = signal2x .*exp(1i*2*pi*fshift2x*transpose(t));
plot(signal2x_fix,'.');
pause;

iq2x = intdump(signal2x_fix(129:end),16); % 16 samples per symbol
pshift = atan(-real(iq2x(1))/imag(iq2x(1)));  %phase shift

training = [3 3 0 3 2 2 0 0];
train_mod = pskmod(training, 4, pshift);
h = deconv(iq2x(1:8), train_mod);   % transfer function

iq2x_recover = deconv(iq2x,h);   % recover
sys2x = pskdemod(iq2x_recover,4,pshift);     % the result of demodulation
value2x = dec2bin(sys2x,2)-'0';
value2x = value2x';
value2x = value2x(1:end);

ham = value2x(33:end-16);
code_value = ham15dec(ham);
code_value2x = group(code_value,8,2);
code2x = char(code_value2x);

tbl = crcmaketable();
save('crctables.mat','tbl');
crc = comp_crc16(group_up(ham,8,2)); % calculate crc
crcbit = bitget(crc,16:-1:1);

display(crcbit);                % calculated crc
display(value2x(end-16:end-1)); % received crc
display(code2x);                % the first message
pause

signal2x = signal(position(2):position(2)+4719);
t = 0:1/fs:(length(signal2x)-1)/fs;
signal2x_fix = signal2x .*exp(1i*2*pi*fshift2x*transpose(t));

iq2x = intdump(signal2x_fix(129:end),16); % 16 samples per symbol
pshift = atan(-real(iq2x(1))/imag(iq2x(1)));  %phase shift

train_mod = pskmod(training, 4, pshift);
h = deconv(iq2x(1:8), train_mod);   % transfer function

iq2x_recover = deconv(iq2x,h);   % recover
sys2x = pskdemod(iq2x_recover,4,pshift);     % the result of demodulation
value2x = dec2bin(sys2x,2)-'0';
value2x = value2x';
value2x = value2x(1:end);

ham = value2x(33:end-16);
code_value = ham15dec(ham);
code_value2x = group(code_value,8,2);
code2x = char(code_value2x);
display(code2x);                % the second message