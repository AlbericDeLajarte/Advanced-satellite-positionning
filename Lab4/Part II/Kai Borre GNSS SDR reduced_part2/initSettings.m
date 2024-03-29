function settings = initSettings()
% Functions initializes and saves settings. Settings can be edited inside of
% the function, updated from the command line or updated using a dedicated
% GUI - "setSettings".  
%
% All settings are described inside function code.
%
% settings = initSettings()
%
%   Inputs: none
%
%   Outputs:
%       settings     - Receiver settings (a structure). 

%--------------------------------------------------------------------------
%                        SoftGNSS for ENV-542 Course v1.0 
%                           (Based on SoftGNSS v3.0)
% 
%   Copyright (C) Darius Plausinaitis
%   Written by Darius Plausinaitis
%
%   Modified by Vincenzo Capuanno, Miguel A. Ribot (ESPLAB-EPFL), 2014.
%
%--------------------------------------------------------------------------
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>
%--------------------------------------------------------------------------

%% Processing settings ====================================================
% Number of milliseconds to be processed used 36000 + any transients (see
% below - in Nav parameters) to ensure nav subframes are provided
settings.msToProcess        = 1000;        %[ms]

% Number of channels to be used for signal processing
settings.numberOfChannels   = 12;

% Coherent Integration time used in Acquisition:
settings.cohInt             = 10;            %[ms];

% Move the starting point of processing. Can be used to start the signal
% processing at any point in the data record (e.g. for long records). fseek
% function is used to move the file read point, therefore advance is byte
% based only. 
settings.skipNumberOfBytes     = 0;

%% Raw signal file name and other parameter ===============================
% This is a "default" name of the data file (signal record) to be used in
% the post-processing mode
settings.fileName           = ...
   '../../ENV542_GPS_CA_data_capture2.bin';
% Data type used to store one sample
settings.dataType           = 'int8';

% This file contains the ephemeris for the data recorded to make possible
% to compute the navigation solution with short tracking times:
settings.ephDatafile        = 'eph_data2.mat';

% Intermediate, sampling and code frequencies
settings.IF                 = 4.5e6;      %[Hz]
settings.samplingFreq       = 6.5e6;     %[Hz]
settings.codeFreqBasis      = 1.023e6;      %[Hz]

% Define number of chips in a code period
settings.codeLength         = 1023;

%% Acquisition settings ===================================================
% Skips acquisition in the script postProcessing.m if set to 1
settings.skipAcquisition    = 0;
% List of satellites to look for. Some satellites can be excluded to speed
% up acquisition
settings.acqSatelliteList   = 1:32;         %[PRN numbers]
% Band around IF to search for satellite signal. Depends on max Doppler
settings.acqSearchBand      = 48;           %[default 14 kHz]
% Threshold for the signal presence decision rule
settings.acqThreshold       = 2.5;
% Acquistion frequency step
settings.acqFreqstep        = 0.1;          %[kHz]


%% Tracking loops settings ================================================
% Code tracking loop parameters
settings.dllDampingRatio         = 0.7;
settings.dllNoiseBandwidth       = 20;       %[Hz] (default 2 Hz)
settings.dllCorrelatorSpacing    = 0.5;     %[chips]

% Carrier tracking loop parameters
settings.pllDampingRatio         = 0.7;
settings.pllNoiseBandwidth       = 25;      %[Hz] (default 25 Hz)

%% Navigation solution settings ===========================================

% Period for calculating pseudoranges and position
settings.navSolPeriod       = 20;          %[ms]

% Elevation mask to exclude signals from satellites at low elevation
settings.elevationMask      = 10;           %[degrees 0 - 90]
% Enable/dissable use of tropospheric correction
settings.useTropCorr        = 1;            % 0 - Off
                                            % 1 - On

% True position of the antenna in UTM system (if known). Otherwise enter
% all NaN's and mean position will be used as a reference .
settings.truePosition.E     = nan;
settings.truePosition.N     = nan;
settings.truePosition.U     = nan;

%% Plot settings ==========================================================
% Enable/disable plotting of the tracking results for each channel
settings.plotTracking       = 1;            % 0 - Off
                                            % 1 - On

%% Constants ==============================================================

settings.c                  = 299792458;    % The speed of light, [m/s]
settings.startOffset        = 68.802;       %[ms] Initial sign. travel time
