function sat_number = find_PRN_code(PRN_number, fs, fc, data_length, sat_signal, plotOption)

% This function compute the cross correlation of the received signal from
% the satellite "sat_signal" with different PRN number specified in "PRN_number"
%
%   Inputs :
%       PRN_number      - list of PRN number 
%       fs              - sampling frequency            [Hz]
%       fc              - chipping rate                 [chip/s]
%       data_length     - length of the code            [ms]
%       sat_signal      - received signal
%       plotOption      - option to plot all the correlation
%
%   Output :
%       sat_number      - list of the satellite number detected in the
%       signal


if(nargin < 6)
    plotOption = "noPlot";
end

maxPNR = zeros(1, 10);
sat_number = [];
for PRN = PRN_number
    CA_code = generateGoldCodeSampled (PRN, fs, fc, data_length);
    maxPNR(PRN) = max(computeCorrelation(CA_code, sat_signal));
   
    % In case of correlation, the max of correlation should be equal to the length of the signal
    if(maxPNR(PRN) > 0.8*length(CA_code)) 
        sat_number = [sat_number, PRN];
    end
end
   
if(plotOption == "showCorr")
    figure(1);
    bar(maxPNR)
    xlabel("Satellite number");
    ylabel("Correlation");
    title("Maximum of the cross correlation of PRN number 1 to 10 with mistery signal")
end


end