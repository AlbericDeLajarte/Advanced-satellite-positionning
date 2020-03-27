% Advanced Satellite Positioning - Lab 3: Acquisition of GPS signal
% Spring 2018

function corr = FFTCorrelation(signal_1, signal_2)
if(length(signal_1) == length(signal_2) )
    k = length(signal_1);
    corr = zeros(1, k);
else
    k = 0;
    disp('\nError: the signals should have the same length\n');
end

corr = ifft(fft(signal_1).*conj(fft(signal_2)));

end


