% Name: Ayooluwa Owolabi and std#: 101237575
% ELEC 4700 PA #5
% Harmonic Wave Equation in 2D FD and Modes 
% ELEC 4700A - Wave Equation Solver using Matrix Formulation
% Create a sparse matrix G and solve for eigenvalues and eigenvectors

clc; clear; close all;

% Define grid size
nx = 60;
ny = 40;

% Initialize sparse matrix G
G = sparse(nx*ny, nx*ny);

% Fill G matrix using finite difference method
for i = 1:nx
    for j = 1:ny
        n = j + (i - 1) * ny;
        
        if i == 1 || i == nx || j == 1 || j == ny  % Boundary condition
            G(n, n) = 1;
        else  % Bulk nodes using finite difference
            G(n, n)   = -4;
            G(n, n-1) = 1;  % Left neighbor
            G(n, n+1) = 1;  % Right neighbor
            G(n, n-ny) = 1; % Below neighbor
            G(n, n+ny) = 1; % Above neighbor
        end
    end
end

% Change the ‘−4’ in the G matrix diagonal to ‘−2’ for a region of space
% Modify region where i > 10 & i < 20 & j > 10 & j < 20
% for i = 11:19
%     for j = 11:19
%         n = j + (i - 1) * ny;
%         G(n, n) = -2;  % Change diagonal element
%     end
% end

% Plot G matrix sparsity pattern
figure;
spy(G);
title('Sparsity Pattern of G Matrix');

% Compute eigenvalues and eigenvectors
[E, D] = eigs(G, 9, 'SM');  % Get 9 smallest eigenvalues

% Plot eigenvalues
figure;
stem(diag(D), 'Color', [1 0 1], 'LineWidth', 2);
title('Eigenvalues of Modified G Matrix');
xlabel('Eigenvalue Index');
ylabel('Eigenvalue');

% Reshape and plot eigenvectors
figure;
for k = 1:9
    subplot(3,3,k);
    surf(reshape(E(:,k), ny, nx));
    title(['Mode ', num2str(k)]);
    shading interp;
end
