function [rho] = compute_range(r_1, r_2)
% built-in function in matlab? For norm ? 
% rho = norm(r_1 - r_2)
rho = sqrt((r_1(1) - r_2(1))^2 + (r_1(2) - r_2(2))^2 + (r_1(3) - r_2(3))^2);
end