% Taking a second of an audio file and breaking it into n many chunks and
% figuring out what frequencies make up each of those chunks
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
chunks = 16;         % How many chunks to break wave into
for i = 1:chunks
    if i > 40
        break;
    end
    beginningChunk = (i-1)*fs/chunks+1;
    endChunk = i*fs/chunks;
    x = full(beginningChunk:endChunk);
    y = fft(x);
    n = length(x);     % number of samples in chunk
    amp = abs(y)/n;    % amplitude of the DFT
    amp = amp(1:end/2);
    f = (0:n-1)*(fs/n);     % frequency range
    f = f(1:end/2);

    pause(1);
    figure(1);
    plot(f,amp)
    axis([0 20000 0 .02]);
    xlabel('Frequency')
    ylabel('amplitude')
end

test = full((1-1)*fs/chunks+1:1*fs/chunks);
hplayer = audioplayer(test, fs);
play(hplayer);

