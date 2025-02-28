% Name: Ayooluwa OWOLABI and % std#: 101237575
% ELEC 4700 Modelling of Integrated Device PA 6 
% New SetPNJctParasEqBCBias with the linearly graded junction

Coupled = 1;
TwoCarriers = 1;
RC = 1;

nx = 201; % Number of spatial points
l = 1e-6; % Length of the device

x =linspace(0,l,nx); % Position array 
dx = x(2)-x(1);
xm = x(1:nx-1) + 0.5*dx; % Midpoints for finite difference

% Doping limits
Nd = 4e16 * 1e6; % Const. 1/cm3 (100 cm/m)^3 % Donor doping at the edges
Na = 1e16 * 1e6; % Acceptor doping at the edges 


% Define junction width over which doping transitions linearly
W_j = l/10; % Junction transition width (adjustable)
x_j0 = l/2 - W_j/2; % Start of transition
x_j1 = l/2 + W_j/2; % End of transition


% Initialize NetDoping
NetDoping = zeros(1, nx);

% Define linearly graded junction
for i = 1:nx
    if x(i) < x_j0
        NetDoping(i) = Nd; % Fully n-type region
    elseif x(i) > x_j1
        NetDoping(i) = -Na; % Fully p-type region
    else
        % Linear transition from Nd to -Na
        NetDoping(i) = Nd - ((Nd + Na) / W_j) * (x(i) - x_j0);
    end
end

% Gaussian disturbance (optional)
x0 = l / 2;
nw = l / 20;
npDisturbance = zeros(1, nx);
% 0e16 * 1e6 * exp(-((x - x0) / nw).^2);

JBC = 1;
RVbc = 0;

TStop = 80000000 * 1e-18;
PlDelt = 1000000 * 1e-18;

% Junction built-in potential and depletion width calculations
Phi = C.Vt * log(Na * Nd / (niSi * niSi));
W  = sqrt(2 * EpiSi * (Nd + Nd) * (Phi) / (C.q_0 * Nd * Na));
Wn = W * Na / (Nd + Na);
Wp = (W - Wn);

LVbc = Phi;

PlotSS = 0;
% PlotYAxis = {[0 Phi+0.1] [0e5 40e5] [-20e2 40e2]...
%     [0e21 2.5e22] [0 1.1e22] [0 20e43]...
%     [-5e33 5e33] [-5e33 5e33] [-0e8 3e8] ...
%     [1e-3 1e8] [-3e6 1e6] [0 2.5e22]};

doPlotImage = 0;

SecondSim = 1;
LVbc2 = Phi - 0.3;
TStop2 = TStop + 80000000 * 1e-18;

fprintf('Phi: %g W: %g Wn: %g Wp: %g \n', Phi, W, Wn, Wp);

