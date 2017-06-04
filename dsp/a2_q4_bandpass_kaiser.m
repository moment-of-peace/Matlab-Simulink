% A Bandpass filter window design example with Kaiser Window
% Fs = 1Khz, passband = 150-250Hz, Ft = 50Hz, A = 60dB


V = zeros(251,1);
V(69:184)=ones(116,1);

x=10000*[0:250]/251;

plot(x,V); title('Desired Response V'); pause
v=fftshift(real(ifft(V)));
w=kaiser(251,7.8573); % no need to correct for DFT symmetry since N is odd
plot(v); title('Unwindowed Filter Impulse response'); pause
x=10000*[0:511]/512;
plot(x,20*log10(abs(fft(v,512))));title('Freq response');pause
plot(w); title('Kaiser Window beta=5.65');pause
f=v.*w;
plot(f); title('Windowed Filter Impulse Response');pause
plot(x,20*log10(abs(fft(f,512)))); title('Freq response');pause
grid;
