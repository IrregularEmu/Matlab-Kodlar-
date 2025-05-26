% Component values from AN-581 Figure 1 / Table I
R1 = 16.5e3;        % Ohms
R2 = 150e3;         % Ohms
Rin = 33.3e3;       % Parallel of RA, RB, and RIN (~33.3kΩ)
Cin = 0.3e-6;       % Farads
Rload = 100e3;      % Ohms
Cout = 0.2e-6;      % Farads

% Time constants
tau_in = Rin * Cin;
tau_out = Rload * Cout;

% Amplifier gain
A = 1 + (R2 / R1);

% Define s = tf('s')
s = tf('s');

% Transfer function components
H_in = (s * tau_in) / (1 + s * tau_in);
H_out = (s * tau_out) / (1 + s * tau_out);

% Total system transfer function
H_total = A * H_in * H_out;

% Plot Bode plot
figure;
bode(H_total);
grid on;
title('Bode Plot of Figure 1 Transfer Function');

% Optional: display step or impulse response
figure;
step(H_total);
title('Step Response of Figure 1 Transfer Function');
