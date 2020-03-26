%  Advanced Satellite Positioning - Lab 3 Task 2

%% Setup
addpath("../Task 1");
load('Ex1T2_mistery_signal.mat');

fs = 6.5e6; % [Hz] 
fc = 1.023e6; % [Hz] 
data_length = 1; % [ms] 


%% Compute the crosscorrelation with different PNR number
maxPNR = zeros(1, 10);

for PNR = 1:10
    CA_code = generateGoldCodeSampled (PNR, fs, fc, data_length);
    maxPNR(PNR) = max(computeCorrelation(CA_code, mistery_s));
end

    
figure(1);
plot(maxPNR)
xlabel("Satellite number");
ylabel("Correlation");

CA_code_1 = generateCAcode(1);
CA_code_ext_1 = interp1(0:1/(1.023e6):1e-3-1/(1.023e6), CA_code_1, 0:1/(6.5e6):1e-3-1/(6.5e6), 'nearest', 'extrap');
plot(computeCorrelation(CA_code_ext_1, mistery_s));