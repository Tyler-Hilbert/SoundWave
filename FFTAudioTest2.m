% Proof that fft can get original frequencies out
clear all;

% Generate signal
fs = 44100;                                % sample frequency (Hz)
t = 10;

x = audioread('sound.mp3');

% Perform fft and get values
y = fft(x);
n = length(x);          % number of samples
amp = abs(y)/n;    % amplitude of the DFT
amp = amp(1:fs/2);
f = (0:n-1)*(fs/n);     % frequency range
f = f(1:fs/2);


plot(f,amp)
xlabel('Frequency')
ylabel('amplitude')

% Turn fft back to signal
% Find freq
frequencies(1) = 0;
amplitudes(1) = 0;
cutoff = mean(amp) - abs(mean(amp))/4;
for i = 1:length(amp)
    if amp(i) > cutoff
        frequencies(length(frequencies)+1) = f(i);
        amplitudes(length(amplitudes)+1) = amp(i);
    end
end

% Generate signal
for i = 2:length(frequencies)
  newSound = GenerateSound(frequencies(i),amplitudes(i),fs, t);
  if i ~= 2
    sum = sum + newSound;
  else
    sum = newSound;
  end
end

% THis computes all the frequencies from FFT but takes a while to run
% for i = 1:length(f)
%   newSound = GenerateSound(f(i),amp(i),fs, t);
%   if i ~= 1
%     sum = sum + newSound;
%   else
%     sum = newSound;
%   end
% end

        
hplayer = audioplayer(sum, fs);
play(hplayer);
