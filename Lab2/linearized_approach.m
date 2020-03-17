function [deltas, A] = linearized_approach(r_0, b_0, sat_nums, pseudoranges, ecef_matrix)
%% Arguments:
% r_0 = [X0, Y0, Z0] is the receiver approximate coordinates
% b_0 is a scalar, approximate receiver clock bias


%% Construction of matrix A and matrix l
nb_of_observations = len(sat_nums);
A = zeros(nb_of_observations, 3);
l = zeros(nb_of_observations, 1);
% concat:
r0 = [r_0, b_0];

for i = 1:nb_of_observations
    rho = compute_range(ecef_matrix(i,:), r0);
    A(i,:) = -(ecef_matrix(i,:) - r0);
    A(i,:)= A(i,:)/rho;
    % for l, take bias into account? 
    P0 = rho - b_0;
    l(i) = pseudoranges(i) - P0;
end
A = [A, ones(nb_of_observations, 1)];

%% Solve system:
deltas = (A'*A)\(A'*l');

end


