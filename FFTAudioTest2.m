% Prototype to graph moving window of FFT through an audio file in real time
clear all;
warning('off','MATLAB:colon:nonIntegerIndex'); % Suppress integer operand errors because it's ok to round for the window size

% Read Audio
fs = 44100;         % sample frequency (Hz)
full = audioread('song.wav');

% Remove leading 0's and select range
for i = 1:fs
    if full(i) ~= 0
        crop = i;
        break
    end
end
full = full(crop:end);

startTime = 0;
endTime = length(full)/fs;

% Play song
tic
player = audioplayer(full(fs*startTime+1:fs*endTime), fs);
player.play();
initialTime = toc;

% Perform fft and get frequencies (hopefully in realish time with audio)
windowSize = fs/8;
for i = windowSize/2+1+fs*startTime : fs/16 : fs*endTime
    % Get chunk to process
    beginningChunk = round(i-windowSize/2);
    endChunk = round(i+windowSize/2);
    
    % Calculate power for each frequency
    x = full(beginningChunk:endChunk);
    y = fft(x);
    n = length(x);          % number of samples in chunk
    power = abs(y).^2/n;    % power of the DFT
    power = power(1:end/2);
    f = (0:n-1)*(fs/n);     % frequency range
    f = f(1:end/2);
    
    % Emphasis filter
%     power = power(1:end).*f(1:end); % Note this probably isn't a good emphasis filter
    
    % Wait for audio to catch back up
    while initialTime+i/fs > toc
        pause(.0001);
    end
    % Plot
    figure(1);
    plot(f,power);
    axis([0 10000 0 5]);
    xlabel('Frequency');
    ylabel('Power');
end

