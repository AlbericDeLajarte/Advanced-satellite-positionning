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
tis = pseudoranges/c; % -> que vaut tau? 

% parsed_ephm contains one column for each satellite, and as many lines as
% the number of information contained in ephemerides 
[parsed_ephm, ~] = parse_matrix(t, sat_nums);
for i = 1:len(sat_nums)
    % we can find af0, af1, af2 and toe in the ephemerides 
    af0 = parsed_ephm(2,i);
    af1 = parsed_ephm(3,i);
    af2 = parsed_ephm(4,i);
    toe = parsed_ephm(13,i);
    ti = tis(i);
    dtks(i) = af0+af1(ti-toe)+ af2(ti-toe)^2 ;
end
% First correction ? 
corrected_pseudoranges = values(pseudoranges) + dtks*c; % P = P' +c*dtk 
tis = corrected_pseudoranges/c - dtks;
for i = 1:len(sat_nums)
    % we can find af0, af1, af2 and toe in the ephemerides 
    af0 = parsed_ephm(2,i);
    af1 = parsed_ephm(3,i);
    af2 = parsed_ephm(4,i);
    toe = parsed_ephm(13,i);
    ti = tis(i);
    dtks(i) = af0+af1(ti-toe)+ af2(ti-toe)^2 ;
end
corrected_pseudoranges = values(pseudoranges) + dtks*c; % P = P' +c*dtk
% Propagation time tau
% ??? init � 0.072 


%% Computation of ECI and ECEF coordinates of given satellites:
% we compute for time tk which is = reception time - transmission time 
tk = ti - tau;
[~, ecef_matrix] = eci_and_ecef_coordinates(tk, sat_nums, we);
% ecef_matrix is a len(sat_nums) x 3 matrix

%% Correction for Earth rotation: 
worst_delay = 0.072; %s
% first argument of correction_Earth_rotation must have columns of coord 
corrected_ecef = correction_Earth_rotation(ecef_matrix', worst_delay);

%% Apply Bancroft
if len(sat_nums) == 4
    % r is a vector containing receiver coordinates
    % b is the receiver clock bias c*dti
    [r, b] = bancroft_4_Sat(corrected_ecef, corrected_pseudoranges');

    %% Now we can compute a better range for more accurate Earth rotation, for each satellite k
    for i = 1:len(sat_nums)
        range = compute_range(r, ecef_matrix(i, :));   
        delay = range/c;
        % Plut�t: 
        corrected_ecef(i, :) = correction_Earth_rotation(ecef_matrix(i,:)', delay);
    end

    %% Re-apply Bancroft:
    [r, b] = bancroft_4_Sat(corrected_ecef, corrected_pseudoranges');
else
    % Same but with bancroft_overdetermined     
end


