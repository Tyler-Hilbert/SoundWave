Fs = 44100;
amp = 1;
freq = 2500;
duration = 10;

y = audioread('gong.mp3');%GenerateSound(freq,amp,Fs,duration) + GenerateSound(freq/2,amp,Fs,duration); 
NFFT = length(y);
Y = fft(y,NFFT);
F = ((0:1/NFFT:1-1/NFFT)*Fs).';

magnitudeY = abs(Y);        % Magnitude of the FFT
phaseY = unwrap(angle(Y));  % Phase of the FFT

helperFrequencyAnalysisPlot1(F,magnitudeY,phaseY,NFFT)

y1 = ifft(Y,NFFT,'symmetric');
hplayer = audioplayer(y1, Fs);
play(hplayer);