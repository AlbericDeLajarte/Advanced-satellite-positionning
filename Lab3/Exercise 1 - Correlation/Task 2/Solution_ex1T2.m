%  Advanced Satellite Positioning - Lab 3 Task 2

%% Setup
addpath("../Task 1");
load('Ex1T2_mistery_signal.mat');

fs = 6.5e6; % [Hz] 
fc = 1.023e6; % [Hz] 
data_length = 1; % [ms] 
PRN_code = 1:10;


%% Compute the crosscorrelation with different PNR number
tic;
sat_number = find_PRN_code(PRN_code, fs, fc, data_length, mistery_s, "showCorr");
toc

%% Find delay of each detected satellite
for PNR = sat_number
    delay = find_PRN_delay(PNR, fs, fc, data_length, mistery_s, "showCorr");
    disp("Detected satellite "+ PNR + " with delay = " + delay + " seconds");
end
    