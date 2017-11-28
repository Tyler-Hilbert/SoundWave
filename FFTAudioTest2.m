% Proof that fft can get original frequencies out
clear all;

% Generate signal
fs = 41000;                                % sample frequency (Hz)
t = 10;
freq1 = 500;
freq2 =700;

x = GenerateSound(freq1,1,fs,t) + GenerateSound(freq2,1,fs,t); 


% Perform fft and get values
y = fft(x);


n = length(x);          % number of samples
f = (0:n-1)*(fs/n);     % frequency range
f = f(1:fs/2);
% power = abs(y).^2/n;    % power of the DFT
% power = power(1:fs/2);
% 
% plot(f,power)
amp = abs(y)/n;    % power of the DFT
amp = amp(1:fs/2);

plot(f,amp)
xlabel('Frequency')
ylabel('Power')

% Turn fft back to signal
% Find freq
frequencies(1) = 0;
for i = 1:length(amp)
    if amp(i) > .25
        frequencies(length(frequencies)+1) = f(i);
    end
end

% Generate signal
for i = 2:length(frequencies)
  newSound = GenerateSound(frequencies(i),1,fs, t);
  if i ~= 2
    sum = sum + newSound;
  else
    sum = newSound;
  end
end
        
hplayer = audioplayer(sum, fs);
play(hplayer);
