% Name: Ayooluwa Owolabi and Student Number: 101237575
% Course: ELEC 4700A PA#4
% Laplace Equation by Iteration

% Define the parameters 
nx = 50; % Number of grid points in the x-axis
ny = 50; % Number of grid points in the y-axis
max_iter = 5000; % maximum number of iterations
ctl = 1e-5; % convergence tolerance

V = zeros(nx, ny); % Potential matrix V

% The boundary conditions (Insulated top/bottom)
V(1, :) = 1; % The left boundary 
V(end, :) = 0; % The right boundary 

% The iterative solution 
for x = 1:max_iter
    old_V = V;

    % The updated interior points using the finite difference method 
    for i = 2:nx-1
        for j = 2:ny-1
            V(i, j) = (old_V(i+1, j) + old_V(i-1, j) + old_V(i, j+1) + old_V(i, j-1)) / 4;
        end 
    end 

    % Applying an insulated boundary condition at the top and bottom
    V(:, 1) = V(:, 2); % top
    V(:, end) = V(:, end-1); % bottom


    % Checking for convergence 
    if max(abs(V(:) - old_V(:))) < ctl
        fprintf("Output converged in %d iterations \n", x);
        break;
    end 
end

% The visualization 
figure; 
surf(V'); shading interp; colorbar;
title("Potential Distribution (Case 1)");
xlabel("X"); 
ylabel("Y");
zlabel("Pot_V");

% Compute Electric Field
[Ey, Ex] = gradient(-V'); 

figure;
quiver(Ex, Ey, 10);
title('Electric Field Vector Plot');
xlabel('X'); 
ylabel('Y');

% Case 2: Change boundary conditions (V=1 left/right, V=0 top/bottom)
V = zeros(nx, ny); % Reset V
V(1, :) = 1; V(end, :) = 1; % Left and Right boundary conditions
V(:, 1) = 0; V(:, end) = 0; % Top and Bottom boundary conditions 

% Iterate again
for x = 1:max_iter
    old_V = V;
    
   for i = 2:nx-1
        for j = 2:ny-1
            V(i, j) = (old_V(i+1, j) + old_V(i-1, j) + old_V(i, j+1) + old_V(i, j-1))/ 4;
        end
    end
    
    if max(abs(V(:) - old_V(:))) < ctl
        fprintf('Case 2 Converged in %d iterations\n', x);
        break;
    end
end

figure;
surf(V'); shading interp; colorbar;
title('Potential Distribution (Case 2)');
xlabel('X'); 
ylabel('Y');
zlabel('Potential V');

% Apply Image Processing Filter
title('Potential Distribution with imboxfilt');
V_filtered = imboxfilt(V, 3);
figure;
surf(V_filtered'); shading interp; colorbar;
title('Smoothed Potential Distribution');
xlabel('X'); 
ylabel('Y');
zlabel('Potential V');