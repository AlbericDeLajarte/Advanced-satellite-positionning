function [N1, N2] = compute_normals(dd, epoch)

Lab6Params;

%% Step 1:
A = [1    0    0;
     1    0    0;
     1 lambda1 0;
     1    0  lambda2;];
P = diag(std.^-2);
N = A'*P*A; % should be 3x3 matrix
b = A'*P*dd; % should be 3x1 column vector 

%% Step 2:
% Matrix N is divided as [A B;
%                         C D]
A = N(1,1);
B = N(1,2:3);
C = N(2:3,1); 
D = N(2:3,2:3);

b1 = b(1,1);
b2 = b(2:3,1);
% Construct modified N and modified b: TODO 
% matrix dd is divided as [b1;
%                          b2]

% [N1 N2]' = D'*b2

ambiguity_vector = D'*b2;
N1 = ambiguity_vector(1);
N2 = ambiguity_vector(2); 

