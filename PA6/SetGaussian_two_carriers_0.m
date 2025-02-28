% Name: Ayooluwa OWOLABI and % std#: 101237575
% ELEC 4700 Modelling of Integrated Device PA 6 
% New Setgaussian_two_carriers_RC_Only with the exponential and linear
% doping gradeint

Coupled = 1;
TwoCarriers = 1;
RC = 1;

nx = 201; % Number of spatial points 
l = 1e-6; % Length of device (1mum)

x = linspace(0,l,nx); % Position array
dx = x(2)-x(1);
xm = x(1:nx-1) + 0.5*dx; % Midpoints for finite difference

% doping limits 
Nd_min = 1e16 * 1e6; % Const. 1/cm3 (100 cm/m)^3
Nd_max = 20e16 * 1e6;

% Linear gradient using the doping limits
% NetDoping = Nd_min + (Nd_max - Nd_min) * (x / 1);  

% Exponential doping profile 
alpha = log(Nd_max / Nd_min) / l; % exponential growth rate
NetDoping = Nd_min * exp(alpha * x); % Exponential variation 

% Gaussian disturbance
x0 = l/2; % center of disturbance
nw = l/20; % width of disturbance 
npDisturbance = 1e16*1e6*exp(-((x-x0)/nw).^2);
% npDisturbance = 0;

% Boundary conditions
LVbc = 0; % Left 
RVbc = 0; % Right 

TStop = 14200000*1e-18; % Total simulation time
PlDelt = 100000*1e-18; % Time step for plotting 

% PlotYAxis = {[-1e-15 2e-15] [-2e-9 2e-9] [-1.5e-12 1.5e-12]...
%     [1e22 2e22] [0 1e22] [0 20e43]...
%     [-20e33 15e33] [-2.5e34 2e34] [-1.1e8 1.1e8] ...
%     [-1e8 1e8] [-10e-3 10e-3] [0 2e22]};

doPlotImage = 0;
PlotFile = 'Gau2CarRC.gif';
