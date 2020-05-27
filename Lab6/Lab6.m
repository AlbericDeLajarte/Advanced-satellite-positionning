function [] = Lab6()
%% Load parameters and files
Lab6Params;

master_obs = load('datam.mat');
master_obs = master_obs.datam;
rover_obs = load('datar.mat');
rover_obs = rover_obs.datar;

%% Conversion of phase measurement from [cycles] to [m]
master_obs(:, 5:6) = master_obs(:, 5:6).*[c/F1, c/F2];
rover_obs(:, 5:6) = rover_obs(:, 5:6).*[c/F1, c/F2];

%% Lab6A: Fill DD matrix for each (sat_base, sat_k) pair, for each epoch
%% Lab6B: Ambuigity determination

nb_of_sat = length(all_sats_nb);
nb_of_epochs = length(master_obs)/nb_of_sat;
nb_of_meas = 4; % code and phase, for 2 frequencies

DD_matrix = zeros(nb_of_sat-1, nb_of_meas, nb_of_epochs);
%ambiguity_matrix = zeros(nb_of_sat-1, 2, nb_of_epochs); %probably not
%useful
float_ambiguity_matrix = zeros(nb_of_sat-1, 2, nb_of_epochs);
int_ambiguity_matrix = zeros(nb_of_sat-1, 2, nb_of_epochs);
WL_IF_ambiguity_matrix = zeros(nb_of_sat-1, 2, nb_of_epochs);
Iono_delay_matrix = zeros(nb_of_sat-1, nb_of_epochs);
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

        %ambiguity_matrix(k,:,epoch) = N\b; % probably not useful       
        accumulator_matrix(k).N = accumulator_matrix(k).N + N;
        accumulator_matrix(k).b = accumulator_matrix(k).b + b;
        
        ambig = accumulator_matrix(k).N\accumulator_matrix(k).b;
        float_ambiguity_matrix(k,:,epoch) = ambig';
        
        % Compute Wide Lane and Ionofree ambiguity 
        WL_IF_ambiguity_matrix(k,:,epoch) = [f2*ambig(1) - f1*ambig(2), ambig(1) - ambig(2)];
        
        % Compute integer ambiguity
        K1 = round(WL_IF_ambiguity_matrix(k,2,epoch));
        K2 = round(WL_IF_ambiguity_matrix(k,1,epoch));
        
        int_ambiguity_matrix(k,2,epoch) = round((f2*K1-K2)/(f1-f2));
        int_ambiguity_matrix(k,1,epoch) = K1 + int_ambiguity_matrix(k,2,epoch);
        
        % Compute Ionosphere delay
        Iono_delay_matrix(k, epoch) = (dd_epoch(3)-dd_epoch(4) - (c/F1)*int_ambiguity_matrix(k,1,epoch) + (c/F2)*int_ambiguity_matrix(k,2,epoch))/((f1^2/f2^2)-1);

    end  
end


%% Self control:
format long
% Double differences: (LAB A)
DD_matrix(1,:,1);
% N1, N2, WL accumulated over all epochs for each pair of satellites: (LAB B)
float_ambiguity_matrix(:,:,nb_of_epochs)
WL_IF_ambiguity_matrix(:,2,nb_of_epochs)

%% Lab 6.C



%% Plot
fig_nb = 1;
fig_nb = plot_ambiguities_evolution(int_ambiguity_matrix, WL_IF_ambiguity_matrix, fig_nb);
fig_nb = plot_ionosphere_evolution(Iono_delay_matrix, fig_nb);

%% LAB C:
[ephm, info, ~] = 


end

