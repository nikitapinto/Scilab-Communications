// Example script to demonstrate functionality of ssbmod.
// The script contains an example for each of the three variations of function ssbmod.

// Define Values
fc = 20; 
fs = 100;
t = [0:2*fs+1]'/fs;
x = sin(2*%pi*t);

// Using function ssbmod
// output is a lower sideband modulated signal with zero intial phase
y_default = ssbmod(x,fc,fs); 

// Input arguments include initial phase 
y_initialphase = ssbmod(x,fc,fs,%pi); 

// Input arguments include zero initial phase, and upper sideband modulation.
y_upper = ssbmod(x,fc,fs,0,'upper');

// Any of the above modulated signals can be visualized using the following code.
// Uncomment the desired modulated signal.
y = y_default;
//y = y_initialphase;
//y = y_upper;

z = fft(y);
z = abs(z(1:length(z)/2+1 ));

// Setup frequency axis
faxis = (0:fs/length(z):fs -(fs/length(z)))/2;

subplot(2,1,1)
plot(y);
title('SSB Modulated Signal');

subplot(2,1,2)
plot(faxis,z);
title('Spectrum of ssb modulated signal')


