function MFCCs = mfcc_own(x,f_s,K)
    n_fft = length(x);
    filter_max = 2;
    %x = lowpass(x,.9*f_s/2, f_s);
    X = fft(x.*hamming(n_fft)' ,n_fft);
    X = X(1:(n_fft/2));
    filter_banks = melBanks(K,f_s,n_fft,0,f_s/2,filter_max);
    for i = 1:K
        S_log(i) = sum((X.*conj(X)).*filter_banks(i,:));
    end
    S_log =log(S_log)'; % take the log of the sum of the power spectral density banks
    MFCCs = dct(S_log); 
end