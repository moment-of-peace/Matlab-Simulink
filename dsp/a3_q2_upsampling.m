% Upsample the output of the downsampling filter of Question 1 back to the 
% original 42 kHz sampling rate by designing an appropriate upsampling 
% filter using zero packing and low-pass filtering. Then reimplement as a 
% polyphase upsampling filter.
signalup = zeros(1,length(signald)*factor); % implement zero padding
signalup(1:factor:end) = signald;
Y=20*log10(abs(fft(signalup)));
X=fs*(0:length(Y)-1)/length(Y);
plot(X,Y);                  %The spectrum of the data after zero packing
title('Upsample by zero packing');
xlabel('Frequency (Hz)');
grid on;
pause

tic; % reset time counter
for i = 1:100
    signalr = conv(f,signalup);% processed by lp filter
end
t1 = toc/100;     % Time for single rate filtering
signalr1 = signalr(length(f):length(signalr)-length(f));
signalrw = signalr1.*blackman(length(signalr1))';
Y=20*log10(abs(fft(signalrw)));
X=fs*(0:length(Y)-1)/length(Y);
plot(X',Y');
title('Processed by lowpass filter');
xlabel('Frequency (Hz)');
grid on
pause

% reimplement using polyphse filter
polyup = zeros(factor,length(polyout)+size(fpoly,2)-1);
tic; % reset time counter
for j=1:100
    for i = 1:factor
        polyup(i,:) = conv(fpoly(i,:),polyout);
    end
end
t2 = toc/100;     % Time for polyphase filtering
polyup1 = reshape(polyup,1,size(polyup,1)*size(polyup,2));
polyup1 = polyup1./100;% because the sum repeats 100 times in the loop
polyup2 = polyup1(size(fpoly,2):length(polyup1)-size(fpoly,2));
polyupw = polyup2.*blackman(length(polyup2))';
Y=20*log10(abs(fft(polyupw)));
X=fs*(0:length(Y)-1)/length(Y);
plot(X',Y');
title('Reimplement using polyphase filter');
xlabel('Frequency (Hz)');
grid on