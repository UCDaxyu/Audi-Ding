%% Visualizing the Spectrogram on a 2-d axis
% The spectrograme provides amazingly fast visual data to investigate the
% movement of frequencies but it lacks finer details that can be lost by
% the sheer density of data. 
% I want to animate a 2-d stem plot to "scan" through the spectrogram
%%

foldername = "C:\Users\Alex Yu\OneDrive\Documents\MATLAB\Data\Training_Data_Official\";
S = 1; 
N = 312;
M = floor(N*(0.6));
filename = "s" + num2str(S)+ ".wav";  
[xin,fs] = audioread(foldername+filename);
xin = xin(:,1);
Mov = animateSpectrogram(xin,fs, 312);
% Make a Gif from collected frames
gifname = 'Spectrogram.gif'; 
delay = 0.1;
for i = 1:length(Mov)
    img = frame2im(Mov(i));
    [A,map] = rgb2ind(img,256);
    if i == 1
        imwrite(A,map, gifname,'gif','LoopCount', Inf,'WriteMode', 'overwrite', 'DelayTime',delay);
    elseif i == length(Mov)
        imwrite(A,map, gifname,'gif','WriteMode', 'append', 'DelayTime',5);
    else
        imwrite(A,map, gifname,'gif','WriteMode', 'append', 'DelayTime',delay);
    end
end
v = VideoWriter('spectrogram.mp4','MPEG-4');
v.FrameRate = 10;
open(v);
writeVideo(v,Mov);
close(v);
%%
function Mov = animateSpectrogram(xin,fs,N)
    s = spectrogram(xin,hamming(N), floor(N*(0.6)), 512,'yaxis');
    h = figure();
    [height,width] = size(s);
    Mov(width) = struct('cdata',[], 'colormap',[]);
    h.Position(3:4) = [840 420];
    %h.Visible = 'off';
    for i = 1:width
        subplot(1,2,1)
        surf(10*log10(abs(s)),'EdgeColor','none');view([0 90]);c = colorbar;
        hold on 
        line([i i],[0 height], 'Color','red', 'LineWidth',4.0)
        hold off
        yticklabels([0 1.2 2.4 3.6 4.8 6])
        xticklabels([0 0.2 .4 .6 .8 1])
        xlabel("Time (s)")
        ylabel( "Frequency (kHz)")
        title("Spectrogram")
        xlim([1 width])
        ylim([1 256])
        subplot(1,2,2)
        plot(1:height, 10*log10(abs(s(:,i))))
        xticklabels([0 1.2 2.4 3.6 4.8 6])
        xlabel("Frequency (kHz)");
        ylabel("Magnitude (db)")
        title("Current FFT ");
        xlim([1 height])
        ylim([min(10*log10(abs(s)),[],'all') max(10*log10(abs(s)),[],'all')])
        drawnow
        ax = gca;
        ax.Units = 'pixels';
        pos = ax.Position;
        ti = ax.TightInset;
        %rect = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3), pos(4)+ti(2)+ti(4)];
        Mov(i) = getframe(gcf);
    end
    h.Visible = 'on';
end
