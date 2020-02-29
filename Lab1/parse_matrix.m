function [parsed_matrix, info] = parse_matrix(t_oe, sat_nums)
% Read ephemerid file 
[ephm, info, units] = getrinexephGal();

% Keep only satellites asked:
sat_nums_ephemerides = ephm(1,:); 

toe_index = find(strcmp(info, 'toe'));
% parsed_matrix will contain the ephemerides values for relevant satellites
parsed_matrix = zeros(size(ephm,1), length(sat_nums));
% parsed_column_indices contains the selected colum index for each satellite
parsed_column_indices = zeros(1,length(sat_nums));

for sat_index = 1:length(sat_nums)
    % First we keep all the indices of the columns corresponding to specific
    % sat
    sat_column_indices = find(sat_nums_ephemerides == sat_nums(sat_index));
    closest = Inf;
    closest_index = 0;
    % Then we loop over those colums, and check the time of week that is
    % the closest to input t_oe (and before!)
    for i = 1:length(sat_column_indices)
        time_diff =  t_oe - ephm(toe_index, sat_column_indices(i));
        if time_diff < closest && time_diff > 0
            closest = time_diff;
            closest_index = sat_column_indices(i);
        end
    end
    % We now have the index of the column to keep for given sat, we can
    % thus fill the parsed matrix
    parsed_column_indices(sat_index) = closest_index;
    parsed_matrix(:,sat_index) = ephm(:, closest_index);
    
end
