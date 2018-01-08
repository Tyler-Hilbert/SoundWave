clear all;

% Read Audio
fs = 44100;         % sample frequency (Hz)
full = audioread('song.wav');

% Remove leading 0's
for i = 1:fs
    if full(i) ~= 0
        crop = i;
        break
    end
end
full = full(crop:end);

% Perform fft and get frequencies
windowSize = fs/16;
for i = windowSize/2+1 : fs/32 : fs*5
    beginningChunk = i-windowSize/2;
    endChunk = i+windowSize/2;
    x = full(beginningChunk:endChunk);
    y = fft(x);
    n = length(x);     % number of samples in chunk
    amp = abs(y).^2/n;    % amplitude of the DFT
    amp = amp(1:end/2);
    f = (0:n-1)*(fs/n);     % frequency range
    f = f(1:end/2);

    pause(.0005);
    figure(1);
    plot(f,amp)
    axis([0 10000 0 3]);
    xlabel('Frequency')
    ylabel('amplitude')
    max(amp)
end

% test = full((1-1)*fs/chunks+1:1*fs/chunks);
% hplayer = audioplayer(test, fs);
% play(hplayer);

