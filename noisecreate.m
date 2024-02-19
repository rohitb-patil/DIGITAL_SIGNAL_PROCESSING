% Read the image
originalImage = imread('labr2.jpg'); % Replace 'your_image.jpg' with the actual image file name

% Display the original image
figure;
imshow(originalImage);
title('Original Image');

% Add Gaussian noise in the spatial domain
mean = 1;
stdDev = 45; % You can adjust this value to control the intensity of the noise

noise = stdDev * randn(size(originalImage));
noisyImage = uint8(double(originalImage) + noise);

% Display the noisy image
figure;
imshow(noisyImage);
title('Noisy Image in Spatial Domain');

% Compute the FFT of the original and noisy images
fftOriginalImage = fft2(originalImage);
fftNoisyImage = fft2(noisyImage);

% Visualize the magnitude spectrum of the original image
magnitudeSpectrumOriginal = log(1 + abs(fftshift(fftOriginalImage)));

% Visualize the magnitude spectrum of the noisy image
magnitudeSpectrumNoisy = log(1 + abs(fftshift(fftNoisyImage)));

% Display the magnitude spectrum of the original image
figure;
figure;
imshow(magnitudeSpectrumOriginal, []);
title('Magnitude Spectrum - Original Image');

% Display the magnitude spectrum of the noisy image
figure;
imshow(magnitudeSpectrumNoisy, []);
title('Magnitude Spectrum - Noisy Image');

% Compute the phase spectrum of the original and noisy images
phaseSpectrumOriginal = angle(fftshift(fftOriginalImage));
phaseSpectrumNoisy = angle(fftshift(fftNoisyImage));

% Display the phase spectrum of the original image
figure;
imshow(phaseSpectrumOriginal, []);
title('Phase Spectrum - Original Image');

% Display the phase spectrum of the noisy image
figure;
imshow(phaseSpectrumNoisy, []);
title('Phase Spectrum - Noisy Image');

% Save the noisy image if needed
imwrite(noisyImage, 'noisy_image_spatial.jpg'); % Replace 'noisy_image_spatial.jpg' with the desired output file name
