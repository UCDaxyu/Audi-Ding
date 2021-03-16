folderNameTrain = "C:\Users\Alex Yu\OneDrive\Documents\MATLAB\Data\Training_Data\";
folderNameTest = "C:\Users\Alex Yu\OneDrive\Documents\MATLAB\Data\Test_Data\";
MFCCs = mfccs(folderNameTrain);
TestMFCCs = mfccs(folderNameTest);
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



classification = zeros(S_test,2);
distortions = zeros(S_test,S_train);
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
end

h = imagesc(distortions');
ax = gca;
ax.YDir = 'normal';
%h = surf(distortions.^(-1));
%set(h, 'EdgeColor','none')
title("Test Speakers' Disortion Matrix")
ylabel("Training Models")
xlabel("Test Speaker")
c = colorbar;