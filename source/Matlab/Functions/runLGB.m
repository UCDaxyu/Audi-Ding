function [clusters, centroids] = runLGB(mfccs, M , delta, threshold)
    % INPUTS:       size         Description
    % mfccs:        L x K        Matrix of Mel Frequency Cepstrum Coefficients
    % M:            [1,L]        Number of clusters 
    % delta:        (0,1)        splitting parameter for Centroids
    % threshold:    (0,1]        Max allowed total distortion
    % OUTPUTS:
    % centroids:    M x K        Locations of each centroid
    % clusters      M x [0,L]    returns the cluster in matching order to
    %                            the centroid array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    
    % Begin with a 1 centroid codebook 
    % place first centroid at mean of every k value
    centroids = mean(mfccs,1); 
    [L,K] = size(mfccs);     % L frames, K dimensions
    % m = 1 for 1 cluster
    m = 1;
    clusteri = zeros(1,L); %indices mapping to appropriate cluster
    
    % Continue until we have M clusters
    while m < M
        % split centroid with splitting factor
        centroids = [centroids*(1+delta); centroids*(1-delta)]; 
        m = 2*m; % We now have twice as many centroids
        oldDistortion = 1E100;  % oldDistortion = infinity
        distortions = zeros(1,m);
       
        % Calculate the distance from each data vector to every centroid
        % currently generated
        d = disteu( centroids',mfccs(1:L,:)');
        
        % Assign each data vector to the cluster with the minimum
        % distance to the corresponding centroid
        for i = 1:L
            clusteri(i) = find(d(:,i) == min(d(:,i)),1); 
        end
        
        % Find new centroids
        newCentroids = zeros(m,K);
        for i = 1:L
            newCentroids(clusteri(i),:) = newCentroids(clusteri(i),:) + mfccs(i,:);
        end
        for i = 1:m
            count = sum(clusteri(:) == i);
            if count ~= 0
                newCentroids(i,:)= newCentroids(i,:) / count;
            end
        end
        centroids = newCentroids;
        
        % Compute new distortion
        d = disteu( centroids',mfccs(1:L,:)');
        for i = 1:L
            clusteri(i) = find(d(:,i) == min(d(:,i)),1);
            distortions(clusteri(i)) =  distortions(clusteri(i)) + d(clusteri(i), i);
        end
        distortions(clusteri(i)) =  distortions(clusteri(i)) + d(clusteri(i), i);
        newDistortion = sum(distortions);
        
        % Continue re-clustering data vectors based on the locations of the 
        % centroids until the improvement in distortion is minimal
        while abs((oldDistortion - newDistortion)/newDistortion )> threshold
            oldDistortion = newDistortion;
            
            % Find new centroids
            newCentroids = zeros(m,K);
            for i = 1:L
                newCentroids(clusteri(i),:) = newCentroids(clusteri(i),:) + mfccs(i,:);
            end
            for i = 1:m
                count = sum(clusteri(:) == i);
                if count ~= 0
                    newCentroids(i,:)= newCentroids(i,:) / count;
                end
            end
            centroids = newCentroids;
            
            % Calculate distortion for new centroids
            d = disteu( centroids',mfccs(1:L,:)');
            distortions = zeros(m,1);
            for i = 1:L
                clusteri(i) = find(d(:,i) == min(d(:,i)),1);
                distortions(clusteri(i)) =  distortions(clusteri(i)) + d(clusteri(i), i);
            end
            newDistortion = sum(distortions);
        end
    end
    clusters = cell(M,1);
    for i = 1:L
        clusters(clusteri(i)) = {[clusters{clusteri(i)} ;mfccs(i,:)]};
    end
end