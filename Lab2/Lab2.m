%% Lab 2
%% General informations
sat_nums_4_sats = [2 5 8 12];
sat_nums_7_sats = [2 5 8 11 12 24 25];
t = 225445.0; % Time of week [s]
c = 299792458; % [m/s]
we = 7.2921151467e-5; %[m/s]

% Pseudoranges:
pseudoranges_4_sats = [26145267.471, 26881228.000, 24180868.178 , 24167301.217];
pseudoranges_7_sats = [26145267.471, 26881228.000, 24180868.178 , 24915794.070, ...
    24167301.217, 23029783.450, 22758409.968];

%% Lab 2.A: find location of Galileo receiver's antenna using Bancroft algorithm
disp('BANCROFT')
[r_4_sats, b_4_sats, ecef_4_sats, P_4_sats] = bancroft_approach(t, sat_nums_4_sats, we, pseudoranges_4_sats);
[r_7_sats, b_7_sats, ecef_7_sats, P_7_sats] = bancroft_approach(t, sat_nums_7_sats, we, pseudoranges_7_sats);

%% Lab 2.B1: find location of Galileo's receiver's antenna using linearization approach
% We use the corrected pseudoranges
disp('LINEARIZATION')
[deltas_4_sats, A_4_sats] = linearized_approach(r_4_sats, b_4_sats, ecef_4_sats, P_4_sats);
[deltas_7_sats, A_7_sats] = linearized_approach(r_7_sats, b_7_sats, ecef_7_sats, P_7_sats);

% We can correct the positions with the deltas
r_4_sats_corrected = r_4_sats + deltas_4_sats(1:3);
r_7_sats_corrected = r_7_sats + deltas_7_sats(1:3);

%% Lab 2.B2: Dilution of precision
disp('DOPS')
% Qxx is the confidence matrix 
Qxx_4_sats = inv(A_4_sats'*A_4_sats);
Qxx_7_sats = inv(A_7_sats'*A_7_sats);

[pdop_4_sats, hdop_4_sats, vdop_4_sats, gdop_4_sats] = dop(Qxx_4_sats, r_4_sats_corrected)
[pdop_7_sats, hdop_7_sats, vdop_7_sats, gdop_7_sats] = dop(Qxx_7_sats, r_7_sats_corrected);
