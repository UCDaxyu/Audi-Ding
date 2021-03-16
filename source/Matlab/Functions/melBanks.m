% This file contains the functions to make a Mel frequency filter bank


function filter_banks = melBanks(K, f_s,n_fft,lowerFreqBound,upperFreqBound, filter_max)
    arguments
        K (1,1) {mustBeNumeric,mustBeReal} = 12
        f_s  (1,1) {mustBeNumeric,mustBeReal} = 48000
        n_fft  (1,1) {mustBeNumeric,mustBeReal} = 300
        lowerFreqBound  (1,1) {mustBeNumeric,mustBeReal} = 0
        upperFreqBound  (1,1) {mustBeNumeric,mustBeReal} = f_s/2
        filter_max (1,1) {mustBeNumeric,mustBeReal} = 1
    end
    spacing = melspace(K, lowerFreqBound, upperFreqBound);
    spacing_n = floor((n_fft - 1)*spacing/f_s);
    filter_banks = zeros(K, n_fft/2);
    for k = 2:(K+1)
        for i = 1:(n_fft/2)
            if i >= spacing_n(k-1) && i <= spacing_n(k)
                filter_banks(k-1,i+1) =  (i -spacing_n(k-1)) *(filter_max/(spacing_n(k) - spacing_n(k-1)));
            elseif i >= spacing_n(k) && i <= spacing_n(k+1)
                filter_banks(k-1,i+1) =  (i -spacing_n(k))*(-filter_max/(spacing_n(k+1) - spacing_n(k))) + filter_max;
            end
        end
    end
    function spacing = melspace(K,fmin, fmax)
        melMin = 1127*log(1 + fmin/700);
        melMax = 1127*log(1 + fmax/700);
        spacing = linspace(melMin,melMax, K + 2);
        spacing = 700*(exp(spacing/1127) - 1);
    end
end


