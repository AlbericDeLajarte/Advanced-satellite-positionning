function [reduced_N, reduced_b] = compute_normals(dd)

Lab6Params;

%% Step 1: form the normals 
A = [1    0    0;
     1    0    0;
     1 lambda1 0;
     1    0  lambda2;];
P = diag(std_vec.^-2);
N = A'*P*A; % should be 3x3 matrix
b = A'*P*dd; % should be 3x1 column vector 

%% Step 2: reduction of N
% Matrix N is divided as [A B;
%                         C D]
A = N(1,1);
B = N(1,2:3);
C = N(2:3,1); 
D = N(2:3,2:3);
% matrix dd is divided as [b1;
%                          b2]
b1 = b(1,1);
b2 = b(2:3,1);

% Construct modified N and modified b
reduced_N = (-C/A)*B + D; 
reduced_b = b2 - (C/A)*b1; %2x1 vector

% Step 3 : least square solution over one epoch
%ambiguity_vector = new_N\new_b;


