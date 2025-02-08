% Name: Ayooluwa Owolabi and Student Number: 101237575
% Course: ELEC 4700A PA#4
% Laplace Equation by Iteration

% Define the parameters 
nx = 50; % Number of grid points in the x-axis
ny = 50; % Number of grid points in the y-axis
max_iter = 5000; % maximum number of iterations
% ctl = 1e-5; % convergence tolerance

% Defining and initializing the potential matrix 
V1 = zeros(nx, ny); % Potential matrix V

% The Boundary conditions, top and bottom insulating (Neumann)
% Case 1: Left (1), Right(0) 
V1(1, :) = 1; % The left boundary condition 
V1(end, :) = 0; % The right boundary condition

% Case 2: Left (1), Right(0), top and bottom insulating (0)
V2 = zeros(nx, ny);
V2(:, 1) = 1;% Left boundary = 1
V2(:,end) = 0; % Right boundary = 0
V2(1,:) = 0; % Top boundary = 0
V2(end,:) = 0; % Bottom boundary = 0

% % The boundary conditions (Insulated top/bottom)
% V(1, :) = 1; % The left boundary condition
% V(end, :) = 0; % The right boundary condition

% Solving the Laplace Equation for both the cases 
for no_cases = 1:2
    if no_cases == 1
        V = V1;
    else 
        V = V2;
    end 

    for iter = 1:max_iter
        V_old = V;

        for i = 2:nx-1
            for j = 2:ny-1
                V(i, j) = 0.25 * (V_old(i+1,j) + V_old(i-1,j) + V_old(i,j+1) + V_old(i,j-1));
            end
        end 

        % Second iteration for the second boundary conditions 
        if no_cases == 1
            V(:, 1) = 1;
            V(:,end) = 0;
            V(1,:) = V(2,:); % Neumann (insulating top)
            V(end,:) = V(end-1,:); % Neumann (insulating bottom)
        else
            V(:,1) = 1;
            V(:,end) = 0;
            V(1,:) = 0;
            V(end,:) = 0;
        end
    end

    % Storing the results of the laplace equation solution
    if no_cases == 1
        V1 = V; 
    else 
        V2 = V;
    end 
end 

% Generate the electric field for the two cases 
[Ex1, Ey1] = gradient(-V1); % Case 1 Electric Field
[Ex2, Ey2] = gradient(-V2); % Case 2 Electric Field

% The output plot 
figure;

% Case 1: Potential Distribution
subplot(2,2,1);
surf(V1);
title('Potential Distribution (Case 1)');
xlabel('x');
ylabel('y'); 
zlabel('Voltage (V)');
shading interp; 


% Case 1: Electric Field Vector Plot
subplot(2,2,2);
quiver(Ex1, Ey1);
title('Electric Field Vectors (Case 1)');
xlabel('x'); 
ylabel('y');
axis equal;

% Case 2: Potential Distribution
subplot(2,2,3);
surf(V2);
title('Potential Distribution (Case 2)');
xlabel('x');
ylabel('y'); 
zlabel('Voltage (V)');
shading interp;


% Case 2: Electric Field Vector Plot
subplot(2,2,4);
quiver(Ex2, Ey2);
title('Electric Field Vectors (Case 2)');
xlabel('x');
ylabel('y');
axis equal;

