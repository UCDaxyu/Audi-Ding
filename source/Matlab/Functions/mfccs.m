function MFCCs = mfccs(foldername,num_ceps,framesize,overlap,fsout,K,n_fft,notched,fnotch)
    arguments
        foldername (1,1) {mustBeTextScalar,mustBeNonzeroLengthText} 
        num_ceps (1,1) {mustBeNumeric, mustBeInteger,mustBePositive, mustBeNonzero, mustBeNonNan} = 13
        framesize (1,1) {mustBeNumeric, mustBeReal,mustBePositive, mustBeNonzero, mustBeNonNan} = 0.025
        overlap (1,1) {mustBeNumeric, mustBeLessThan(overlap,1)} = 0.6 
        fsout  (1,1) {mustBeNumeric,mustBeReal} = 12500
        K (1,1) {mustBeNumeric, mustBeInteger,mustBePositive, mustBeNonzero, mustBeNonNan} = 20
        n_fft (1,1) {mustBeNumeric, mustBeInteger,mustBePositive, mustBeNonzero, mustBeNonNan} = 512
        notched = 'default'
        fnotch = 500
    end
    
    fds = fileDatastore(foldername + "*.wav", 'ReadFcn', @importdata);

    fullFileNames = fds.Files;

    numFiles = length(fullFileNames);

    % Loop over all files reading them in and plotting them.

    for k = 1 : numFiles

        fprintf('Now reading file %s\n', fullFileNames{k});

        % Now have code to read in the data using whatever function you want.

        % Now put code to plot the data or process it however you want...
        [xin,fs] = audioread(fullFileNames{k});
        xin = xin(:,1);
        %xin = cropFile(xin);
        xin = srconv(xin, fs, fsout)';
        %xin = xin - mean(xin);
        %xin = xin/max(abs(xin));
        %subplot(4,3,i)
        %plot(1:length(xin),xin);
        x(k) = {xin};
    end

    N = floor(framesize*fsout); % Size of one frame
    M = floor(N*(1-overlap));  % Frame Spacing 
    
    xframes = cell(1,numFiles);
    MFCCs = cell(1,numFiles);
    %figure()
    for i = 1:numFiles % Get Frames of length N every M samples for each file
        L = floor((length(x{i})-N)/M);
        mfccs = zeros(L+1,num_ceps);
        xframesTemp = zeros(L+1,N);
        for m = 0:L
            xframesTemp(m+1,:) = x{i}((m*M + 1):(m*M + N)); 
            mfccs(m+1,:) = mfcc_own(xframesTemp(m+1,:),num_ceps, fsout, n_fft, K,notched,fnotch);
        end
        MFCCs(i) = {mfccs(:,2:num_ceps)};
        xframes(i) = {xframesTemp};
        %MFCCs(i) = {MFCCs{i}/max(abs(MFCCs{i}),[],'all')};
    end
end