%% Parameters for lab6

all_sats_nb = [2, 3, 5, 8, 11, 12, 24, 25];
file_labels = ["TOW", "PRN", "CodeE1", "CodeE5a", "PhaseE1", "PhaseE5a"]; % datam and datar files format

% https://galileognss.eu/galileo-frequency-bands/
F1 = 1575.42e+6; % E1 frequency [MHz] 
F2 = 1176.45e+6; % E5a frequency [MHz]
c = 299792458;  % Speed of light  [m/s] 

std_vec = [0.5 0.5 0.01 0.01];
% wavelenghts:
lambda1 = c/F1; 
lambda2 = c/F2;

f1 = 154;
f2= 115;

we = 7292115e-11; % Earth angular rotation [rad/s]
worst_delay = 0.072; % [s]

