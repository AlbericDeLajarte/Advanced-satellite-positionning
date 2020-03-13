function [r, b] = solve_equation(B, alpha, e)
% Create temporary variable for speed
temp1 = B\e;
temp2 = B\alpha;

% find coefficient of quadratic equation ax^2 + bx + c = 0
a = lorentz_product(temp1, temp1);
b = 2*( lorentz_product(temp1, temp2) -1);
c = lorentz_product(temp2, temp2);

% Find two possible solution for the quadratic equation
lambda1 = (-b + sqrt(b^2 - 4*a*c))/(2*a);
lambda2 = (-b - sqrt(b^2 - 4*a*c))/(2*a);

% Find solution of bancroft problem
M = eye(4,4);
M(4,4) = -1;

result1 = M*B\(lambda1*e + alpha);
result2 = M*B\(lambda2*e + alpha);

% Keep the solution which is closer to Earth Center (Receiver is on the ground, not in Space)
if norm(result1(1:3)) > norm(result2(1:3))
    
    r = result2(1:3);
    b = result2(4);
    
else
    
    r = result1(1:3);
    b = result1(4);
    
end
