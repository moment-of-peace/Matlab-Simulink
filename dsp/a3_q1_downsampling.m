% Implement the filter, downsample the output.Then reimplement the 
% filtering and downsampling with a single polyphase downsampling filter.
% Compare the number of operations required for the original FIR 
% implementation and the downsampling implementation.

% fs = 42Khz, passband = 0-250Hz, Ft = 100Hz, A = 60dB
fs = 42000;     % sample rate
Ns = 84000;     % sample number of signal containing the 4 tones
ft = 100;       % transition band width
A = 60;
factor = 60;   % the max downsample factor

N = 1523;   % 1522.4  9.0655

V = zeros(N,1);
V(1:10)=ones(10,1);
V(1514:1523)=ones(10,1);
X=fs*(0:1522)/1523;

plot(X,V); title('Desired Freq Response'); 
xlabel('Frequency (Hz)');
pause
v=fftshift(real(ifft(V)));
w=kaiser(1523,5.65); % no need to correct for DFT symmetry since N is odd
plot(v); title('Unwindowed Filter Impulse response'); 
pause
X=fs*(0:N-1)/N;
plot(X,20*log10(abs(fft(v))));title('Freq response (unwindowed)');
pause
plot(w); title('Kaiser Window beta=5.65');
pause
f=v.*w;
plot(f); title('Windowed Filter Impulse Response');
pause
plot(X,20*log10(abs(fft(f)))); title('Freq response (windowed)');
xlabel('Frequency (Hz)');
grid on;
pause

t = 0:1/fs:(Ns-1)/fs;    % generate time vector
signal = cos(2*pi*100*t) + cos(2*pi*200*t); % tones at 100 Hz and 200 Hz
signal = signal + cos(2*pi*1000*t) + cos(2*pi*1100*t);% tones at 1000Hz and 1100Hz

% spectrum of signal containing the four tones
X = fs*(0:Ns-1)/Ns;
Y = (abs(fft(signal)));
zoom on;
plot(X,Y);
title('Original data sampled at 42 kHz');
xlabel('Frequency (Hz)');
pause

tic; % reset time counter
for i = 1:100
    signalf = conv(f,signal);
end
t1 = toc/100;     % Time for single rate filtering
signalf = signalf(length(f):length(signalf)-length(f));%Remove edge effects
signalf = signalf.*blackman(length(signalf))';
Y=20*log10(abs(fft(signalf)));
X=fs*(0:length(Y)-1)/length(Y);
plot(X,Y);
title('Data processed by the lowpass filter');
xlabel('Frequency (Hz)');
grid on
pause

signald = signalf(factor:factor:end); % Downsample by 60
signalw = signald.*blackman(length(signald))';
Y=20*log10(abs(fft(signalw)));
X=fs*(0:length(Y)-1)/length(Y)/factor;
plot(X',Y');
title('Downsampling using single rate filter');
xlabel('Frequency (Hz)');
grid on
pause

fpoly = zeros(1,ceil(length(f)/factor)*factor);
fpoly(1:length(f)) = f;
fpoly = reshape(fpoly,factor,length(fpoly)/factor);
filtpoly =flipud(fpoly);
signalp = reshape(signal,factor,length(signal)/factor);
polyout = zeros(1,size(signalp,2)+size(filtpoly,2) - 1);

tic; % reset time counter
for j=1:100
    for i=1:factor
	    polyout = polyout + conv(filtpoly(i,:),signalp(i,:));
    end
end
t2 = toc/100;     % Time for polyphase filtering
polyout = polyout./100; % because the sum repeats 100 times in the loop
polyout = polyout(size(filtpoly,2):length(polyout)-size(filtpoly,2));
% Remove edge effects
polyoutw = polyout.*blackman(length(polyout))';
Y=20*log10(abs(fft(polyoutw)));
X=fs*(0:length(Y)-1)/length(Y)/factor;
plot(X',Y');
title('Reimplement with polyphase filter');
xlabel('Frequency (Hz)');
grid on