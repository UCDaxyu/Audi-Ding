load MFCCS

[Mov, h] = animateLGB(MFCCs{1}, 8, .1, .01);
% Make a Gif from collected frames
gifname = 'Clustering.gif'; 
delay = 3;
for i = 1:length(Mov)
    img = frame2im(Mov(i));
    [A,map] = rgb2ind(img,256);
    if i == 1
        imwrite(A,map, gifname,'gif','LoopCount', Inf,'WriteMode', 'overwrite', 'DelayTime',delay);
    elseif i == length(Mov)
        imwrite(A,map, gifname,'gif','WriteMode', 'append', 'DelayTime',10);
    else
        imwrite(A,map, gifname,'gif','WriteMode', 'append', 'DelayTime',delay);
    end
end