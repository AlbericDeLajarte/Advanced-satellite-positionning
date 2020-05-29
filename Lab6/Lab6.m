function [] = Lab6(base_sat)
%% Load parameters and files
Lab6Params;
addpath(genpath(pwd))


master_obs = load('datam.mat');
master_obs = master_obs.datam;
rover_obs = load('datar.mat');
rover_obs = rover_obs.datar;

base_sat_nb = base_sat; % assigned base satellite 
sats_nb = all_sats_nb(all_sats_nb~=base_sat_nb);


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
        
        % Compute integer ambiguity using Clyde Goad method
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
DD_matrix(1,:,1)
% N1, N2, WL accumulated over all epochs for each pair of satellites: (LAB B)
float_ambiguity_matrix(:,:,nb_of_epochs)
WL_IF_ambiguity_matrix(:,2,nb_of_epochs)
int_ambiguity_matrix(:,:,nb_of_epochs)
%% Lab 6.C



%% Plot
%{
fig_nb = 1;
fig_nb = plot_ambiguities_evolution(int_ambiguity_matrix, WL_IF_ambiguity_matrix, fig_nb);
fig_nb = plot_ionosphere_evolution(Iono_delay_matrix, fig_nb);
%}

%% LAB C:

% Position of satellites
[x_k_master, x_b_master, pos_master] = find_sat_pos(master_obs, base_sat_nb)
[x_k_rover, x_b_rover, pos_rover] = find_sat_pos(rover_obs, base_sat_nb)

% Position of rover and master
x_master = [4367900.641   502906.393  4605656.413];
x_rover =  pos_rover'; % x_master; % Could be initialized with Absolute positioning from Lab2

% Constant ranges related to the fixed master
rho_base_master = norm(x_master-x_b_master);
rhos_sat_master = compute_range_sat(x_master, x_k_master);

% Constant weight matrix
%P =  diag(2*ones((nb_of_sat-1)*2, 1))+ 2*ones((nb_of_sat-1)*2) ;
P =  (2*eye((nb_of_sat-1)*2) + 2*ones((nb_of_sat-1)*2, (nb_of_sat-1)*2));
%P = eye(14);

% Compute constant terms of the l' vector
% Concatenate the dd matrix for frequency 1 andfor frequency 2. 
phase_range = [DD_matrix(:, 3, end); DD_matrix(:, 4, end)];
% We multiply ambiguities by wavelength
ambiguity_range = [int_ambiguity_matrix(:,1,end); int_ambiguity_matrix(:,2,end)].*[repmat(lambda1, nb_of_sat-1, 1); repmat(lambda2, nb_of_sat-1, 1)];

% Init
delta_X = 0; 
delta_X_new = 1;


i = 1;
disp("Initial coordinates");
x_rover 
while norm(delta_X_new) > 1e-5 % Convergence criteria % 1e-3
    
    disp("new Iteration");
    % Compute ranges related to the rover
    rho_base_rover = norm(x_rover-x_b_rover);
    rhos_sat_rover = compute_range_sat(x_rover,x_k_rover);
     
    rhos_diff = rho_base_master-rho_base_rover-rhos_sat_master+rhos_sat_rover;
    % Construct A and l'
    l_r = phase_range - ambiguity_range - [rhos_diff; rhos_diff];
    u_sat_rover =  -(x_k_rover-x_rover)./rhos_sat_rover;
    u_base_rover = -(x_b_rover-x_rover)/rho_base_rover;
    A = repmat(u_sat_rover - u_base_rover, 2,1);

    N = A'*P*A;
    b = A'*P*l_r;

    delta_X_new = N\b;
    x_rover = x_rover + delta_X_new'

    % Self control:
    disp("self control");
    v_1 = A*delta_X_new + l_r
    v_2 = l_r
    
    %delta_X = delta_X + delta_X_new
    
    %disp(inv(N))
    
end
%}
x_rover
% Distance to master
baseline = norm(x_master-x_rover)
end
    
    

