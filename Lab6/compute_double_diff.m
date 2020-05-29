function [double_diff_b_k] = compute_double_diff(sat_b, sat_k, master_obs, rover_obs, epoch)
%{
    This function computes the double difference for pair of sat (b, k)
    Arguments:
    - sat_b: the base satellite number
    - sat_k: another satellite number, k!=b
    - master_obs: master observations to all satellites
    - rover_obs: rover observations to all satellites
    - epoch: the epoch at which we look at the measurements
%}
%% Computation of the double differences of the 4 measurements:
PRN_index = 2;

% Take master and rover measurements for satellites b and k, for all epochs
m_to_b_all = master_obs(find(master_obs(:, PRN_index) == sat_b), :);
r_to_b_all = rover_obs(find(rover_obs(:, PRN_index) == sat_b), :);
m_to_k_all = master_obs(find(master_obs(:, PRN_index) == sat_k), :);
r_to_k_all = rover_obs(find(rover_obs(:, PRN_index) == sat_k), :);

% Compute single difference, for the epoch
single_diff_to_b = m_to_b_all(epoch, 3:6) - r_to_b_all(epoch, 3:6);
single_diff_to_k = m_to_k_all(epoch, 3:6) - r_to_k_all(epoch, 3:6);

% Compute double difference, for the epoch
double_diff_b_k = single_diff_to_b - single_diff_to_k;

end

