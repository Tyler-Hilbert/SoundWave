function [a] = GenerateSound( freq, amp, fs, duration)
    values=0:1/fs:duration;
    a=amp*sin(2*pi*freq*values);
end