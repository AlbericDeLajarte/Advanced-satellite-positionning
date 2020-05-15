%% Compute the double difference for pair of sat (b, k)
function [double_diff_b_k] = compute_double_diff(sat_b, sat_k, master_obs, rover_obs, epoch)
%% Arguments:
% sat_b: the base satellite
% sat_k: another satellite 
% master_obs: master observations to all satellites
% rover_obs: rover observations to all satellites

%% Computation of the double difference:

PRN_index = 2;
m_to_b = master_obs(find(master_obs(:, PRN_index) == sat_b), :, epoch);
r_to_b = rover_obs(find(master_obs(:, PRN_index) == sat_b), :, epoch);
m_to_k = master_obs(find(master_obs(:, PRN_index) == sat_k), :, epoch);
r_to_k = rover_obs(find(master_obs(:, PRN_index) == sat_k), :, epoch);

single_diff_to_b = m_to_b - r_to_b;
single_diff_to_k = m_to_k - r_to_k;
double_diff_b_k = single_diff_to_b - single_diff_to_k;

end

