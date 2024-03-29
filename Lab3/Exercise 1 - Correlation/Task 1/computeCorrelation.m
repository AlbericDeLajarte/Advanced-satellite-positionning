%  Advanced Satellite Positioning - Lab 3: Acquisition of GPS signal
%  Spring 2015
% Last revison: Gabriel Laupr� 22.03.2018

function corr = computeCorrelation(signal_1, signal_2)

% if(length(signal_1) >= length(signal_2) )
%     
%     k = length(signal_1);
%     corr = zeros(1, k);
%     signal_2 = [signal_2, zeros(1, length(signal_1)- length(signal_2))];
%     for i = 0:k-1
%         corr(i+1) = sum(signal_2.*circshift(signal_1, i));
%     end
% else
%     k = length(signal_2);
%     corr = zeros(1, k);
%     signal_1 = [signal_1, zeros(1, length(signal_2)- length(signal_1))];
%     for i = 0:k-1
%         corr(i+1) = sum(signal_1.*circshift(signal_2, i));
%     end
% end

if(length(signal_1) == length(signal_2) )
    k = length(signal_1);
    corr = zeros(1, k);
else
    k = 0;
    disp("Error: the signals should have the same length");
end

for i = 0:k-1
    corr(i+1) = sum(signal_1.*circshift(signal_2, i));
end
    

end
