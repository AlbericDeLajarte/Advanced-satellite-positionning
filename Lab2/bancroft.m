function [r, b] = bancroft(r_k, P_k)
% r_k : k x 3 matrix, k being the number of satellites 
% P_k : k x 1  matrix
B = [r_k, P_k]; %k x 4 matrix
[k, ~] = size(r_k); 
new_B = zeros(k,4);
e = ones([1, k])';
alpha = zeros(k,1); % k x 1  matrix


for i = 1:k
    alpha(i) =  0.5*lorentz_product([r_k(i, :), P_k(i)]', [r_k(i, :), P_k(i)]');
end

if k > 4
    Bplus = (B'*B)\(B');
    new_B = Bplus;
else 
    new_B = inv(B);
end

[r, b] = solve_equation(new_B, alpha, e);
end