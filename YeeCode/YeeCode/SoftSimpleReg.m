% Name: Ayooluwa Owolabi 
% ELEC 4700 PA #3
% Student Number: 101237575

winstyle = 'docked';
% winstyle = 'normal';

set(0,'DefaultFigureWindowStyle',winstyle)
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')
% set(0,'defaultfigurecolor',[1 1 1])

% clear VARIABLES;
clear
global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight



dels = 0.75;
spatialFactor = 1;

c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);

tSim = 200e-15; % Time simulation for the excitation to be executed
f = 230e12; % The frequency of the excitation 
lambda = c_c/f; % The wavelength formula 

xMax{1} = 20e-6;
nx{1} = 200;
ny{1} = 0.75*nx{1};


Reg.n = 1;

mu{1} = ones(nx{1},ny{1})*c_mu_0;

epi{1} = ones(nx{1},ny{1})*c_eps_0; 

% % Creating a circular dielectric scatterer
% x_round = round(nx{1}/2); % center of domain 
% y_round = round(ny{1}/2);
% 
% radius = 30; % Radius in the grid points 
% 
% for x = 1:nx{1}
%     for y = 1:ny{1}
%         if(x-x_round)^2 + (y-y_round)^2 <= radius^2
%             epi{1}(x,y)=c_eps_0*11.3; % High permittivity inclusion
%         end
%     end
% end 
% 
% % Adding/ Including randomly placed scatterers 
% scattnum = 20; % Number of scatterers 
% scatt_size = 12; % Size of the scatterers
% 
% for i = 1:scattnum 
%     xPos = randi([50, nx{1}-50-scatt_size]); % Random x position
%     yPos = randi([50, ny{1}-50-scatt_size]); % Random y position
%     epi{1}(xPos:xPos+scatt_size, yPos:yPos+scatt_size) = c_eps_0 * 6; % Different permittivity
% end 

% epi{1}(125:150,55:95)= c_eps_0*11.3; % Single inclusion 
% This loop replaces the single inclusion which has been commented out
% above
% Creating a grating by adding the multiple inclusion 
period = 20; %Spacing between the inclusions (in grid points)
width = 10; % Width of each inclusion 
start_x = 100; % starting position in the x-direction
start_y = 55; % starting position in the y-direction
end_x = 180; % ending position in the x-direction
end_y = 95; % ending position in the y-direction 

% for xPos = start_x:period:end_x
%     epi{1}(xPos:xPos+width, start_y:end_y) = c_eps_0 * 11.3;
% end 

sigma{1} = zeros(nx{1},ny{1});
sigmaH{1} = zeros(nx{1},ny{1});

dx = xMax{1}/nx{1};
dt = 0.25*dx/c_c;
nSteps = round(tSim/dt*2);
yMax = ny{1}*dx;
nsteps_lamda = lambda/dx;


movie = 1;
Plot.off = 0;
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100;
Plot.MaxEz = 2.5;
Plot.MaxH = Plot.MaxEz/c_eta_0;
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax];


bc{1}.NumS = 1;
% % Adding multiple sources 
% % First source 
% bc{1}.s(1).xpos = nx{1}/(4) + 1; % Source position 
% bc{1}.s(1).type = 'ss'; % Soft source 
% bc{1}.s(1).fct = @PlaneWaveBC; % Function used for the excitation 
% bc{1}.s(1).paras = {1, 0, f*2*pi,0,30e-15,15e-15,0,yMax/4,1.5*lambda,'s'};
% 
% % Second source @ a different location
% bc{1}.s(1).xpos = 3*nx{1}/(4) + 1; % Source position 
% bc{1}.s(1).type = 'ss'; % Soft source 
% bc{1}.s(1).fct = @PlaneWaveBC; % Function used for the excitation 
% bc{1}.s(1).paras = {1,pi/2,f*2*pi,0,30e-15,15e-15,0,3*yMax/4,1.5*lambda,'s'};

% First source (original source)
bc{1}.s(1).xpos = nx{1}/(4) + 1; % Source position 
bc{1}.s(1).type = 'ss'; % Soft source 
bc{1}.s(1).fct = @PlaneWaveBC; % Function used for the excitation 
% mag = -1/c_eta_0;
mag = 1;
phi = 0;
omega = f*2*pi;
betap = 0;
t0 = 30e-15;
% Create and set the parameter that controls the pulse width of the source
st = 15e-15;
% st = -0.05;
s = 0;
y0 = yMax/2;
sty = 1.5*lambda;
bc{1}.s(1).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'};

% Second source
bc{1}.s(2).xpos = 3*nx{1}/(4) + 1; % Source position 
bc{1}.s(2).type = 'ss'; % Soft source 
bc{1}.s(2).fct = @PlaneWaveBC; % Function used for the excitation
bc{1}.s(2).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'};

Plot.y0 = round(y0/dx);

bc{1}.xm.type = 'a';
bc{1}.xp.type = 'e';
bc{1}.ym.type = 'a';
bc{1}.yp.type = 'a';

pml.width = 20 * spatialFactor;
pml.m = 3.5;

Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;

RunYeeReg





