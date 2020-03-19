function [r, b, ecef_matrix, corrected_pseudoranges] = bancroft_approach(tow, sat_nums, we, pseudoranges)
% Speed of light
c = 299792458; %[m/s]
k = length(sat_nums)
disp(pseudoranges)
%% Correction of pseudoranges with SV clock error dtk:
dtks = zeros(1,k);
taus = zeros(1,k);
% Approximation of the travel times:
taus = pseudoranges/c

% Computation of ECI and ECEF coordinates of given satellites:
[~, ecef_matrix, parsed_ephm, info] = eci_and_ecef_coordinates(tow, sat_nums, we);
% parsed_ephm  is a len(ephemerides) x len(sat_nums) matrix 
% ecef_matrix is a len(sat_nums) x 3 matrix

toe_index = find(strcmp(info, 'toe'));
af0_index = find(strcmp(info, 'af0'));
af1_index = find(strcmp(info, 'af1'));
af2_index = find(strcmp(info, 'af2'));

for i = 1:k
    % we can find af0, af1, af2 and toe in the ephemerides 
    af0 = parsed_ephm(af0_index,i);
    af1 = parsed_ephm(af1_index,i);
    af2 = parsed_ephm(af2_index,i);
    toe = parsed_ephm(toe_index,i);
    ti = tow - taus(i); 
    dtks(i) = af0 + af1*(ti-toe) + af2*(ti-toe)^2;
end
% Having a first value for dtks, we could stop, but we can actually refine
% the values of dtk
for i = 1:k
    % we can find af0, af1, af2 and toe in the ephemerides 
    af0 = parsed_ephm(af0_index,i);
    af1 = parsed_ephm(af1_index,i);
    af2 = parsed_ephm(af2_index,i);
    toe = parsed_ephm(toe_index,i);
    ti = tow - taus(i) - dtks(i);
    dtks(i) = af0+af1*(ti-toe)+ af2*(ti-toe)^2 ;
end
% We can finally correct the pseudoranges: P = P' +c*dtk
corrected_pseudoranges = pseudoranges + dtks*c


%% Correction for Earth rotation: 
worst_delay = 0.072; %s
% first argument of correction_Earth_rotation must have columns of coord

corrected_ecef = zeros(k, 3); %k x 3 matrix
for i = 1:k
   corrected_ecef(i, :) = correction_Earth_rotation(ecef_matrix(i,:)', worst_delay)'; 
end
ecef_matrix(1,:)
corrected_ecef(1,:)

%% Apply Bancroft
% r is a vector containing receiver coordinates
% b is the receiver clock bias c*dti
[r, b] = bancroft(corrected_ecef, corrected_pseudoranges')

%% Now we can compute a better range (geometric distance) for more accurate Earth rotation, for each satellite k
for i = 1:k
    range = compute_range(r, ecef_matrix(i, :)); % new travel time
    delay = range/c;
    corrected_ecef(i, :) = correction_Earth_rotation(ecef_matrix(i,:)', delay)';
end

%% Re-apply Bancroft:
disp('we reapply')
[r, b] = bancroft(corrected_ecef, corrected_pseudoranges')

end


