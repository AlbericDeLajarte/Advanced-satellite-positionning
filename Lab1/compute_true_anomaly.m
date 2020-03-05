function f = compute_true_anomaly(E, ecc)
%% This function computes the true anomaly
%%
num = sqrt(1-ecc^2)*sin(E);
denom = cos(E)-ecc;
f = atan2(num,denom);

end

