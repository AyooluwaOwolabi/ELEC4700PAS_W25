% This example shows how to calculate and plot both the
% fundamental TE and TM eigenmodes of an example 3-layer ridge
% waveguide using the full-vector eigenmode solver.  

% Refractive indices:
n1 = 3.34;          % Lower cladding
n2 = 3.44;          % Core
n3 = 1.00;          % Upper cladding (air)

% Layer heights:
h1 = 2.0;           % Lower cladding
h2 = 1.3;           % Core thickness
h3 = 0.5;           % Upper cladding

% Horizontal dimensions:
rh = 1.1;           % Ridge height
rw_initial = 0.325; % Initial Ridge half-width
rw_final = 1.0;     % Final Rige final-width
side = 1.5;         % Space on side\

% Grid size:
dx = 0.0125;        % grid size (horizontal)
dy = 0.0125;        % grid size (vertical)

% Make the mesh 8 times less dense
dx_coarse = dx * 8;
dy_coarse = dy * 8;

lambda = 1.55;      % vacuum wavelength
nmodes = 10;         % number of modes to compute

% Ridge half-width sweep 
rw_values = linspace(rw_initial, rw_final, 10);
neff_results = zeros(10, nmodes); % Storing the effective indices for all steps

figure; 
for i = 1:length(rw_values)
    rw = rw_values(i); % Current ridge half-width

    % Generate waveguide mesh for the current ridge width(s)
    [x, y, xc, yc, nx, ny, eps, edges] = waveguidemesh([n1, n2, n3], ...
                                                        [h1, h2, h3], ...
                                                        rh, rw, side, ...
                                                        dx_coarse, dy_coarse);

% Considering the TE mode:
 [Hx, Hy, neff] = wgmodes(lambda, n2, nmodes, dx_coarse, dy_coarse, eps, '000A');
    neff_results(i, :) = neff; % Store neff for this ridge width
    
    % Plot modes for the first mode (example visualization)
    subplot(2, 5, i);
    contourmode(x, y, Hx(:, :, 1)); % Plot Hx of the first TE mode
    title(['rw = ' num2str(rw)]);
    xlabel('x'); ylabel('y');
    for v = edges, line(v{:}); end
end

% Plot effective indices (neff) vs ridge half-width
figure;
plot(rw_values, neff_results(:, 1), '-o');
title('Effective Index (neff) vs Ridge Half-Width');
xlabel('Ridge Half-Width (rw)');
ylabel('Effective Index (neff)');
grid on;




% % First consider the fundamental TE mode:
% 
% [Hx,Hy,neff] = wgmodes(lambda,n2,nmodes,dx,dy,eps,'000A');
% 
% for n = 1:nmodes
%     fprintf(1,'neff = %.6f\n',neff);
% 
%     figure(n);
%     subplot(121);
%     contourmode(x,y,Hx(:,:,n));
%     title(['Hx (TE mode:' num2str(n) ')']);
%     xlabel('x'); ylabel('y'); 
%     for v = edges, line(v{:}); end
% 
%     subplot(122);
%     contourmode(x,y,Hy(:,:,n));
%     title(['Hy (TE mode:' num2str(n) ')']); 
%     xlabel('x'); ylabel('y'); 
%     for v = edges, line(v{:}); end
% end 
% 
% 
% % Next consider the fundamental TM mode
% % (same calculation, but with opposite symmetry)
% 
% for n = 1:nmodes
%     [Hx,Hy,neff] = wgmodes(lambda,n2,nmodes,dx,dy,eps,'000S');
%     fprintf(1,'neff = %.6f\n',neff);
%     figure(n+nmodes);
%     subplot(121);
%     contourmode(x,y,Hx(:,:,n));
%     title(['Hx (TE mode:' num2str(n) ')']);  
%     xlabel('x'); ylabel('y'); 
%     for v = edges, line(v{:}); end
% 
%     subplot(122);
%     contourmode(x,y,Hy(:,:,n));
%     title(['Hy (TE mode:' num2str(n) ')']);  
%     xlabel('x'); ylabel('y'); 
%     for v = edges, line(v{:}); end
% end 
