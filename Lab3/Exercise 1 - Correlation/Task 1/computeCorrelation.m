%  Advanced Satellite Positioning - Lab 3: Acquisition of GPS signal
%  Spring 2015
% Last revison: Gabriel Laupré 22.03.2018

function corr = computeCorrelation(signal_1, signal_2)

if(length(signal_1) == length(signal_2) )
    
    k = length(signal_1);
else
    k=0;
    disp("Error: the two signals should have the same length");
end

corr = zeros(1, k);
for i = 0:k-1
    corr(i+1) = sum(signal_1.*circshift(signal_2, i));
end

end
