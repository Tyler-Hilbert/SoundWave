clear all;
clf;

fs=20500;  % sampling frequency
duration=10;
values=0:1/fs:duration;

displayRange = 100;

baseFreq = 500;
s1 = GenerateSound(baseFreq,1, fs, duration);
s2 = GenerateSound(baseFreq*3,1/3, fs, duration);
s3 = GenerateSound(baseFreq*5,1/5, fs, duration);
s4 = GenerateSound(baseFreq*7,1/7, fs, duration);
s5 = GenerateSound(baseFreq*9,1/9, fs, duration);
sum = s1+s2+s3+s4+s5;

sum = GenerateSound(baseFreq,1,fs, duration);
figure(4);
for i = 3:2:251
    newSound = GenerateSound(baseFreq*i,1/i,fs, duration);
    hold on;
    plot (values(1:displayRange), newSound(1:displayRange));
    sum = sum + newSound;
end

player = audioplayer(sum, fs);
player.play();

figure(1);
plot (values(1:displayRange), s1(1:displayRange), values(1:displayRange), s2(1:displayRange), values(1:displayRange), s3(1:displayRange), values(1:displayRange), s4(1:displayRange),values(1:displayRange), s5(1:displayRange));

figure(2);
plot (values(1:displayRange), sum(1:displayRange));

figure(3);
maxValue = max(sum);
minValue = min(sum);
maxOutput = maxValue + abs(maxValue/3);
minOutput = minValue - abs(minValue/3);
tic
initialTime = toc;
for i = 1:500:fs*duration
    while initialTime+i/fs > toc
        pause(.001);
    end
    plot(values(i:i+500), sum(i:i+500));
    axis([i/fs (i+500)/fs minOutput maxOutput]);
end