function [ acqResults ] = acquisition_1ms( settings, longSignal )

% Function performs acquisition on the collected "data" for the SVN
% list specified in settings.acqSatelliteList. The function saves code phase
% and frequency of the detected signals in the "acqResults" structure.
% In addition the function can plot the acquisition results (CAF).
%
% acquisition_PRN_student( PRN, settings, longSignal )
%
%   Inputs:
%       PRN           - PRN number of the satellite that want to search for
%       longSignal    - 11 ms of raw signal from the front-end
%       settings      - Receiver settings. Provides information about
%                       sampling and intermediate frequencies and other
%                       parameters including the list of the satellites to
%                       be acquired.
%   Outputs:
%       acqResults    - Function saves code phases and frequencies of the
%                       detected signals in the "acqResults" structure. The
%                       field "carrFreq" is set to 0 if the signal is not
%                       detected for the given PRN number.

%--------------------------------------------------------------------------
%                        SoftGNSS for ENV-542 Course v1.0
%                           (Based on SoftGNSS v3.0)
%
%   Copyright (C) Darius Plausinaitis and Dennis M. Akos
%   Written by Darius Plausinaitis and Dennis M. Akos
%   Based on Peter Rinder and Nicolaj Bertelsen
%
%   Modified by Vincenzo Capuanno, Miguel A. Ribot (ESPLAB-EPFL), 2014.
%   Revised by Gariel Laupre (TOPO-EPFL), 2020
%
%--------------------------------------------------------------------------
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
% USA.
%--------------------------------------------------------------------------

%--- Initialize acqResults ------------------------------------------------
% Carrier frequencies of detected signals
acqResults.carrFreq     = zeros(1, 32);
% C/A code phases of detected signals
acqResults.codePhase    = zeros(1, 32);
% Correlation peak ratios of the detected signals
acqResults.peakMetric   = zeros(1, 32);

% Find number of samples per spreading code
samplesPerCode = round(settings.samplingFreq / ...
    (settings.codeFreqBasis / settings.codeLength));

% Number of the frequency bins for the given acquisition band (acqFreqstep
% Hz steps).
% Note:  numberOfFrqBins depends on the acqFreqstep selected in
%        settings
numberOfFrqBins = round(settings.acqSearchBand/settings.acqFreqstep) + 1;

%--- Initialize arrays to speed up the code -------------------------------
% Search results of all frequency bins and code shifts
results     = zeros(numberOfFrqBins, samplesPerCode);

% Carrier frequencies of the frequency bins
frqBins     = zeros(1, numberOfFrqBins);


% Create a 1msec vector of data to correlate with
signal1 = longSignal(1 : samplesPerCode);


fprintf('(');
figure_number = 0;
% Perform search for all listed PRN numbers ...
for PRN = settings.acqSatelliteList
     
    %% Step 2. Generate the C/A code and sample them according to the sampling freq.
    caCode = generateGoldCodeSampled(PRN, settings.samplingFreq, settings.codeFreqBasis , settings.codeLength/settings.codeFreqBasis*1e3 );
        
    %--- Make the correlation for whole frequency band (for all freq. bins)
    for frqBinIndex = 1:numberOfFrqBins
        
        % Generate carrier wave frequency grid (acqFreqstep kHz step)
        frqBins(frqBinIndex) = settings.IF - ...
            (settings.acqSearchBand/2) * 1e3 + ...
            settings.acqFreqstep * 1e3 * (frqBinIndex - 1);
        
        n = 0:(samplesPerCode-1);
        carrier_sin = sin(2*pi*frqBins(frqBinIndex)*n/settings.samplingFreq);
        carrier_cos = cos(2*pi*frqBins(frqBinIndex)*n/settings.samplingFreq);
        
        signal1_FFT = fft((carrier_cos + 1i*carrier_sin).*signal1);
        PRN_FFT = conj(fft(caCode));
        
        
        % #################################################################
        % TO BE COMPLETED BY THE STUDENTS
        % Most of your code should go here (Step 3 to 6):
		%  - generate carrier replicas to perform carrier removal (according 
		%    to tested frqBins(frqBinIndex) center frequency in Hz)
		%  - remove carrier from the signal
		%  - etc. as explained in handout
        % #################################################################

        
        % Store correlation results ------------
        results(frqBinIndex, :) = abs(ifft(signal1_FFT.*PRN_FFT)).^2;   % TO BE COMPLETED


    end % frqBinIndex = 1:numberOfFrqBins
    
    
    %% Look for correlation peaks in the results ==========================
    % Find the highest peak and compare it to the second highest peak
    % The second peak is chosen not closer than 1 chip to the highest peak

    %--- Find code phase and peak Sizeof the same correlation peak ---------------------
    peakSize          = max(results(:));
    [frequencyBinIndex, codePhase]         = find(results == peakSize); % TO BE COMPLETED
    
    
    %--- Find the correlation peak and the carrier frequency --------------
   


    %--- Use the secondPeak function provided to find the second 
    %    highest correlation peak in the same freq. bin ---
    [ secondPeakSize ] = secondPeak( results, frequencyBinIndex, codePhase, settings );
    
    %--- Store result -----------------------------------------------------
    acqResults.peakMetric(PRN) = peakSize/secondPeakSize;
    
    % If the result is above threshold, then there is a signal ...
    
    if (peakSize/secondPeakSize) > settings.acqThreshold
        
        % #################################################################
        % TO BE COMPLETED BY THE STUDENTS
        % Plot Cross-Ambiguity Function (CAF) 
        % Use mesh() function
        % #################################################################
        figure_number = figure_number+1;
        [delay_sample, freq_shift] = meshgrid(n, frqBins - settings.IF);
        
        figure(figure_number);
        mesh(delay_sample, freq_shift, results);
        colorbar;
        
        xlabel('delay [sample]');
        ylabel('Doppler shift [Hz]');
        zlabel('CAF');
        title("Cross Ambiguity Function for PRN = " + PRN);
        %--- Indicate PRN number of the detected signal -------------------
        fprintf('%02d ', PRN);
        
        %--- Save properties of the detected satellite signal -------------
        acqResults.carrFreq(PRN)  = settings.IF - ...
            (settings.acqSearchBand/2) * 1e3 + ...
             settings.acqFreqstep * 1e3 * (frequencyBinIndex - 1);
        
        acqResults.codePhase(PRN) = codePhase;
        
    else
        %--- No signal with this PRN --------------------------------------
        fprintf('. ');
    end   
    
end

%=== Acquisition is over ==================================================
fprintf(')\n');



