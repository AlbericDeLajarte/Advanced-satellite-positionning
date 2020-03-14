function [r, b, ecef_matrix] = bancroft_approach(t, sat_nums, we, pseudoranges)
% Speed of light
c = 299792458; %[m/s]

%% Correction of pseudoranges with SV clock error dtk:
dtks = zeros(len(sat_nums));
tis = zeros(len(sat_nums));
taus = zeros(len(sat_nums));

% To compute a dtk we need ti and toe
% To compute ti we need propagation/travel time tau
% First approximation of tis: 
tis = pseudoranges/c;

for i = 1:len(sat_nums)
    af0 = ;
    af1 = ;
    af2 = ;
    toe = ;
    ti = ;
    dtks(i) = af0+af1(tis(i)-toe)+ af2(tis(i)-toe)^2 ;
end

% Propagation time tau
% ???
corrected_pseudoranges = values(pseudoranges) + dtks;

%% Computation of ECI and ECEF coordinates of given satellites:
% we compute for time tk which is = reception time - transmission time 
tk = ti - tau;
[~, ecef_matrix] = eci_and_ecef_coordinates(tk, sat_nums, we);
% ecef_matrix is a len(sat_nums) x 3 matrix

%% Correction for Earth rotation: 
worst_delay = 0.072; %s
corrected_ecef = correction_Earth_rotation(ecef_matrix, worst_delay);

%% Apply Bancroft
if len(sat_nums) == 4
    % r is a vector containing receiver coordinates
    % b is the receiver clock bias c*dti
    [r, b] = bancroft_4_Sat(corrected_ecef, corrected_pseudoranges');


    %% Now we can compute a better range for more accurate Earth rotation, for each satellite k
    for i = 1:len(sat_nums)
        range = compute_range(r, ecef_matrix(i, :));   
        delay = range/c;
        corrected_ecef(i, :) = correction_Earth_rotation(corrected_ecef, delay);
    end


    %% Re-apply Bancroft:
    [r, b] = bancroft_4_Sat(corrected_ecef, corrected_pseudoranges');
else
    % Same but with bancroft_overdetermined     
end


