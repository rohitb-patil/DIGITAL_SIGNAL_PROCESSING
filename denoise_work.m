originalImage = imread('labr2.jpg');

if size(originalImage, 3) == 3
    grayImage = rgb2gray(originalImage);
else
    grayImage = originalImage;
end

figure;
subplot(2, 2, 1);
imshow(grayImage);
title('Original Image');

Fp = 10 * 10^3; 
Fs = 50 * 10^3; 
Transition_band = 5 * 10^3; 

Omega_p = 2 * pi * Fp / Fs;  
Omega_s = 2 * pi * (Fp + Transition_band) / Fs;  

Wp = Omega_p;
Ws = Omega_s;

k = 4;  
N = k * ceil(Fs / Transition_band);  
N = N + rem(N + 1, 2); 
Alpha = (N - 1) / 2;

Wc = (Omega_p + Omega_s) / 2;

% Manually compute Blackman window
n = 0:N-1;
WBlackman = 0.42 - 0.5 * cos(2 * pi * n / (N - 1)) + 0.08 * cos(4 * pi * n / (N - 1));

filteredImage = zeros(size(grayImage));

for row = 1:size(grayImage, 1)
    h = zeros(1, N);
    for i = 1:N
        if i == Alpha + 1
            h(i) = Wc / pi;
        else
            h(i) = sin(Wc * (i - Alpha - 1)) / (pi * (i - Alpha - 1));
        end
    end
    h = h .* WBlackman;  % Use Blackman window
    
    filteredImage(row, :) = conv(double(grayImage(row, :)), h, 'same');
end

% Apply FIR low-pass filter to each column
for col = 1:size(grayImage, 2)
    h = zeros(1, N);
    for i = 1:N
        if i == Alpha + 1
            h(i) = Wc / pi;
        else
            h(i) = sin(Wc * (i - Alpha - 1)) / (pi * (i - Alpha - 1));
        end
    end
    h = h .* WBlackman;  % Use Blackman window
    
    filteredImage(:, col) = conv(double(filteredImage(:, col)), h, 'same');
end

% Display the filtered image
subplot(2, 2, 2);
imshow(uint8(filteredImage));
title('Filtered Image');

% Plot the frequency response of the FIR low-pass filter
freqResponse = fft(h);
freqAxis = linspace(0, Fs/2, length(freqResponse)/2);

subplot(2, 2, 3);
plot(freqAxis, abs(freqResponse(1:length(freqResponse)/2)));
title('Frequency Response of FIR Low-pass Filter');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Plot the unit impulse response of the low-pass filter
subplot(2, 2, 4);
stem(h);
title('Unit impulse response of the low-pass filter');
xlabel('Sample Index');
ylabel('Amplitude');