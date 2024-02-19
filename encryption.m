% Read an image
original_image = imread('han.jpg');

% Check if the image is in color (RGB)
if size(original_image, 3) == 3
    % Convert to grayscale only if it's a color image
    original_image = rgb2gray(original_image);
end

% Apply 2D Fourier Transform
fft_image = fft2(original_image);

% Shift zero frequency components to the center
fft_image_shifted = fftshift(fft_image);

% Calculate magnitude and phase
magnitude = abs(fft_image_shifted);
phase = angle(fft_image_shifted);

% Encryption using Bitwise XOR
secret_key = 42;

% Encryption using Bitwise XOR for magnitude
encrypted_magnitude = bitxor(int64(round(abs(magnitude))), int64(secret_key));

% Encryption using Bitwise XOR for phase
encrypted_phase_real = bitxor(int64(round(real(phase))), int64(secret_key));
encrypted_phase_imag = bitxor(int64(round(imag(phase))), int64(secret_key));
encrypted_phase = complex(encrypted_phase_real, encrypted_phase_imag);

% Decryption using Bitwise XOR for magnitude
decrypted_magnitude = bitxor(int64(round(abs(encrypted_magnitude))), int64(secret_key));

% Decryption using Bitwise XOR for phase
decrypted_phase_real = bitxor(int64(round(real(encrypted_phase))), int64(secret_key));
decrypted_phase_imag = bitxor(int64(round(imag(encrypted_phase))), int64(secret_key));
decrypted_phase = complex(decrypted_phase_real, decrypted_phase_imag);

% Reconstruct the image using the decrypted magnitude and phase matrices
reconstructed_image = ifft2(double(decrypted_magnitude) .* exp(1i * double(decrypted_phase)));

% Convert original_image to double
original_image = double(original_image);

% Convert reconstructed_image to double
reconstructed_image = double(abs(reconstructed_image));

% Calculate PSNR between original image and reconstructed image
mse = immse(original_image, reconstructed_image);
max_pixel_value = double(max(original_image(:)));
psnr_value = 10 * log10((max_pixel_value^2) / mse);

fprintf('Peak Signal-to-Noise Ratio (PSNR): %.2f dB\n', psnr_value);

% Display the original image
figure;
imshow(original_image, []);
title('Original Image');

% Display the magnitude spectrum
figure;
imagesc(log(1 + double(decrypted_magnitude)));

colormap('gray');
title('Decrypted Magnitude Spectrum');

% Display the phase spectrum
figure;
imagesc(angle(double(decrypted_phase)));
colormap('gray');
title('Decrypted Phase Spectrum');

% Display the reconstructed image
figure;
imshow(abs(reconstructed_image), []);
title('Reconstructed Image using Decrypted Magnitude and Phase');

% Display the real part of the reconstructed Fourier Transform
figure;
imagesc(real(fft2(reconstructed_image)));
colormap('gray');
title('Real Part of Reconstructed Fourier Transform');

% Display the imaginary part of the reconstructed Fourier Transform
figure;
imagesc(imag(fft2(reconstructed_image)));
colormap('gray');
title('Imaginary Part of Reconstructed Fourier Transform');