n_fft = 512;
f_s = 12500;
fnotch = 1000* [ 0.1247    0.2717    0.4448    0.6487    0.8890    1.1721    1.5057    1.8986    2.3616  2.9071    3.5498    4.3069    5.1990 ];
Q = 30;
row = floor(length(fnotch)^0.5);
col = row + 1;
figure()
hold on
for i = 1:length(fnotch)
    %subplot(row, col, i)
    wo = fnotch(i)/(f_s/2);
    % notch depth is shallow with high Q for notch frequencies < ~800hz
    % fix the Q factor to 2 in these cases
    
    if fnotch(i) <= 900
        bwnotch = wo / 4;
    else
        bwnotch = wo / 20;
    end
    
    [b,a] = iirnotch(wo,bwnotch);
    [h,f] = freqz(b,a,n_fft/2,f_s);
    plot(f, abs(h))
end
hold off

title("Notch Filters Applied to STFT")
xlabel("Frequency (Hz)")
ylabel("Amplitude")
