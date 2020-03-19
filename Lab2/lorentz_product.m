function product = lorentz_product(g, h)
M = eye(4,4);
M(4,4) = -1;

product = (g')*M*h;
end