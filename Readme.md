# Sound Wave
SoundWave is a basic signal processing and signal generating project written in MATLAB.  It has 3 main features: 1) Turning an audio file into a sum of sin waves. 2) Generate and combining up to 5 sin waves using the mixer. 3) Generate square, triangle and sawtooth waves using only sin waves.  Each of these features displays a graph that shows the individual waves along with a graph of the mixed wave that is being played as audio.  In a nutshell, SoundWave lets a user see how sin waves can be added together to make different signals and then lets them hear how the signal sounds by playing it as audio.

# Turning a sound into a collection of frequencies and amplitudes
SoundWave performs a FFT on the file sound.mp3 to break it into a collection of frequencies and amplitudes (for periodic signals only).  Then it mixes all the frequencies and amplitudes together and plays them to audibly to verify the results.  This is done by pressing the Sound button on top of the mixer.
![](https://raw.githubusercontent.com/Tyler-Hilbert/SoundWave/master/FFT.JPG)

# Generating signals using the mixer
Users can use the mixer to add up to 5 sin waves together choosing their frequencies and amplitudes.

# Generating square, triangle and sawtooth waves
Users can use the example buttons on top of the mixer to generate a square, triangle or sawtooth wave.  This is done by programmatically adding together 125 sin waves that when added together will generate the desired wave.
![](https://raw.githubusercontent.com/Tyler-Hilbert/SoundWave/master/Square.JPG)



