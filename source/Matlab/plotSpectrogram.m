foldername = "C:\Users\Alex Yu\OneDrive\Documents\MATLAB\Data\Training_Data_Official\";
S = 1; 
N = 312;
M = floor(N*(0.6));
filename = "s" + num2str(S)+ ".wav";  
[xin,fs] = audioread(foldername+filename);
figure()
subplot(1,2,1)
spectrogram(xin, hamming(N),M,[],fs,'yaxis')
title("Spectrogram of Speaker " +num2str(S))
s = spectrogram(xin, hamming(N),M,N,'yaxis');
[height,width] = size(s);
ax = gca;
ax.YDir = 'normal';
filter_max = 2;
K = 20;
filter_banks = melBanks(K,fs,N,0,fs/2,filter_max);

subplot(1,2,2)
S_banks = zeros(K,width);
for i = 1:width
    for k = 1:K
        S_banks(k,i) = sum(s(1:N/2,i).*(filter_banks(k,:)'));
    end
end

imagesc(10*log10(abs(S_banks)));c = colorbar;    

ax = gca;
ax.YDir = 'normal';
xlim([1 width])
ylim([1 K])

%set Ticks and TickLabels
yticks(1:2:K)
Ticks = melspace(K,0, fs/2);
Ticks = round(Ticks(2:2:end)/1000,2);
yticklabels(Ticks)
ylabel('Frequency (kHz)')
ylabel(c,'Power (db)')
xticks(0:(fs/(10*(N-M))):(fs/(N-M)))
xticklabels(0:0.1:1)
xlabel('Time(s)')
title("Filterbank-ogram of Speaker " + num2str(S))

%figure()
%for S = 1:12
%    subplot(3,4,S)
%    filename = "s" + num2str(S)+ ".wav";  
%    [xin,fs] = audioread(foldername+filename);
%    xin = xin(:,1);
%    spectrogram(xin, hamming(N),M,[],fs,'yaxis');
%    title("Speaker " + num2str(S))
%end



function spacing = melspace(K,fmin, fmax)
    melMin = 1127*log(1 + fmin/700);
    melMax = 1127*log(1 + fmax/700);
    spacing = linspace(melMin,melMax, K + 2);
    spacing = 700*(exp(spacing/1127) - 1);
end

