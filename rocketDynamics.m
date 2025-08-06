function x_dot = rocketDynamics(X, U)
%ROCKETDYNAMICS   6-DoF rocket equations of motion for MATLAB Function blocks.
%   x_dot = ROCKETDYNAMICS(X, U) returns the time derivative of the state
%   vector X for the control input U.  The implementation avoids symbolic
%   operations and is compatible with Simulink's MATLAB Function block.
%
%   State vector X:
%       [x; y; z; u; v; w; phi; theta; psi; p; q; r]
%   Input vector U:
%       [delta_theta; delta_phi]
%
%   The physical parameters are hard coded for simplicity.  Adjust the
%   constants below to match your vehicle.
%
%   Example usage in Simulink:
%       A MATLAB Function block can call this function to compute the state
%       derivatives which are then fed into integrator blocks.

%#codegen

% Physical parameters
m   = 50; 
Ix  = 1; Iy = 100; Iz = 100;
Ixy = 0; Ixz = 0; Iyz = 0;
I   = [Ix Ixy Ixz; Ixy Iy Iyz; Ixz Iyz Iz];

l_tvc = 1;   % thrust vector control arm
T     = 800; % thrust magnitude
g     = 9.81;

% Unpack states
x     = X(1); %#ok<NASGU> % position states are not used directly
y     = X(2); %#ok<NASGU>
z     = X(3); %#ok<NASGU>
u     = X(4); 
v     = X(5); 
w     = X(6); 
phi   = X(7); 
theta = X(8); 
psi   = X(9); 
p     = X(10); 
q     = X(11); 
r     = X(12);

% Unpack inputs
delta_theta = U(1);
delta_phi   = U(2);

% Thrust vector expressed in the body frame
F_thrust = T * [-sin(delta_theta)*cos(delta_phi);
                sin(delta_phi);
                cos(delta_theta)*cos(delta_phi)];

% Body-to-inertial rotation matrix (3-2-1 Euler sequence)
R_ib = [cos(theta)*cos(psi),  cos(theta)*sin(psi), -sin(theta);
        sin(phi)*sin(theta)*cos(psi) - cos(phi)*sin(psi), ...
        sin(phi)*sin(theta)*sin(psi) + cos(phi)*cos(psi), ...
        sin(phi)*cos(theta);
        cos(phi)*sin(theta)*cos(psi) + sin(phi)*sin(psi), ...
        cos(phi)*sin(theta)*sin(psi) - sin(phi)*cos(psi), ...
        cos(phi)*cos(theta)];

% Gravity in body frame (inertial z upward)
g_body = R_ib.' * [0; 0; -g];

% Linear velocity derivatives
uvw_dot = F_thrust/m + [r*v - q*w;
                        p*w - r*u;
                        q*u - p*v] + g_body;

% Moments from thrust: tau = r x F with r = [0;0;-l_tvc]
omega = [p; q; r];
Tau = cross([0; 0; -l_tvc], F_thrust);
Tau = Tau([3 2 1]);  % reorder as [Mz; My; Mx]

% Gyroscopic effects
H    = I * omega;
gyro = cross(omega, H);
omega_dot = I \ (Tau - gyro);

% Euler angle derivatives
T_phi_theta = [1, sin(phi)*tan(theta),  cos(phi)*tan(theta);
               0, cos(phi),            -sin(phi);
               0, sin(phi)/cos(theta),  cos(phi)/cos(theta)];
Euler_dot = T_phi_theta * omega;

% Position derivatives
pos_dot = R_ib * [u; v; w];

% Assemble derivative vector
x_dot = [pos_dot; uvw_dot; Euler_dot; omega_dot];
end
