function area_of_pupil_right(event)
    
    % display('Area_RIGHT');
    global x_right;
    global y_right;
    global area_pupil_right;
    global time_right; 
    
    I = event.Data;
    tstampstr = event.Timestamp;
    
    [hour_right, temp1] = strtok(tstampstr,':');
    [min_right, temp2] = strtok(temp1,':');
    [sec_right] = strtok(temp2,':');
    
    time_rgt = ((3600 .* str2num(hour_right)) + (60 .* str2num(min_right)) + str2num(sec_right)) * 1000;
    time_right = [time_right , time_rgt];
    
    % Getting area of Pupil
    I = rgb2gray(I);
    I_2 = zeros(size(I));
    [hei_I, wid_I] = size(I);

    rI = floor(x_right); cI = floor(y_right);
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
        % rectangle('position', s(cnt).BoundingBox,'EdgeColor','r','linewidth',2);
    end
    
    diameters = mean([s.MajorAxisLength s.MinorAxisLength],2);
    centers = s.Centroid;

    if size(centers) == 0
        tmp = area_pupil_right(1,size(area_pupil_right,2));
        area_pupil_right = [area_pupil_right, tmp];
    else
        x_right = centers(1,1);
        y_right = centers(1,2);
        radii_right = diameters/2;
        area_pupil_right = [area_pupil_right, (pi * radii_right^2)];
    end
