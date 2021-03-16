load 'MFCCS.mat'

S = 11; % num of speakers
M = 8; % num of clusters
codebook = cell(S,1);
for i = 1:S
    [clusters,centroids] = runLGB(MFCCs{i},M,.01,.01);
    codebook(i) = {centroids};
end

%scatter(MFCCs{5}(:,9),MFCCs{5}(:,18))
%scatter(MFCCs{9}(:,9),MFCCs{9}(:,18))
%scatter(codebook{5}(:,9),codebook{5}(:,18),'filled')
%scatter(codebook{9}(:,9),codebook{9}(:,18),'filled')
%legend("speaker 2 data", "speaker 9 data", "speaker 2 centroids", "speaker 9 centroids")
save("codebook.mat",'codebook');