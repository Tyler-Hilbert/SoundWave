% Prototype to graph moving window of FFT through an audio file in real time
clear all;
warning('off','MATLAB:colon:nonIntegerIndex'); % Suppress integer operand errors because it's ok to round for the window size

% Read Audio
fs = 44100;             % sample frequency (Hz)
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

windowSize = fs/8;

% Find max in each bin
numBins = 2^3;
max(1) = 0;
for i = 2:numBins
    max(i) = 0;
end
for i = fs*startTime+1+windowSize : windowSize/4 : fs*endTime-windowSize
    beginningChunk = round(i-windowSize);
    endChunk = round(i+windowSize);
    x = full(beginningChunk:endChunk);
    y = fft(x, numBins);
    power = abs(y).^2; % Note the display doesn't calculate the power only the amplitude
    f = linspace(0,1,numBins);
    for i = 1:numBins
        if max(i) < power(i)
            max(i) = power(i);
        end
    end
end

% Perform fft and get frequencies (hopefully in realish time with audio)
for i = fs*startTime+1+windowSize : windowSize/4 : fs*endTime-windowSize
    % Get chunk to process
    beginningChunk = round(i-windowSize);
    endChunk = round(i+windowSize);
    
    % Calculate power for each frequency
    x = full(beginningChunk:endChunk);
    y = fft(x, numBins);
    amp = abs(y);
    f = linspace(0,1,numBins);

    % Normalize (note not true normalization since normalizedAmplitude will
    % never actually reach 1).
    normalizedAmplitude = amp./max;
    
    % Wait for audio to catch back up
    while initialTime+i/fs > toc
        pause(.0001);
    end
    % Plot
    figure(1);
    plot(f,normalizedAmplitude);
    axis([0 1 0 1]);
    xlabel('Frequency Bin');
    ylabel('Normalized Amplitude');
end

