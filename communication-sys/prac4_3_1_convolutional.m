% BPSK, QPSK demodulation, convolutional decode, CRC check
clear;
fs = 2e6;

data3x = read_complex_byte('freq2C.bin');
signal = data3x(36000:66000);
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
position = synch(abs(a)-4, length(signal));
signal3x = signal(position(1):position(1)+21087);
train3x = signal3x(129:384);
x = train3x(1:128);
y = train3x(129:256);

shiftxy = mldivide(y,x);
shiftxy = shiftxy/abs(shiftxy);
freqshift = 2e6*log(shiftxy) / (128*2*pi*1i);

t = 0:1/fs:(length(signal3x)-1)/fs;
fshift3x = 2048; 
signal3x_fix = signal3x .*exp(1i*2*pi*fshift3x*transpose(t));
plot(signal3x_fix,'.');
pause;

iq3x = intdump(signal3x_fix(129:end),16); % 16 samples per symbol
pshift = atan(-real(iq3x(1))/imag(iq3x(1)));  %phase shift

training = [3 3 0 3 2 2 0 0];
train_mod = pskmod(training, 4, pshift);
h = deconv(iq3x(1:8), train_mod);   % transfer function

iq3x_recover = deconv(iq3x,h);   % recover
sys3x = pskdemod(iq3x_recover,4,pshift);     % the result of demodulation
value3x = dec2bin(sys3x',2)-'0';
value3x = value3x';
value3x = value3x(1:end);

info3x = value3x(37:end-16); % 37:37+24*n
trellis = poly2trellis(3,[6 4 7]);
code_value = vitdec(info3x,trellis,3,'trunc','hard');
code_value3x = group(code_value,8,2);
code3x = char(code_value3x);

tbl = crcmaketable();
save('crctables.mat','tbl');
crc = comp_crc16(group_up(info3x,8,2)); % calculate crc
crcbit = bitget(crc,16:-1:1);

display(crcbit);              % calculated crc
display(value3x(end-15:end)); % received crc
display(code3x);                % the first message
pause

signal3x = signal(position(2):position(2)+6879);
t = 0:1/fs:(length(signal3x)-1)/fs;
signal3x_fix = signal3x .*exp(1i*2*pi*fshift3x*transpose(t));

iq3x = intdump(signal3x_fix(129:end),16); % 16 samples per symbol
pshift = atan(-real(iq3x(1))/imag(iq3x(1)));  %phase shift

training = [3 3 0 3 2 2 0 0];
train_mod = pskmod(training, 4, pshift);
h = deconv(iq3x(1:8), train_mod);   % transfer function

iq3x_recover = deconv(iq3x,h);   % recover
sys3x = pskdemod(iq3x_recover,4,pshift);     % the result of demodulation
value3x = dec2bin(sys3x',2)-'0';
value3x = value3x';
value3x = value3x(1:end);

info3x = value3x(37:end-16); % 37:37+24*n
trellis = poly2trellis(3,[6 4 7]);
code_value = vitdec(info3x,trellis,3,'trunc','hard');
code_value3x = group(code_value,8,2);
code3x = char(code_value3x);

display(code3x);                % final result
% decabc = vitdec(encabc,trellis,3,'trunc','hard')
% trellis = poly2trellis(3,[6 4 7]);encabc = convenc(valueabc,trellis);