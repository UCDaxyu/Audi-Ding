% Plot MFCCs of every training data
load MFCCS
figure()
for i = 1:11   
    subplot(3,4,i)
    h = imagesc(MFCCs{i}');
    title("Training Speaker " + i)
    xlabel("Time")
    ylabel("MFCC Dimension")
    ax = gca;
    ax.YDir = 'normal';
    c = colorbar;
    view([0,90]);
end

