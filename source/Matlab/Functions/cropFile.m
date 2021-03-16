function y = cropFile(xin)
    threshold = 0.01;
    x = xin - mean(xin);
    x = abs(x/max(abs(x)));
    round(x, 3);
    %x = round(x/max(abs(x),3));
    %x = round(xin,3);
    y = xin(find(x > threshold,1):find(x > threshold,1,'last'));
end