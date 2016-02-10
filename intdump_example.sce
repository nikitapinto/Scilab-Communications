// Example script to demonstrate the functionality of intdump.

// Define Values

// Number of samples per symbol
nsamp = 4; 

// Input Channels - Use a random bit sequence
ch1 = zeros(12,1);
idx_ch1 = floor(rand(4,1) * 10);
ch1(idx_ch1) = 1;

ch2 = zeros(12,1);
idx_ch2 = floor(rand(7,1) * 10);
ch2(idx_ch2) = 1;

// Combine channels into single input data matrix.
// Each column will be treated as a channel.
data = [ch1 ch2]; 

// Ouput
data_out = intdump(data,nsamp)
