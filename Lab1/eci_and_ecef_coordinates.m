function [] = eci_and_ecef_coordinates(t_oe)

% Read ephemerid file 
[ephm info units] = getrinexephGal;

% Keep only satellites asked:
sat_nums = [2, 5, 8, 11, 12, 24, 25];
sat_nums_ephemerides = ephm(1,:);
% Then for each colum provided for one sat, we only keep
% the one with closest 

toe_index = 13;

for sat_index = 1:length(sat_nums)
    % First we keep the indices of the columns
    sat_column_indices = find(sat_nums_ephemerides == sat_nums(sat_index))
    closest = 0;
    index_of_closest = 0
    for sat_colum_index = 1:sat_column_indices
        if ephm(toe_index, sat_colum_index) - t_oe < closest
            closest = toe
        
        
end
