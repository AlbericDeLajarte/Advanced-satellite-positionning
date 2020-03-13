function [r, b] = bancroft_overdetermined(r_k, P_k)
% define matrices
B = [r_k, P_k];
[nbOfSats, ~] = size(r_k); 
e = ones([1, nbOfSats]);
alpha = zeros(nbOfSats);

for i = 1:nbOfSats
    alpha(i) =  0.5*lorentz_product( [r_k(i, :), P_k(i)], [r_k(i, :), P_k(i)] );   
end

Bplus = (B'*B)\B';

[r, b] = solve_equation(Bplus, alpha, e);
end