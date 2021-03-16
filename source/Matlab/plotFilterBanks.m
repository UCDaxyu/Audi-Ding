
f_s = 40E3; %Sampling Rate of audio
n_fft = 256;
filter_max = 2;
K = 20;
figure()
filter_banks = melBanks(K,f_s,n_fft,0,20E3,filter_max);
plot(1:(n_fft/2), filter_banks(1,1:(n_fft/2)));
hold on
for k = 1:K
    plot(1:(n_fft/2), filter_banks(k,1:(n_fft/2)));
end
hold off
title("Mel Filter Banks K = " + K)
xlabel("FFT points n = " + n_fft);