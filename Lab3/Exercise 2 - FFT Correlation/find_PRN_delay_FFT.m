function delay = find_PRN_delay_FFT(PRN, fs, fc, data_length, sat_signal, plotOption, i)

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
    plotOption = 'noPlot';
end

CA_code = generateGoldCodeSampled (PRN, fs, fc, data_length);
FFTCorr = FFTCorrelation(CA_code, sat_signal);

if(strcmp(plotOption,'showCorr') == 1)
    figure(i);
    plot(FFTCorr)
    xlabel('Sample shift');
    ylabel('Correlation');
    title(strcat('Cross correlation of PRN number ', {' '} ,num2str(PRN), {' '}, ' with the received signal')); 
end 
[~, indice] = max(FFTCorr);
delay = indice*(1/fs);

end