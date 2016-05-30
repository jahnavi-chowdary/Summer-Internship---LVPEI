function area_of_pupil_left(I)
   
    global x_left;
    global y_left;
    global area_pupil_left;
        
    % Getting area of Pupil
    I = rgb2gray(I);
    I_2 = zeros(size(I));
    [hei_I, wid_I] = size(I);

    rI = floor(x_left); cI = floor(y_left);
    winSize1 = 100;
    winSize2 = 100; 
    rl = max(1,rI - winSize1);
    cl = max(1,cI - winSize2);
    I_1 = I(cl:min(hei_I,(cl+2*winSize2)),rl:min(wid_I,(rl+2*winSize1)));
    
    clear I_new;
    I_new = zeros(size(I_1));
    I_new(I_1<70) = 1;
    I_2(cl:min(hei_I,(cl+2*winSize2)),rl:min(wid_I,(rl+2*winSize1))) = I_new;
    I_new = I_2;
    
    SE = strel('disk', 2);
    I_ne = imcomplement(I_new);
    I_dil = imdilate(I_ne,SE);
    I_temp = imcomplement(I_dil);
    I_fill = imfill(I_temp,'holes');

    BW = I_fill;
        
    BW1 = BW;
    CC = bwconncomp(BW);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggest,idx] = max(numPixels);
    BW(CC.PixelIdxList{idx}) = 0;
    Ir = imsubtract(BW1,BW);

    D1 = Ir;
    [Ilabel, num] = bwlabel(D1);

    for cnt = 1:num
        s = regionprops(Ilabel, 'BoundingBox', 'Area', 'Centroid','MajorAxisLength','MinorAxisLength');
        rectangle('position', s(cnt).BoundingBox,'EdgeColor','r','linewidth',2);
    end
    diameters = mean([s.MajorAxisLength s.MinorAxisLength],2);
    centers = s.Centroid;

    if size(centers) == 0
        tmp = area_pupil_left(1,size(area_pupil_left,2));
        area_pupil_left = [area_pupil_left, tmp];
    else
        x_left = centers(1,1);
        y_left = centers(1,2);
        radii_right = diameters/2;
        area_pupil_left = [area_pupil_left, (pi * radii_right^2)];
    end

            
    