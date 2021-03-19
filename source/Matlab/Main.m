% This is the main file to run for the EEC 201 Final Project.
% To run, specify the locations of the training and test data. 
%   Ensure the two sets of data are in their own folder. 
%   Name the files "sx.wav" where x is a number greater than 0
% OUTPUT:
% MFCCs for both training and data sets
% Codebooks for every train
%

folderNameTrain = "C:\Users\Alex Yu\OneDrive\Documents\MATLAB\Data\Training_Data\";
folderNameTest = "C:\Users\Alex Yu\OneDrive\Documents\MATLAB\Data\Test_Data\";

num_ceps = 13;
K = 20;
framesize= 0.025;
overlap = 0.6;
fsout = 12500;
fnotch = 1000* [ 0.1247    0.2717    0.4448    0.6487    0.8890    1.1721    1.5057    1.8986    2.3616  2.9071    3.5498    4.3069    5.1990 ];
n_fft = 512;
%notch = "notched";
notch = "default";
% mfccs(foldername,num_ceps,framesize,overlap,fsout,K)
MFCCs = mfccs(folderNameTrain, num_ceps,framesize,overlap,fsout,K,n_fft);
TestMFCCs = mfccs(folderNameTest, num_ceps,framesize,overlap,fsout,K,n_fft, notch, fnotch);
save('MFCCS.mat','MFCCs');
save('TestMFCCS.mat','TestMFCCs');
S_test = 11; 
S_train = 11;
M = 8; % num of clusters


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
    rel_distortions(i,:) = distortions(i,:)/ min(distortions(i,:));
end

h = imagesc(distortions');
ax = gca;
ax.YDir = 'normal';
%h = surf(distortions.^(-1));
%set(h, 'EdgeColor','none')
title("Test Speakers' Distortion Matrix")
ylabel("Training Models")
xlabel("Test Speaker")
c = colorbar;