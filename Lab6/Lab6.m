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

%% Memory allocation
nb_of_sat = length(all_sats_nb);
nb_of_epochs = length(master_obs)/nb_of_sat;
nb_of_meas = 4; % code and phase, for 2 frequencies

DD_matrix = zeros(nb_of_sat-1, nb_of_meas, nb_of_epochs); % matrix to hold double differences
float_ambiguity_matrix = zeros(nb_of_sat-1, 2, nb_of_epochs); % matrix to hold unfixed ambiguities
int_ambiguity_matrix = zeros(nb_of_sat-1, 2, nb_of_epochs); % matrix to hold unfixed ambiguities
WL_IF_ambiguity_matrix = zeros(nb_of_sat-1, 2, nb_of_epochs);
Iono_delay_matrix = zeros(nb_of_sat-1, nb_of_epochs);

% accumulator_matrix is a matrix of structures that will hold the accumulated 
% N and b over the epochs
accumulator = struct();
accumulator.N = zeros(2,2);
accumulator.b = zeros(2,1);
accumulator_matrix = repmat(accumulator,1,nb_of_sat-1);

%% Lab6A and Lab6B: 
% We fill DD matrix with the double differences of code and phase measurements, 
% for each (sat_base, sat_k) pair, for each epoch. We also fix the
% ambiguities.
for epoch = 1:nb_of_epochs
    for k = 1:nb_of_sat-1 % iteration over all k, k != b
        sat_k = sats_nb(k); 
        
        dd_epoch = compute_double_diff(base_sat_nb, sat_k, master_obs, rover_obs, epoch);
        DD_matrix(k, :, epoch) = dd_epoch;
        [N, b] = compute_normals(dd_epoch');
        
        % Accumulation
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
fprintf("Double differences with satellite 2, 1st epoch\n: ");
disp(DD_matrix(1,:,1));
% N1, N2, WL accumulated over all epochs for each pair of satellites: (LAB B)
fprintf("Non fixed ambiguities at last epoch\n: ");
disp(float_ambiguity_matrix(:,:,nb_of_epochs));
fprintf("Wide-Lane ambiguities at last epoch\n: ");
disp(WL_IF_ambiguity_matrix(:,2,nb_of_epochs));
fprintf("Fixed ambiguities at last epoch: ");
disp(int_ambiguity_matrix(:,:,nb_of_epochs));


%% Plot
fig_nb = 1;
fig_nb = plot_WL_and_ionosphere_evolution(WL_IF_ambiguity_matrix,Iono_delay_matrix,sats_nb,base_sat_nb,fig_nb);

%% Lab 6.C
%% Initialization

% Compute position of satellites 
[x_k_master, x_b_master, pos_master] = find_sat_pos(master_obs, base_sat_nb);
[x_k_rover, x_b_rover, pos_rover] = find_sat_pos(rover_obs, base_sat_nb);

% Position of rover and master
x_master = [4367900.641   502906.393  4605656.413]; 
x_rover = x_master; % pos_rover'; % Can be initialized with Absolute positioning of with master coordinates

% Constant ranges related to the fixed master
rho_base_master = norm(x_master-x_b_master);
rhos_sat_master = compute_range_sat(x_master, x_k_master);

% Constant weight matrix
%P =  diag(2*ones((nb_of_sat-1)*2, 1))+ 2*ones((nb_of_sat-1)*2) ;
P =  (2*eye((nb_of_sat-1)*2) + 2*ones((nb_of_sat-1)*2, (nb_of_sat-1)*2));
%P = eye(14);

% Compute constant terms of the l' vector
% Concatenate the dd matrix for frequency 1 and for frequency 2. 
phase_range = [DD_matrix(:, 3, end); DD_matrix(:, 4, end)];
% Multiplications of ambiguities by wavelength, and concatenation for frequency 1 andfor frequency 2. 
ambiguity_range = [int_ambiguity_matrix(:,1,end); int_ambiguity_matrix(:,2,end)].*[repmat(lambda1, nb_of_sat-1, 1); repmat(lambda2, nb_of_sat-1, 1)];

delta_X_new = 1;
nb_iter = 0;
fprintf("\n");
%% Iterations until convergence 
while norm(delta_X_new) > 1e-5 % Convergence criteria % 1e-3
        
    disp("new Iteration");
    % Compute ranges related to the rover
    rho_base_rover = norm(x_rover-x_b_rover);
    rhos_sat_rover = compute_range_sat(x_rover,x_k_rover);
    
    % Compute range differences. We will concatenate them for the 2 frequencies
    rhos_diff = rho_base_master-rho_base_rover-rhos_sat_master+rhos_sat_rover;
    
    % Construct l'
    l_r = phase_range - ambiguity_range - [rhos_diff; rhos_diff];
    
    % Construct A
    u_sat_rover =  -(x_k_rover-x_rover)./rhos_sat_rover;
    u_base_rover = -(x_b_rover-x_rover)/rho_base_rover;
    A = repmat(u_sat_rover - u_base_rover, 2,1);
    
    % Solve linearization
    N = A'*P*A;
    b = A'*P*l_r;
    delta_X_new = N\b;
    
    % Update rover coordinates
    x_rover = x_rover + delta_X_new';
    
    nb_iter = nb_iter + 1;    
end

fprintf("\n----------Algorithm converged after %x iterations-------\n", nb_iter);
fprintf("Final rover coordinates :");
disp(x_rover);
% Distance to master
fprintf("\n Baseline: ")
baseline = norm(x_master-x_rover);
disp(baseline);
  
    

