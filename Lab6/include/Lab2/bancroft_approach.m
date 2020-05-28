function [r, b, corrected_ecef, corrected_pseudoranges] = bancroft_approach(tow, sat_nums, we, pseudoranges, file)
%{
 This function computes the coordinates of a receiver given a certain nb of satellite
 ephemerides and corresponding pseudoranges, using the bancroft approach
%} 

% c = Speed of light
c = 299792458; %[m/s]
k = length(sat_nums);
%% Correction of pseudoranges with SV clock error dtk:
dtks = zeros(1,k);
taus = zeros(1,k);
% Approximation of the travel times:
taus = pseudoranges/c;

% Read the ephemerides
%[ephm, info, ~] = getrinexephGal();
[ephm, info, ~] = getrinexephGal(file);
ecef_matrix = zeros(k, 3);
parsed_matrix = zeros(size(ephm,1), k);
% parsed_ephm  is a len(ephemerides) x k matrix 
% ecef_matrix is a k x 3 matrix

toe_index = find(strcmp(info, 'toe'));
af0_index = find(strcmp(info, 'af0'));
af1_index = find(strcmp(info, 'af1'));
af2_index = find(strcmp(info, 'af2'));

for i = 1:k
    ti = tow - taus(i);
    [~, ecef_coord, parsed_ephm] = eci_and_ecef_coord(ti, sat_nums(i), we, ephm, info);
    ecef_matrix(i,:) = ecef_coord;
    parsed_matrix(:, i) = parsed_ephm;
    % we can find af0, af1, af2 and toe in the ephemerides 
    af0 = parsed_ephm(af0_index);
    af1 = parsed_ephm(af1_index);
    af2 = parsed_ephm(af2_index);
    toe = parsed_ephm(toe_index);
    
    dtks(i) = af0 + af1*(ti-toe) + af2*(ti-toe)^2;
end

% Having a first value for dtks, we could stop, but we can actually refine
% the values of dtk
for i = 1:k
    ti = tow - taus(i) - dtks(i); 
    [~, ecef_coord, parsed_ephm] = eci_and_ecef_coord(ti, sat_nums(i), we, ephm, info);
    ecef_matrix(i,:) = ecef_coord;
    parsed_matrix(:, i) = parsed_ephm;
    % we can find af0, af1, af2 and toe in the ephemerides 
    af0 = parsed_ephm(af0_index);
    af1 = parsed_ephm(af1_index);
    af2 = parsed_ephm(af2_index);
    toe = parsed_ephm(toe_index);
   
    dtks(i) = af0+af1*(ti-toe)+ af2*(ti-toe)^2 ;
end
% We can finally correct the pseudoranges: P = P' +c*dtk
corrected_pseudoranges = pseudoranges + dtks*c;


%% Correction for Earth rotation: 
worst_delay = 0.072; % [s]
corrected_ecef = zeros(k, 3); %k x 3 matrix
for i = 1:k
   corrected_ecef(i, :) = correction_Earth_rotation(ecef_matrix(i,:)', worst_delay)'; 
end
%{
disp('ecef without Earth correction = ')
disp(ecef_matrix)
disp('ecef corrected with Earth rotation, using worst delay = ')
disp(corrected_ecef)
%}

%% Apply Bancroft
% r is a vector containing receiver coordinates
% b is the receiver clock bias c*dti
[r, b] = bancroft(corrected_ecef, corrected_pseudoranges');

%% Now we can compute a better range (geometric distance) for more accurate Earth rotation, for each satellite k
for i = 1:k
    range = compute_range(r, ecef_matrix(i, :)); % new travel time
    delay = range/c;
    corrected_ecef(i, :) = correction_Earth_rotation(ecef_matrix(i,:)', delay)';
end
%{
disp('ecef corrected with Earth rotation, using smaller delay = ')
disp(corrected_ecef)
%}
%% Finally we re-apply Bancroft:
[r, b] = bancroft(corrected_ecef, corrected_pseudoranges');

end


