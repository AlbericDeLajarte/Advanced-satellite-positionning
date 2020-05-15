function [] = Lab6A()
%% Load parameters and files
Lab6Params;

master_obs = load('datam.mat').datam;
rover_obs = load('datar.mat').datar;

%% Conversion of phase measurement from [cycles] to [m]
master_obs(:, 5:6) = master_obs(:, 5:6).*[c/F1, c/F2];
rover_obs(:, 5:6) = rover_obs(:, 5:6).*[c/F1, c/F2];

%% Fill DD matrix for each (sat_base, sat_k) pair, for each epoch
nb_of_sat = length(sats_nb);
nb_of_epochs = length(master_obs)/nb_of_sat;
nb_of_meas = 4; % code and phase, for 2 frequencies

DD_matrix = zeros(nb_of_sat-1, nb_of_meas, nb_of_epochs);
size(DD_matrix)

%%{
for epoch = 1:1 %nb_of_epochs
    for k = 1:nb_of_sat
        sat_k = sats_nb(k);
        if base_sat_nb == sat_k
            continue;
        end
        DD_matrix(k, :, epoch) = compute_double_diff(base_sat_nb, sat_k, master_obs, rover_obs, epoch);
    end
end 
%%}
%% Self control:
DD_matrix(1,:,1)
end

