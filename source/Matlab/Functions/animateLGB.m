function [Mov,h] = animateLGB(mfccs, M , delta, threshold)
    % INPUTS:
    % mfccs:                Matrix of Mel Frequency Cepstrum Coefficients
    % M: [1,num of frames]  Number of clusters 
    % delta: (0,1)          splitting parameter for Centroids
    % threshold: (0,1]      Max allowed total distortion
    % OUTPUTS:
    %
    mfccs = mfccs/max(abs(mfccs),[],'all');
    
    
    % Begin with a 1 centroid codebook 
    % place first centroid at mean of every k value
    centroids = mean(mfccs,1); 
    [L,K] = size(mfccs);
    % m = 1 for 1 cluster
    m = 1;
    clusteri = zeros(1,L); %indices mapping to appropriate cluster
    
    % Lets make a movie!
    h = figure();
    h.Visible = 'off';
    % randomly pick two axes to plot
    axX = randi(K);
    axY = randi(K);
    while axY == axX % Low rolled, reroll until axes are unique
        axY = randi(K);
    end
    scatter(mfccs(:,axX), mfccs(:,axY))
    hold on
    scatter(centroids(:,axX), centroids(:,axY))
    hold off
    xlabel("MFCC-" + num2str(axX))
    ylabel("MFCC-" + num2str(axY))
    title("Start With One Cluster")
    xlim([min(mfccs(:,axX)), max(mfccs(:,axX))]);
    ylim([min(mfccs(:,axY)), max(mfccs(:,axY))]);
    drawnow
    ax = gca;
    ax.Units = 'pixels';
    pos = ax.Position;
    ti = ax.TightInset;
    rect = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3), pos(4)+ti(2)+ti(4)];
    %ax.NextPlot = 'replaceChildren';
    
    loops = 1;
    Mov(loops) = struct('cdata',[], 'colormap',[]);
    
    framei = 1;
    Mov(framei) = getframe(ax,rect);
    framei =framei + 1;
    % Continue until we have M clusters
    while m < M
        % split centroid with splitting factor
        centroids = [centroids*(1+delta); centroids*(1-delta)]; 
        m = 2*m;
        scatter(mfccs(:,axX), mfccs(:,axY))
        hold on
        scatter(centroids(:,axX),centroids(:,axY), 'x')
        xlim([min(mfccs(:,axX)), max(mfccs(:,axX))]);
        ylim([min(mfccs(:,axY)), max(mfccs(:,axY))]);
        xlabel("MFCC-" + num2str(axX))
        ylabel("MFCC-" + num2str(axY))
        title("Split Centroids")
        drawnow
        ax = gca;
        ax.Units = 'pixels';
        pos = ax.Position;
        ti = ax.TightInset;
        rect = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3), pos(4)+ti(2)+ti(4)];
        Mov(framei) = getframe(ax,rect);
        framei = framei + 1;
        
        if m == 2
            a = (centroids(1,axY) - centroids(2,axY))/(centroids(1,axX) - centroids(2,axX));
            midY = (centroids(1,axY) + centroids(2,axY))/2;
            midX =(centroids(1,axX) + centroids(2,axX))/2;
            t = linspace(-1.0,1.0,1000);
            y = (-1/a) *(t - midX) + midY;
            plot(t,y)
        else
            voronoi(centroids(:,axX),centroids(:,axY),'r')
        end
        hold off
        xlim([min(mfccs(:,axX)), max(mfccs(:,axX))]);
        ylim([min(mfccs(:,axY)), max(mfccs(:,axY))]);
        xlabel("MFCC-" + num2str(axX))
        ylabel("MFCC-" + num2str(axY))
        title("Form " + num2str(m) + " Clusters from Split Centroids")
        drawnow
        ax = gca;
        ax.Units = 'pixels';
        pos = ax.Position;
        ti = ax.TightInset;
        rect = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3), pos(4)+ti(2)+ti(4)];
        Mov(framei) = getframe(ax,rect);
        framei = framei + 1;
        
        oldDistortion = 1E100;
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
        
        scatter(mfccs(:,axX), mfccs(:,axY))
        hold on
        scatter(centroids(:,axX),centroids(:,axY), 'x');
        if m == 2
            a = (centroids(1,axY) - centroids(2,axY))/(centroids(1,axX) - centroids(2,axX));
            midY = (centroids(1,axY) + centroids(2,axY))/2;
            midX =(centroids(1,axX) + centroids(2,axX))/2;
            t = linspace(-1,1,100);
            y = (-1/a) *(t - midX) + midY;
            plot(t,y,'r')
        else
            voronoi(centroids(:,axX),centroids(:,axY), 'r')
        end
        scatter(newCentroids(:,axX),newCentroids(:,axY), '*g')
        hold off
        xlim([min(mfccs(:,axX)), max(mfccs(:,axX))]);
        ylim([min(mfccs(:,axY)), max(mfccs(:,axY))]);
        xlabel("MFCC-" + num2str(axX))
        ylabel("MFCC-" + num2str(axY))
        title("Find Centroids from Clusters")
        drawnow
        ax = gca;
        ax.Units = 'pixels';
        ti = ax.TightInset;
        pos = ax.Position;
        rect = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3), pos(4)+ti(2)+ti(4)];
        Mov(framei) = getframe(ax,rect);
        framei = framei + 1;
        
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
            scatter(mfccs(:,axX), mfccs(:,axY))
            hold on
            scatter(centroids(:,axX),centroids(:,axY), 'x');
            if m == 2
                a = (centroids(1,axY) - centroids(2,axY))/(centroids(1,axX) - centroids(2,axX));
                midY = (centroids(1,axY) + centroids(2,axY))/2;
                midX =(centroids(1,axX) + centroids(2,axX))/2;
                t = linspace(-1,1,100);
                y = (-1/a) *(t - midX) + midY;
                plot(t,y,'r')
            else
                voronoi(centroids(:,axX),centroids(:,axY), 'r')
            end
            hold off
            xlim([min(mfccs(:,axX)), max(mfccs(:,axX))]);
            ylim([min(mfccs(:,axY)), max(mfccs(:,axY))]);
            xlabel("MFCC-" + num2str(axX))
            ylabel("MFCC-" + num2str(axY))
            title("Distortion Reduction Not Met, Recluster")
            drawnow
            ax = gca;
            ax.Units = 'pixels';
            pos = ax.Position;
            ti = ax.TightInset;
            rect = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3), pos(4)+ti(2)+ti(4)];
            Mov(framei) = getframe(ax,rect);
            framei = framei + 1;
            
            
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
            
            scatter(mfccs(:,axX), mfccs(:,axY))
            hold on
            scatter(centroids(:,axX),centroids(:,axY), 'x');
            if m == 2
                a = (centroids(1,axY) - centroids(2,axY))/(centroids(1,axX) - centroids(2,axX));
                midY = (centroids(1,axY) + centroids(2,axY))/2;
                midX =(centroids(1,axX) + centroids(2,axX))/2;
                t = linspace(-1,1,100);
                y = (-1/a) *(t - midX) + midY;
                plot(t,y,'r')
            else
                voronoi(centroids(:,axX),centroids(:,axY), 'r')
            end
            scatter(newCentroids(:,axX),newCentroids(:,axY), '*g');
            hold off
            xlabel("MFCC-" + num2str(axX))
            ylabel("MFCC-" + num2str(axY))
            title("Find new Centroids and Calculate Distortion")
            xlim([min(mfccs(:,axX)), max(mfccs(:,axX))]);
            ylim([min(mfccs(:,axY)), max(mfccs(:,axY))]);
            drawnow
            ax.Units = 'pixels';
            ti = ax.TightInset;
            rect = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3), pos(4)+ti(2)+ti(4)];
            Mov(framei) = getframe(ax,rect);
            framei = framei + 1;
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
        scatter(mfccs(:,axX), mfccs(:,axY))
        hold on
        scatter(centroids(:,axX),centroids(:,axY), 'x');
        if m == 2
            a = (centroids(1,axY) - centroids(2,axY))/(centroids(1,axX) - centroids(2,axX));
            midY = (centroids(1,axY) + centroids(2,axY))/2;
            midX =(centroids(1,axX) + centroids(2,axX))/2;
            t = linspace(-1,1,100);
            y = (-1/a) *(t - midX) + midY;
            plot(t,y,'r')
        else
            voronoi(centroids(:,axX),centroids(:,axY), 'r')
        end
        hold off
        xlabel("MFCC-" + num2str(axX))
        ylabel("MFCC-" + num2str(axY))
        title("Minimal Distortion for " + num2str(m) + " Clusters Found")
        xlim([min(mfccs(:,axX)), max(mfccs(:,axX))]);
        ylim([min(mfccs(:,axY)), max(mfccs(:,axY))]);
        drawnow
        ax.Units = 'pixels';
        ti = ax.TightInset;
        rect = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3), pos(4)+ti(2)+ti(4)];
        Mov(framei) = getframe(ax,rect);
        framei = framei + 1;
    end
    
    clusters = cell(M,1);
    for i = 1:L
        clusters(clusteri(i)) = {[clusters{clusteri(i)} ;mfccs(i,:)]};
    end
    h.Visible = 'on';
end