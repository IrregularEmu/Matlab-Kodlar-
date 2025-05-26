% Component values from Table II for Figure 3
R1 = 10e3;         % Ohms
C1 = 2e-6;         % Farads

RA = 100e3;        % Ohms
RB = 100e3;        % Ohms
C2 = 8.2e-6;       % Farads

RLOAD = 100e3;     % Ohms
Cout = 0.5e-6;     % Farads

R2 = 100e3;        % Ohms (from note: R2 = 0.5 * RA to minimize bias current error)

% Define each stage's transfer function
s = tf('s');

% Input network (R1-C1)
H1 = 1 / (1 + s * R1 * C1);

% Bias network (RA//RB with C2), forms a high-pass filter, but for AC gain we focus on the gain path
% You can ignore the bias filter in gain, but it affects PSRR

% Output network (Rload-Cout)
H3 = 1 / (1 + s * RLOAD * Cout);

% Overall gain (inverting op-amp gain)
Gain = -R2 / R1;

% Total transfer function (cascaded response)
H_total = Gain * H1 * H3;

% Bode plot
figure;
bode(H_total);
grid on;
title('Bode Plot of Inverting Op-Amp Circuit (Figure 3)');
 