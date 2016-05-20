function[processedFrame] = process_pupil(frame, brightness, square_side, threshold_dark, threshold_bright)
    Im = brightness*frame;    %read frame  
    agray = rgb2gray(Im);      %rgb2gray
    agray = agray(size(agray, 1)/2 - square_side:size(agray, 1)/2 + square_side , size(agray, 2)/2 - square_side:size(agray, 2)/2 + square_side  );
    agray1 = imcomplement(agray);
    agray2 = medfilt2(agray1);        %filtered and negative of image

    % threshold based on the brightness or darkness
    if (mean(agray2(:)) < 170)
        z1 = im2bw(agray2, threshold_dark);
    else
        z1 = im2bw(agray2, threshold_bright);
    end

    se = strel('disk', 1, 4);
    z2 = imdilate(z1,se);
    
    cc = bwconncomp(z2);
    numPixels = cellfun(@numel,cc.PixelIdxList);
    [biggest,idx] = max(numPixels);
    BW2 = ismember(labelmatrix(cc), idx);   %largest connected component
    BW3 = imfill(BW2,'holes');
    cc1 = bwconncomp(BW3);
    
    cnt1 = edge(BW3);
    % cnt2 = imdilate(cnt1,se2);
    
    Im(size(Im, 1)/2 - square_side:size(Im, 1)/2 + square_side , size(Im, 2)/2 - square_side:size(Im, 2)/2 + square_side  ,2) = Im(size(Im, 1)/2 - square_side:size(Im, 1)/2 + square_side , size(Im, 2)/2 - square_side:size(Im, 2)/2 + square_side  ,2) + 255*cast(cnt1, 'uint8');
    
    processedFrame = Im;
    
end