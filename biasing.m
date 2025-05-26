% Time vector: 0 to 200 ms
t = linspace(0, 0.2, 2000);  % seconds

% Parameters
f_ac = 50;          % AC signal frequency in Hz
f_noise = 100;      % Power supply ripple frequency in Hz
Vs = 5.0;           % Single supply voltage in volts
bias = Vs / 2;      % Bias voltage (e.g., 2.5V)

% Signals
ac_signal = sin(2 * pi * f_ac * t);                   % Pure AC signal
biased_signal = ac_signal + bias;                     % With biasing (VS/2)
noise = 0.5 * sin(2 * pi * f_noise * t);              % Stronger simulated ripple (0.5V)
biased_with_noise = biased_signal + noise;            % Biased but noisy
biased_with_decoupling = biased_signal;               % Clean bias (ideal decoupling)

% Plotting
figure;
plot(t * 1000, ac_signal, 'k:', 'LineWidth', 1.2, ...
    'DisplayName', 'Original AC Signal (No Bias)');
hold on;
plot(t * 1000, biased_with_noise, 'r--', 'LineWidth', 1.5, ...
    'DisplayName', 'With Biasing Only (No Decoupling)');
plot(t * 1000, biased_with_decoupling, 'b-', 'LineWidth', 2, ...
    'DisplayName', 'With Biasing and Decoupling');

grid on;
xlabel('Time (ms)');
ylabel('Voltage (V)');
title('Effect of Biasing and Decoupling on AC Signal');
legend('Location', 'best');
ylim([0 5.5]);
