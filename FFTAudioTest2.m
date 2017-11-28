% Proof that fft can get original frequencies out
clear all;

% Generate signal
fs = 41000;                                % sample frequency (Hz)
t = 10;
freq1 = 500;
freq2 =700;

x = audioread('gong.mp3');%GenerateSound(freq1,1,fs,t) + GenerateSound(freq2,1,fs,t); 
% hplayer = audioplayer(x, fs);
% play(hplayer);

% Perform fft and get values
y = fft(x);


n = length(x);          % number of samples
f = (0:n-1)*(fs/n);     % frequency range
f = f(1:fs/2);

amp = abs(y)/n;    % amplitude of the DFT
amp = amp(1:fs/2);

plot(f,amp)
xlabel('Frequency')
ylabel('amplitude')

% Turn fft back to signal
% Find freq
frequencies(1) = 0;
amplitudes(1) = 0;
cutoff = mean(amp) - abs(mean(amp))/3;
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
