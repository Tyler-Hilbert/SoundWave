# Sound Wave
Sound wave is a basic signal processing and signal generating project written in MATLAB.  It has 3 main features: Processing audio as a sum of sin wave, generating signals using the mixer, and generating square, triangle and sawtooth waves.  In a nutshell, SoundWave lets a user see how sin waves can be added together to make different signals and then lets them hear how the signal sounds by playing it as audio.

# Processing audio as a sum of sin wave
Sound wave performs a FFT on the file song.wav to break the audio file up into the frequencies that make up the sound wave (for periodic signals only).  Then it can replay the sound as a sum of the sin waves that the FFT broke it into.  This is done by pressing the Sound button on top of the mixer.

# Generating signals using the mixer
Users can use the mixer to add up to 5 sin waves together choosing their frequencies and amplitudes.

# Generating square, triangle and sawtooth waves
users can use the example buttons on top of the mixer to generate a square, triangle or sawtooth wave.  This is done by programmatically adding together 125 sin waves that when added together will generate the desire wave.