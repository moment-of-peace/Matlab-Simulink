% Design a 8th order low pass IIR Butterworth filter assuming a sampling 
% frequency of 20 kHz and a passband edge at 3 kHz 
N=8; 		% filter order
Fs=20000; 	% sampling frequency
Fc=3000;	% cutoff frequency
Nfft = 1024;	% size of FFT
m=16; 		% Number of bits for quantization

[B,A] = butter(N,2*Fc/Fs);  % design Butterworth IIR filter
x=Fs*(0:(Nfft-1))/Nfft;
plot(x,20*log10(abs(fft(B,Nfft)./fft(A,Nfft)))) % fft diagram
title([num2str(N) 'th order Butterworth IIR Filter'])
xlabel('Frequency (Hz)'), ylabel('Amplitude (dB)')
zoom on; grid on;
pause
freqz(B,A);     % frequency and phase response
pause

zplane(B,A)
title([num2str(N) 'th order Butterworth IIR Filter'])
pause

% Quantize coefficients to 16 bits
Bq=B./max(B);	% scale to a max value <= 1
Bq=floor(2^(m-1)*Bq);   % multiply by 2^15,then remove fractional part
Bq=max(B)*Bq/2^(m-1);   % divided by 2^15, then renormalize
Aq=A./max(A);	%scale to a max value <= 1
Aq=floor(2^(m-1)*Aq);   % multiply by 2^15,then remove fractional part
Aq=max(A)*Aq/2^(m-1);    % divided by 2^15, then renormalize

plot(x,20*log10(abs(fft(Bq,Nfft)./fft(Aq,Nfft))))
title([num2str(m) 'Bit Quantized Butterworth IIR Filter'])
xlabel('Frequency (Hz)'), ylabel('Amplitude (dB)')
zoom on; grid on;
pause
freqz(Bq,Aq);
pause

[H1,H2,H3]=zplane(B,A);
set(H1,'Color',[1 0 1])	% Chamge Colours
set(H2,'Color',[1 0 1])
hold on
zplane(Bq,Aq)
title([num2str(m) 'Bit Quantized Butterworth IIR Filter'])