% This is the main file to run for the EEC 201 Final Project.
% To run, specify the locations of the training and test data. 
%   Ensure the two sets of data are in their own folder. 
%   Name the files "sx.wav" where x is a number greater than 0
% OUTPUT:
% MFCCs for both training and data sets
% Codebooks for every train
%

% Change the folder names to the folders ONLY containing the signals
folderNameTrain = "C:\Users\Alex Yu\OneDrive\Documents\MATLAB\Data\Freespoken Training\";
folderNameTest = "C:\Users\Alex Yu\OneDrive\Documents\MATLAB\Data\Freespoken Test\";
%folderNameTrain = "C:\Users\Alex Yu\OneDrive\Documents\MATLAB\Data\Training_Data_Official\";
%folderNameTest = "C:\Users\Alex Yu\OneDrive\Documents\MATLAB\Data\Freespoken Test\";
S_test = 6*5;           % Specify the number of Tests in the testing folder to perform
S_train = 6*45;         % Specify the number of Models to make from the training folder
M = 8;                  % Number of Clusters per codebook

num_ceps = 13;          % Number of MFCCs to keep
K = 20;                 % Number of Filter Banks 
framesize= 0.025;       % Length of each time frame in seconds
overlap = 0.6;          % Percent frame overlap from (0,1)
fsout = 12500;          % Desired Sampling Frequency 
n_fft = 512;            % Number of points for FFT 

% Specify the frequencies to remove
fnotch = 1000* [0.1247 0.2717 0.4448 0.6487 0.8890 1.1721 1.5057 1.8986 2.3616  2.9071 3.5498 4.3069 5.1990 ];
notch = "default"; % change to "notched" to remove the frequencies listed in fnotch

% Get the MFCCs for both the speaker and 
MFCCs = mfccs(folderNameTrain, num_ceps,framesize,overlap,fsout,K,n_fft);
TestMFCCs = mfccs(folderNameTest, num_ceps,framesize,overlap,fsout,K,n_fft, notch, fnotch);
save('MFCCS.mat','MFCCs');
save('TestMFCCS.mat','TestMFCCs');


% Create Codebooks for each speaker
codebook = cell(S_train,1);
for i = 1:S_train
    [clusters,centroids] = runLGB(MFCCs{i},M,.01,.01);
    codebook(i) = {centroids};
end
save('codebook.mat','codebook')


classification = zeros(S_test,2);
distortions = zeros(S_test,S_train);
rel_distortions = distortions;
for i = 1:S_test
    min_distortion = 1E100;
    for j = 1:S_train
        d = disteu(codebook{j}',TestMFCCs{i}');
        L = length(TestMFCCs{i}(:,1));
        for k = 1:L
            clusteri = find(d(:,k) == min(d(:,k)),1);
            distortions(i,j) = distortions(i,j) + d(clusteri, k);
        end
        if  distortions(i,j) < min_distortion
            min_distortion = distortions(i,j);
            classification(i,1) = j;
            classification(i,2) = distortions(i,j);
        end
    end
    distortions(i,:) = distortions(i,:) / length(TestMFCCs{i}); 
    rel_distortions(i,:) = distortions(i,:)/ max(distortions(i,:));
end
figure()
h = imagesc(rel_distortions');
ax = gca;
ax.YDir = 'normal';
%h = surf(distortions.^(-1));
%set(h, 'EdgeColor','none')
title("Test Speakers' Distortion Matrix")
ylabel("Training Models")
xlabel("Test Speaker")
c = colorbar;
yticks([0 45 90 135 180 225])
