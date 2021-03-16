
f_s = 12500; %Sampling Rate of audio
n_fft = 312;
filter_max = 2;
K = 13;
figure()
filter_banks = melBanks(K,f_s,n_fft,0,f_s/2,filter_max);

hold on
for k = 2:K
    plot(1:(n_fft/2), filter_banks(k,1:(n_fft/2)));
end
hold off
title("Mel Filter Banks K = " + K)
xlabel("FFT points n = " + n_fft);