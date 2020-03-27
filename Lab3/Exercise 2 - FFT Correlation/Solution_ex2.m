% Advanced Satellite Positioning - Lab 3: Acquisition of GPS signal
% Spring 2018

%% Setup
load('Ex2_mistery_signal.mat');

fs = 6.5e6; % Sampling frequency [Hz] 
fc = 1.023e6; % Chipping rate, 1023 chips per ms [Hz] 
data_length = 1; % [ms] 
PRN_code = 1:10;

%% Compute the crosscorrelation with different PNR number
tic;
sat_number = find_PRN_code_FFT(PRN_code, fs, fc, data_length, mistery_s, 'showCorr');
toc

i = 2;
for PRN = sat_number
    delay = find_PRN_delay_FFT(PRN, fs, fc, data_length, mistery_s, 'showCorr',i );
    disp(strcat('Detected satellite ', {' '} , num2str(PRN),' with delay = ', {' '} , num2str(delay), ' sec'));
    i = i + 1;
end


