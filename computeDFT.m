function X = computeDFT(x)
    N = length(x);       % Number of samples
    X = zeros(1, N);     % Initialize output DFT sequence
    for k = 1:N          % For each DFT coefficient
        sum_val = 0;
        for n = 1:N      % For each sample in input
            % Calculate the exponential term
            exp_term = exp(-1j * (2 * pi / N) * (k-1) * (n-1));
            sum_val = sum_val + x(n) * exp_term;
        end
        X(k) = sum_val;  % Assign the computed value to the DFT sequence
    end
end

x = [0, 1, 2, 3];
input = computeDFT(x);
disp(X);