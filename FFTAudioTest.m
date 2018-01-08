% Reference
% https://www.mathworks.com/help/signal/examples/practical-introduction-to-frequency-domain-analysis.html
% for information about FFT
clear all;

% read file
Fs = 44100;
y = audioread('song.wav');
length (y)
for i = 1:length(y)
  if y(i) ~= 0
      y=y(i:end);
      break;
  end
end

length(y)

i = 1;
for i = 1:9
    y = y(1:44100/3);
    %Fs = 44100; % Sampling rate from: audioinfo('song.wav')

    % FFT
    NFFT = length(y);
    Y = fft(y,NFFT);
    F = ((0:1/NFFT:1-1/NFFT)*Fs).';
    magnitudeY = abs(Y);        % Magnitude of the FFT
    phaseY = unwrap(angle(Y));  % Phase of the FFT

    % Plot
    figure(i);
    helperFrequencyAnalysisPlot1(F,magnitudeY,phaseY,NFFT)
end

% Recreate
y1 = ifft(Y,NFFT,'symmetric');
hplayer = audioplayer(y1, Fs);
play(hplayer);