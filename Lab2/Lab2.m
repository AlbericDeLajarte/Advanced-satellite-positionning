%% Lab 2
%% General informations
sat_nums_4_sats = [2 5 8 12];
sat_nums_7_sats = [2 5 8 11 12 24 25];
t = 225445.0; % Time of week [s]
c =299792458; % [m/s]
we = 7.2921151467e-5; %[m/s]

% Pseudoranges:
SatNumsSet = [11, 2, 12, 8, 24, 3, 25, 5];
pseudoRangesSet = [24915794.070, 26145267.471, 24167301.217, 24180868.178, ... 
    23029783.450, 24860231.781, 22758409.968,  26881228.000];
pseudoranges_all = containers.Map(SatNumsSet,pseudoRangesSet);

% A bit ugly
pseudoranges_7_sats = remove(pseudoranges_all, 3);
pseudoranges_4_sats = remove(pseudoranges_all, 11);
pseudoranges_4_sats = remove(pseudoranges_all, 24);
pseudoranges_4_sats = remove(pseudoranges_all, 25);

%% Lab 2.A: find location of Galileo receiver's antenna using Bancroft algorithm
[r_4_sats, b_4_sats, ecef_4_sats] = bancroft_approach(t, sat_nums_4_sats, we, pseudoranges_4_sats);
[r_7_sats, b_7_sats, ecef_7_sats] = bancroft_approach(t, sat_nums_7_sats, we, pseudoranges_7_sats);


%% Lab 2.B1: find location of Galileo's receiver's antenna using linearization approach
[deltas_4_sats, A_4_sats] = linearized_approach(r_4_sats, b_4_sats, pseudoranges_4_sats, ecef_4_sats);
[deltas_7_sats, A_7_sats] = linearized_approach(r_7_sats, b_7_sats, pseudoranges_7_sats, ecef_7_sats);

%% Lab 2.B2: Dilution of precision
