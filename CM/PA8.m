% ELEC 4700 - Diode Parameter Extraction
% Author: Ayooluwa OWOLABI and std#: 101237575
% Date: March 14, 2025

% 1. Generate Data
clc; clear; close all;

% Given Parameters
Is = 0.01e-12;  % Forward bias saturation current (pA)
Ib = 0.1e-12;   % Breakdown saturation current (pA)
Vb = 1.3;       % Breakdown voltage (V)
Gp = 0.1;       % Parasitic parallel conductance (Ω^-1)

% Voltage Vector
V = linspace(-1.95, 0.7, 200); % 200 points from -1.95V to 0.7V

% Ideal Diode Current
I = Is .* (exp(1.2 .* V / 0.025) - 1) + Gp .* V - Ib .* (exp(1.2 * (-(V + Vb)) / 0.025) - 1);

% Adding 20% Noise
I_noisy = I .* (1 + 0.2 * randn(size(I)));

% Plot Original and Noisy Data
figure;
subplot(1,2,1); 
plot(V, I, 'b', V, I_noisy, 'r.'); grid on;
title('Linear Scale'); 
xlabel('Voltage (V)');
ylabel('Current (A)');
legend('Original', 'Noisy');

subplot(1,2,2); 
semilogy(V, abs(I), 'b', V, abs(I_noisy), 'r.'); 
grid on;
title('Log Scale');
xlabel('Voltage (V)');
ylabel('|Current| (A)');
legend('Original', 'Noisy');

%% 2. Polynomial Fitting
% 4th and 8th Order Polynomial Fits
p4 = polyfit(V, I_noisy, 4);
p8 = polyfit(V, I_noisy, 8);
I_p4 = polyval(p4, V);
I_p8 = polyval(p8, V);

% Plot Polynomial Fits
figure;
subplot(1,2,1); 
plot(V, I_noisy, 'r.', V, I_p4, 'g', V, I_p8, 'm'); grid on;
title('Polynomial Fits');
xlabel('Voltage (V)');
ylabel('Current (A)');
legend('Noisy Data', '4th Order Fit', '8th Order Fit');

subplot(1,2,2); 
semilogy(V, abs(I), 'b', V, abs(I_noisy), 'r.', V, abs(I_p4), 'g', V, abs(I_p8), 'm'); 
grid on;
title('Log Scale');
xlabel('Voltage (V)');
ylabel('abs(I) [A]');
legend('data', 'Noisy', 'poly 4', 'poly 8');

% 3. Nonlinear Curve Fitting using fit()
fo = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C.*(exp(1.2*(-(x+D))/25e-3)-1)',...
    'independent', 'x', 'coefficients', {'A', 'B', 'C', 'D'});

% % Case 1: Fit A and C, Fix B and D
% ff1 = fit(V.', I_noisy.', fo, 'StartPoint', [Is, Gp, Ib, Vb], 'Lower', [0, Gp, 0, Vb], 'Upper', [1e-9, Gp, 1e-9, Vb]);
% % Case 2: Fit A, B, C, Fix D
% ff2 = fit(V.', I_noisy.', fo, 'StartPoint', [Is, 0.05, Ib, Vb], 'Lower', [0, 0, 0, Vb], 'Upper', [1e-9, 0.2, 1e-9, Vb]);
% % Case 3: Fit All Parameters
% ff3 = fit(V.', I_noisy.', fo, 'StartPoint', [Is, Gp, Ib, Vb], 'Lower', [0, 0, 0, 0], 'Upper', [1e-9, 0.2, 1e-9, 2]);

% NON-LINEAR CURVE FITTING
ft = fittype('A*(exp(1.2*x/25e-3)-1) + B*x - C*(exp(1.2*(-(x+D))/25e-3)-1)', 'independent', 'x', 'coefficients', {'A', 'B', 'C', 'D'});
fo2 = fit(V', I_noisy', ft, 'StartPoint', [Is, Gp, Ib, Vb], 'Lower', [Is, Gp, Ib, Vb], 'Upper', [Is, Gp, Ib, Vb]);
fo3 = fit(V', I_noisy', ft, 'StartPoint', [Is, Gp, Ib, Vb], 'Lower', [Is, Gp, 0, Vb], 'Upper', [Is, Gp, Inf, Vb]);
fo4 = fit(V', I_noisy', ft, 'StartPoint', [Is, Gp, Ib, Vb]);
If2 = fo2(V);
If3 = fo3(V);
If4 = fo4(V);

% Generate Fitted Data
I_fit1 = fo2(V); 
I_fit2 = fo3(V); 
I_fit3 = fo4(V);

% Plot Nonlinear Fits
figure;
subplot(1,2,1);
plot(V, I_noisy, 'r.', V, I_fit1, 'g', V, I_fit2, 'm', V, I_fit3, 'b'); 
grid on;
title('Nonlinear Curve Fitting'); 
xlabel('Voltage (V)'); 
ylabel('Current (A)');
legend('Noisy Data', 'Fit 1: A, C', 'Fit 2: A, B, C', 'Fit 3: All Params');

subplot(1,2,2); 
semilogy(V, abs(I), 'b', V, abs(I_noisy), 'r.', V, abs(I_fit1), 'g', V, abs(I_fit2), 'm', V, abs(I_fit3), 'k'); 
grid on;
title('Nonlinear Curve Fitting (Log)');
xlabel('Voltage (V)');
ylabel('abs(I) [A]');
legend('data', 'Noisy', 'fit 2', 'fit 3', 'fit 4');

% 4. Neural Network Fitting
inputs = V.';
targets = I_noisy.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net, tr] = train(net, inputs, targets);
outputs = net(inputs);
performance = perform(net, targets, outputs);
view(net);
Inn = outputs;

% Plot Neural Network Fit
figure;
subplot(1,2,1);
plot(V, I_noisy, 'r.', V, outputs, 'b');
grid on;
title('Neural Network Fit'); 
xlabel('Voltage (V)'); 
ylabel('Current (A)');
legend('Noisy Data', 'NN Output');

subplot(1,2,2); 
semilogy(V, abs(I), 'b', V, abs(I_noisy), 'r', V, abs(outputs), 'g'); 
grid on;
title('Neural Network Fit (Log)');
xlabel('Voltage (V)');
ylabel('abs(I) [A]');
legend('data', 'Noisy', 'outputs');

% 5. Gaussian Process Regression (GPR)
gpr_model = fitrgp(inputs, targets);
I_gpr = predict(gpr_model, inputs);
I_gpr_lower = I_gpr - 1.96 * inputs;
I_gpr_upper = I_gpr + 1.96 * inputs;


% Plot GPR Fit
figure;
subplot(1,2,1);
plot(V, I_noisy, 'r.', V, I_gpr, 'g');
grid on;
title('Gaussian Process Regression Fit');
xlabel('Voltage (V)');
ylabel('Current (A)');
legend('Noisy Data', 'GPR Fit', 'rgp mean', 'rgp lower', 'rgp upper');


subplot(1,2,2); 
semilogy(V, abs(I), 'b', V, abs(I_noisy), 'g', V, abs(I_gpr), 'k', V, abs(I_gpr_lower), 'r--', V, abs(I_gpr_upper), 'b--'); 
grid on;
title('Gaussian Process Regression Fit (Log)');
xlabel('Voltage (V)');
ylabel('abs(I) [A]');
legend('data', 'Noisy data', 'rgp fit', 'rgp lower', 'rgp upper');