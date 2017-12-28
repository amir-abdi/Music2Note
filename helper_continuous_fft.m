function helper_continuous_fft(data, Fs, plotHandle)
% Calculate FFT(data) and update plot with it. 

lengthOfData = length(data);
nextPowerOfTwo = 2 ^ nextpow2(lengthOfData); % next closest power of 2 to the length

plotScaleFactor = 4;
plotRange = nextPowerOfTwo / 2; % Plot is symmetric about n/2
plotRange = floor(plotRange / plotScaleFactor);

yDFT = fft(data, nextPowerOfTwo); % Discrete Fourier Transform of data

h = yDFT(1:plotRange);
abs_h = abs(h);

freqRange = (0:nextPowerOfTwo-1) * (Fs / nextPowerOfTwo);  % Frequency range
gfreq = freqRange(1:plotRange);  % Only plotting upto n/2 (as other half is the mirror image)

set(plotHandle, 'ydata', abs_h, 'xdata', gfreq); % Updating the plot
drawnow; % Update the plot

end