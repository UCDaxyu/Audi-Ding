foldername = "C:\Users\alexy\Onedrive\Documents\MATLAB\Data\Test_Data\";
foldername = "C:\Users\Alex Yu\OneDrive\Documents\MATLAB\Data\Test_Data\";

S = size(dir([foldername+'*.wav']),1);
fsout = 12500; % Desired Sample Rate 
for i = 1:S
    filename = "s" + num2str(i)+ ".wav";  
    [xin,fs] = audioread(foldername+filename);
    xin = xin(:,1);
    %xin = cropFile(xin);
    xin = srconv(xin, fs, fsout)';
    %xin = xin - mean(xin);
    %xin = xin/max(abs(xin));
    %subplot(4,3,i)
    %plot(1:length(xin),xin);
    x(i) = {xin};
end

N = floor(0.025*fsout);
M = floor(N*0.4);
%N = 256;
%M = 100;
K = 13;
xframes = cell(1,S);
MFCCs = cell(1,S);
%figure()
for i = 1:S % Get Frames of length N every M samples for each file
    L = floor((length(x{i})-N)/M);
    mfccs = zeros(L+1,K);
    xframesTemp = zeros(L+1,N);
    for m = 0:L
        xframesTemp(m+1,:) = x{i}((m*M + 1):(m*M + N)); 
        mfccs(m+1,:) = mfcc_own(xframesTemp(m+1,:), fsout, K);
    end
    MFCCs(i) = {mfccs(:,2:K)};
    xframes(i) = {xframesTemp};
    %MFCCs(i) = {MFCCs{i}/max(abs(MFCCs{i}),[],'all')};
    MFCCs(i) = {MFCCs{i}./std(MFCCs{i},0,1)};
    %MFCCs(i) = {MFCCs{i} - repmat(mean(MFCCs{i},1),L+1,1)};
end
TestMFCCs = MFCCs;
% Save MFCCs for other use
save('TestMFCCS.mat','TestMFCCs');