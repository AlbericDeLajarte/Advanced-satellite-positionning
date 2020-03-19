function [deltas, A] = linearized_approach(r_0, b_0, sat_nums, pseudoranges, ecef_matrix)
%% Arguments:
% r_0 = [X0, Y0, Z0]T is the receiver approximate coordinates
% b_0 is a scalar, approximate receiver clock bias


%% Construction of matrix A and matrix l
k = length(sat_nums);
A = zeros(k, 3);
l = zeros(k, 1);
% concat:
r0 = [r_0', b_0];

for i = 1:k
    disp(r_0')
    rho = compute_range(ecef_matrix(i,:), r_0');
    A(i,:) = -(ecef_matrix(i,:) - r_0');
    A(i,:)= A(i,:)/rho;
    P0 = rho;
    l(i) = pseudoranges(i) - P0;
end
A = [A, ones(k, 1)];

%% Solve system:
deltas = (A'*A)\(A'*l');

end


