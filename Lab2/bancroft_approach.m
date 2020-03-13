function [] = bancroft_approach(t, sat_nums, we, pseudoranges)
% Speed of light
c = 299792458; %[m/s]

%% Correction of pseudoranges with SV clock error dtk: 
% Propagation time tau
% ???
% say for now:
corrected_pseudoranges = values(pseudoranges);

%% Computation of ECI and ECEF coordinates of given satellites:
% should we change t??? t = t - tau
[~, ecef_matrix] = eci_and_ecef_coordinates(t, sat_nums, we);

%% Correction for Earth rotation: 
worst_delay = 0.072; %s
corrected_ecef = correction_Earth_rotation(ecef_matrix, worst_delay);

%% Apply Bancroft
if len(sat_nums) == 4
    % r is a vector containing receiver coordinates
    % b is the receiver clock bias c*dti
    [r, b] = bancroft_4_Sat(corrected_ecef, corrected_pseudoranges');


    %% Now we can compute a better range for more accurate Earth rotation correction:
    delay = ;
    corrected_ecef = correction_Earth_rotation(corrected_ecef, delay);


    %% Re-apply Bancroft:
    [r, b] = bancroft_4_Sat(corrected_ecef, corrected_pseudoranges');
else
    
end


