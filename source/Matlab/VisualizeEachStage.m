% Plot MFCCs of every training data

row = 3;
col = 2;
M = 128; % Spacing between time domain frames
N = 312; % Size of one frame
K = 20;  % Number of MFCC values to generate per frame
filter_max = 2;
foldername = "C:\Users\alexy\Onedrive\Documents\MATLAB\Data\Training_Data\";
S = 3; % choose which training sample to use
fsout = 12500; % Desired Sample Rate 
filename = "s" + num2str(S)+ ".wav";  
[xin,f_s] = audioread(foldername+filename); % Read in the soundfile
xin = xin(:,1); % Some files have Stereo, take one side only
%xin = xin - mean(xin);
%/max(abs(xin(:,1)));
%xin = cropFile(xin); % Trim off "zero" values from start and end
%xin =   srconv(xin, f_s, fsout)'; % resample as needed

subplot(row,col,1)
plot(1:length(xin),xin);


L = floor(length(xin)/M) - 4;
xframes = zeros(L,N);
Xframes = zeros(L,N/2);
mfccs = zeros(L,K);

filter_banks = melBanks(K,f_s,N,0,f_s/2,filter_max);
subplot(row, col, 2)
plot(1:N/2, filter_banks);
windowing = hamming(N);
%windowing = hann(N)';
for m = 0:L
    xframes(m+1, 1:N) = xin((m*M + 1):(m*M + N)).*windowing; 
    %x = lowpass(x,.9*f_s/2, f_s);
    X = fft(xframes(m+1,:),N);
    Xframes(m+1,:) = X(1:(N/2));
    for i = 1:K
        mfccs(m+1,i) = log(sum((X(1:N/2).*conj(X(1:N/2))).*filter_banks(i,:)));
    end 
end
mfccs = dct(mfccs,K,2);
subplot(row, col, 3)
h = surf(abs(Xframes') / max(abs(Xframes),[],'all'));
set(h, 'EdgeColor','none')
title("Spectrogram " + i)
c = colorbar;
view([0,90]); 


subplot(row,col,5)
%h = surf(mfccs(:,2:K));
%set(h, 'EdgeColor','none')
h = pcolor(mfccs(:,2:K) );
h.EdgeAlpha = 0;
title("MFCC-ogram " + i)
c = colorbar;
view([0,90]); 

subplot(row,col,4)
h = surf(abs(Xframes').^2 / max(abs(Xframes).^2,[],'all'));
set(h, 'EdgeColor','none')
title("Power Spectral Density " + i)
c = colorbar;
view([0,90]); 


for k = 1:K
    %MFCCs(1:(L(i)+1),k,i) = MFCCs(1:(L(i)+1),k,i) - mean(MFCCs(1:(L(i)+1),k,i));
end
%MFCCs(:,:,i) = MFCCs(:,:,i) - mean(MFCCs(:,:,i),'all');
%MFCCs(1:m,:,i) = mfccs(1:m,2:K);
%MFCCs(1:m,:,i) = MFCCs(1:m,:,i); %- mean(1:m,:,i);
%MFCCs(:,:,i) = MFCCs(:,:,i)/max(abs(MFCCs(:,:,i)),[],'all');
%subplot(row, col, 5)




function y = cropFile(xin)
    threshold = 0.5;
    x = xin - mean(xin);
    x = abs(x/max(abs(x)));
    round(x, 3);
    %x = round(x/max(abs(x),3));
    %x = round(xin,3);
    y = xin(find(x >= threshold,1):find(x >= threshold,1,'last'));
end
