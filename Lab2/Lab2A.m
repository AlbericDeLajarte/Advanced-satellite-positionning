%% Lab 2.A
function [rcv_position] = lab2A()
    sat_nums1 = [2 5 8 12];
    sat_nums2 = [2 5 8 11 12 24 25];
    t = 225445.0; % Time of week [s]
    c =299792458; % [m/s]
    we = 7.2921151467e-5; %[m/s]

    % Pseudoranges:
    SatNumsSet = [11, 2, 12, 8, 24, 3, 25, 5];
    pseudoRangesSet = [24915794.070, 26145267.471, 24167301.217, 24180868.178, ... 
        23029783.450, 24860231.781, 22758409.968,  26881228.000];
    pseudoranges = containers.Map(SatNumsSet,pseudoRangesSet);

    % Find location of Galileo receiver's antenna using Bancroft algorithm
    rcv_position_4 = bancroft_approach(t, 
