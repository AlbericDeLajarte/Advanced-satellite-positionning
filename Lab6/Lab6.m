function [] = Lab6()
%% Load parameters and files
Lab6Params;

master_obs = load('datam.mat').datam;
rover_obs = load('datar.mat').datar;

%% Conversion of phase measurement from [cycles] to [m]
master_obs(:, 5:6) = master_obs(:, 5:6).*[c/F1, c/F2];
rover_obs(:, 5:6) = rover_obs(:, 5:6).*[c/F1, c/F2];

%% Lab6A: Fill DD matrix for each (sat_base, sat_k) pair, for each epoch
%% Lab6B: Ambuigity determination

nb_of_sat = length(all_sats_nb);
nb_of_epochs = length(master_obs)/nb_of_sat;
nb_of_meas = 4; % code and phase, for 2 frequencies

DD_matrix = zeros(nb_of_sat-1, nb_of_meas, nb_of_epochs);
ambiguity_matrix = zeros(nb_of_sat-1, 2, nb_of_epochs);
%accumulator_matrix_N = zeros(nb_of_sat-1, );
%accumulator_matrix_b = zeros(nb_of_sat-1, 2);

accumulator = struct();
accumulator.N = zeros(2,2);
accumulator.b = zeros(2,1);
accumulator_matrix = repmat(accumulator,1,nb_of_sat-1);
size(DD_matrix)

%%{
for epoch = 1:nb_of_epochs%1 %nb_of_epochs
    for k = 1:nb_of_sat-1
        sat_k = sats_nb(k);
        
        dd_epoch = compute_double_diff(base_sat_nb, sat_k, master_obs, rover_obs, epoch);
        DD_matrix(k, :, epoch) = dd_epoch;
        [N, b] = compute_normals(dd_epoch');

        ambiguity_matrix(k,:,epoch) = N\b;
        
        accumulator_matrix(k).N = accumulator_matrix(k).N + N;
        accumulator_matrix(k).b = accumulator_matrix(k).b + b;

    end
   
end
%%}
%{
ambiguities = struct();
ambiguities.N1 = 0;
ambiguities.N2 = 0;
ambiguities_matrix = repmat(ambiguities,1,nb_of_sat-1);
%}
ambiguities_matrix = zeros(nb_of_sat-1, 2);
for k = 1:nb_of_sat-1
    sat_k = sats_nb(k);
    ambig = accumulator_matrix(k).N\accumulator_matrix(k).b;
    ambiguities_matrix(k,1) = ambig(1);
    ambiguities_matrix(k,2) = ambig(2);
    %ambiguities_matrix(k).N1 = ambig(1);
    %ambiguities_matrix(k).N2 = ambig(2);
          
end
%% Self control:
DD_matrix(1,:,1);
ambiguity_matrix(1,:,137);
% N1, N2 over all epochs: 
%accumulator_matrix
ambiguities_matrix

end

