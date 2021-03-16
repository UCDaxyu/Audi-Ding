function MFCCs = mfccs(foldername,K,framesize,overlap,fsout)
    arguments
        foldername (1,1) {mustBeTextScalar,mustBeNonzeroLengthText} 
        K (1,1) {mustBeNumeric, mustBeInteger,mustBePositive, mustBeNonzero, mustBeNonNan} = 13
        framesize (1,1) {mustBeNumeric, mustBeReal,mustBePositive, mustBeNonzero, mustBeNonNan} = 0.025
        overlap (1,1) {mustBeNumeric, mustBeLessThan(overlap,1)} = 0.6 
        fsout  (1,1) {mustBeNumeric,mustBeReal} = 12500
    end
    S = size(dir([foldername+'*.wav']),1);

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

    N = floor(framesize*fsout); % Size of one frame
    M = floor(N*(1-overlap));  % Frame Spacing 
    
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
end