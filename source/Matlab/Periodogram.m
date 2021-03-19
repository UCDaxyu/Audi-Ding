N = 312;
M = 125;
foldername = "C:\Users\Alex Yu\OneDrive\Documents\MATLAB\Data\Test_Data\";
filename = "s" + num2str(1)+ ".wav";
[xin,fs] = audioread(foldername+filename);
xin = xin(:,1);
xin = xin/ max(abs(xin));
L = floor((length(xin)-N)/M);

xframesTemp = zeros(L+1,N);
for m = 0:L
    xframesTemp(m+1,:) = xin((m*M + 1):(m*M + N)); 
    periodograms(m+1,:) = periodogram(xframesTemp(m+1,:),hamming(N), 12500);
end


%h = imagesc(periodograms');
h = surf(periodograms');
set(h, 'EdgeColor','none')
title("Periodogram for Speaker 1")
xlabel("Time")
ylabel("Frequency hz")
ax = gca;
ax.YDir = 'normal';
c = colorbar;
view([0,90]);
