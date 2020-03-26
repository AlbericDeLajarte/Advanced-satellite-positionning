function delay = find_PRN_delay(PRN, fs, fc, data_length, sat_signal, plotOption)

% This function finds the delay between a PRN code with number "PRN" and a
% received signal "sat_signal"
%
%   Inputs :
%       PRN             - PRN number of a satellite
%       fs              - sampling frequency            [Hz]
%       fc              - chipping rate                 [chip/s]
%       data_length     - length of the code            [ms]
%       sat_signal      - received signal
%       plotOption      - option to plot all the correlation
%
%   Output :
%       delay           - delay between the two signals in seconds
% 

if(nargin < 6)
    plotOption = "noPlot";
end

CA_code = generateGoldCodeSampled (PRN, fs, fc, data_length);
CA_code_corr = computeCorrelation(CA_code, sat_signal);

if(plotOption == "showCorr")
    figure(1);
    plot(CA_code_corr)
    xlabel("Sample shift");
    ylabel("Correlation");
    title("Cross correlation of PRN number " + PRN + " with the received signal");
end
[~, indice] = max(CA_code_corr);
delay = indice*(1/fs);

end