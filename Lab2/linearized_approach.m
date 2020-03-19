function [deltas, A] = linearized_approach(r_0, b_0, ecef_matrix, pseudoranges)
%% Arguments:
% r_0 = [X0, Y0, Z0]T is the receiver approximate coordinates, 3x1 matrix
% b_0 is a scalar, approximate receiver clock bias

%% Construction of matrix A and matrix l
k = length(pseudoranges);
A = zeros(k, 3);
l = zeros(k, 1);


for i = 1:k
    rho = compute_range(ecef_matrix(i,:), r_0');
    A(i,:) = -(ecef_matrix(i,:) - r_0');
    A(i,:)= A(i,:)/rho;
    P0 = rho;
    l(i) = pseudoranges(i) - P0;
end
A = [A, ones(k, 1)];

%% Solve system:
deltas = (A'*A)\(A'*l)

end


