function [area_pupil_right] = area_of_pupil(video_right)

    numFrames_right = video_right.NumberOfFrames;
    n = numFrames_right;

    for i = 1:1:n
        
        I = read(video_right,i);
      
        % Getting area of Pupil

        I = rgb2gray(I);
        I_2 = zeros(size(I));
        [hei_I wid_I] = size(I);
        
        if i ~= 1
            c = floor(c1(i-1,:));
            rI = c(1); cI = c(2);
            winSize1 = (l1(i-1)+50);
            winSize2 = (l2(i-1)+50); 
            rl = max(1,rI - winSize1);
            cl = max(1,cI - winSize2);
            I_1 = I(cl:min(hei_I,(cl+2*winSize2)),rl:min(wid_I,(rl+2*winSize1)));
    
            [hei wid] = size(I_1);
            clear I_new;
            I_new = imcomplement(im2bw(I_1,0.275));
            I_2(cl:min(hei_I,(cl+2*winSize2)),rl:min(wid_I,(rl+2*winSize1))) = I_new;
            I_new = I_2;
        else
            I_2 = I;
            [hei wid] = size(I);
            I_new = imcomplement(im2bw(I_2,0.275));
        end
        
    
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
        [Ilabel num] = bwlabel(D1);

        for cnt = 1:num
            s = regionprops(Ilabel, 'BoundingBox', 'Area', 'Centroid','MajorAxisLength','MinorAxisLength');
        end
        diameters = mean([s.MajorAxisLength s.MinorAxisLength],2);
        centers = s.Centroid;
        
        if isempty(s.Centroid)
            c1(i,:) = c1(i-1,:);
            l1(i) = l1(i-1);
            l2(i) = l2(i-1);
        else
            c1(i,:) = s.Centroid;
            l1(i) = floor(s.BoundingBox(3)/2);
            l2(i) = floor(s.BoundingBox(4)/2);
        end
    
        if (s.BoundingBox(3)*s.BoundingBox(4)) < 700
            c1(i,1) = floor(hei/2);
            c1(i,2) = floor(wid/2);
            l1(i) = 100;
            l2(i) = 100;
        end
        
        if size(centers) == 0
            radii_right(1,i) = radii_right(1,i-1);
            area_pupil_right(1,i) = area_pupil_right(1,i-1);
        else
            x = centers(1,1);
            y = centers(1,2);
            radii_right(1,i) = diameters/2;
            radii_right(1,i) = radii_right(1,i);
            area_pupil_right(1,i) = pi * radii_right(1,i)^2;
        end
end
            
    