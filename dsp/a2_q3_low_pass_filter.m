% A LP filter window design example
% Fs = 10Khz, Fc = 500Hz, Ft = 200Hz, A = 60dB

V = zeros(136,1);
V(1:28)=ones(28,1);
V(110:136)=ones(27,1);
x=10000*[0:135]/136;

plot(x,V); title('Desired Response V'); pause
v=fftshift(real(ifft(V)));
w=blackman(137); % Need an extra sample to get DFT symmetry
plot(v); title('Unwindowed Filter Impulse response'); pause
x=10000*[0:511]/512;
plot(x,20*log10(abs(fft(v,512))));title('Freq response');pause
plot(w); title('3-term Blackman Window');pause
f=v.*w(1:136);
plot(f); title('Windowed Filter Impulse Response');pause
plot(x,20*log10(abs(fft(f,512)))); title('Freq response');pause
grid;