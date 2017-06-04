% Without incurring additional computation, modify the polyphase upsampling
% filter to frequency shift the data by heterodyning with a 6 kHz carrier. 
% That is the tones at 100, and 200 Hz will now be placed at 5800, 5900, 
% 6100, and 6200 Hz
M = 7;
fpoly = zeros(1,ceil(length(f)/M)*M);
fpoly(1:length(f)) = f;
fpoly = reshape(fpoly,M,length(fpoly)/M);
filtpoly =flipud(fpoly);
signalp = reshape(signal,M,length(signal)/M);
polyout = zeros(1,size(signalp,2)+size(filtpoly,2) - 1);

% downsample
for i=1:M
    polyout = polyout + conv(filtpoly(i,:),signalp(i,:));
end 
polyout = polyout(size(filtpoly,2):length(polyout)-size(filtpoly,2));
polyoutw = polyout.*blackman(length(polyout))';
Y=20*log10(abs(fft(polyoutw)));
X=fs*(0:length(Y)-1)/length(Y)/M;
plot(X',Y');
title('Downsample using polyphase filter');
xlabel('Frequency (Hz)');
pause

% upsample
polyup = zeros(M,length(polyout)+size(fpoly,2)-1);
for i = 1:M
    polyup(i,:) = conv(fpoly(i,:),polyout).*cos(2*pi*(i-1)/M);
end
polyup1 = reshape(polyup,1,size(polyup,1)*size(polyup,2));
polyup2 = polyup1(size(fpoly,2):length(polyup1)-size(fpoly,2));
polyupw = polyup2.*blackman(length(polyup2))';
Y=20*log10(abs(fft(polyupw)));
X=fs*(0:length(Y)-1)/length(Y);
plot(X',Y');
title('Upsample');
xlabel('Frequency (Hz)');
grid on