% Remez design of LP filter
% Fs = 10 kHz, Fc = 1 kHz (-3dB), A = 60 dB at 1.5 kHz

% From harris, length = 55, so order = 54
f=remez(54,[0 .2 .3 1],[1 1 0 0]);
zoom on; plot(f); title('Impulse Response'); pause
x=[0:255]*10000/256;
plot(x,20*log10(abs(fft(f,256))));
title('Optimal LP Filter')
pause

%f=remez(54,[0 .2 .3 1],[1 1 0 0], [1 10]);
f=remez(32,[0 .2 .3 1],[1 1 0 0], [1 300]);
plot(x,20*log10(abs(fft(f,256))));
title('Optimal LP Filter with Stopband Weighting')
pause

subplot(221); plot(f); title('Impulse Response');
subplot(222); plot(x,20*log10(abs(fft(f,256))));
title('Optimal LP Filter with Stopband Weighting')
subplot(223); plot(unwrap(angle(fft(f,256)))); title('Unwrapped Phase Response');
pause;
subplot(111); 
