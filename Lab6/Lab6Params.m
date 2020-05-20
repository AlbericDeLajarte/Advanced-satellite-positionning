
all_sats_nb = [2, 3, 5, 8, 11, 12, 24, 25];
base_sat_nb = 8; % assigned base satellite 
sats_nb = all_sats_nb(all_sats_nb~=base_sat_nb);
file_labels = ["TOW", "PRN", "CodeE1", "CodeE5a", "PhaseE1", "PhaseE5a"]; % datam and datar files format

% https://galileognss.eu/galileo-frequency-bands/
F1 = 1575.42e+6; % E1 frequency [MHz] 1.54e+09 ? 
F2 = 1176.45e+6; % E5a frequency [MHz] 1.15e+09 ? 
c = 299792458;  % Speed of light  [m/s] 

std_vec = [0.5 0.5 0.01 0.01];
lambda1 = c/F1;
lambda2 = c/F2;