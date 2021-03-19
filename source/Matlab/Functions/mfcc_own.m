function MFCCs = mfcc_own(x,num_ceps,f_s,n_fft,K,notched,fnotch,bwnotch)
arguments
    x
    num_ceps = 12
    f_s = 12500
    n_fft = length(x)
    K = 20
    notched = "default"
    fnotch = 500
    bwnotch = fnotch/(4*f_s/2)
end

    filter_max = 2;
    %x = lowpass(x,.9*f_s/2, f_s);
    X = fft(x.*(hamming(length(x))') ,n_fft);
    X = X(1:(n_fft/2));
    if notched == "notched"
        wo = fnotch/(f_s/2);
        for i = 1:length(wo)
            if fnotch(i) <= 900
                bwnotch(i) = wo(i) / 2;
            end
            [b,a] = iirnotch(wo(i),bwnotch(i));
            [h,w] = freqz(b,a,n_fft/2);
            X = X.*h';
        end
    end
    
    filter_banks = melBanks(K,f_s,n_fft,0,f_s/2,filter_max);
    for i = 1:K
        S_log(i) = sum((X.*conj(X)).*filter_banks(i,:));
    end
    S_log =log(S_log)'; % take the log of the sum of the power spectral density banks
    MFCCs = dct(S_log); 
    MFCCs = MFCCs(1:num_ceps);
end