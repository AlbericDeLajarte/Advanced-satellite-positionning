function product = lorentz_product(g, h)
M = eye(4,4);
M(4,4) = -1;
%{
disp('size of g')
disp(size(g))
g
disp('size of h')
disp(size(h))

disp('size of g prime')
disp(size(g'))

disp('size of M')
disp(size(M))
%}
product = (g')*M*h;
end