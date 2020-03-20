function product = lorentz_product(g, h)
%{
This function computes the lorentz product of 2 matrices g and h 
%}
M = eye(4,4);
M(4,4) = -1;

product = (g')*M*h;
end