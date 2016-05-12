function [state_of_light_right area_pupil_right] = get_areas(video_right)

numFrames_right = video_right.NumberOfFrames;
n = numFrames_right;
state_of_light_right = zeros(1,n);

for i = 1:1:n
        
    I = read(video_right,i);
        
    %Getting frames where light is on
    I_g = I(:,:,2);
    histo = imhist(I_g);
    amt_of_green = sum(histo((201:256),1));
    if amt_of_green > 2000
        state_of_light_right(1,i) = 1;
    end

    % Getting area of Pupil
    I = rgb2gray(I);
    [hei1 wid1] = size(I);
    I_2 = zeros(size(I));
   
%     From second frame, take a window around a point which
%     is the center of the bounding box of the previous frame.

    if i ~= 1
        
        c = floor(c1(i-1,:)); % Center of the previous frame
        rI = c(1); cI = c(2);
        winSize1 = (l1(i-1)+25); % Half of the height of the window = 1/2 (height of bounding box) + 25;
        winSize2 = (l2(i-1)+25); % Half of the width of the window = 1/2 (width of bounding box) + 25;
        rl = max(1,rI - winSize1); 
        cl = max(1,cI - winSize2); % (rl, cl) - top left corner point
        I_1 = I(cl:min((cl+2*winSize2),hei1),rl:min((rl+2*winSize1),wid1));
    
        [hei wid] = size(I_1);
        clear I_new;
        
%         Thresholding inside the window
        for k = 1:hei
            for j = 1:wid
                if I_1(k,j) < 70
                    I_new(k,j) = 1;
                else
                    I_new(k,j) = 0;
                end
            end
        end
        I_2(cl:min((cl+2*winSize2),hei1),rl:min((rl+2*winSize1),wid1)) = I_new;
        I_new = I_2;
    
    else
        I_2 = I;
        [hei wid] = size(I);
        for k = 1:hei
            for j = 1:wid
                if I_2(k,j) < 70
                    I_new(k,j) = 1;
                else
                    I_new(k,j) = 0;
                end
            end
        end
    end
       
    SE = strel('disk', 2);
    I_ne = imcomplement(I_new);
    I_dil = imdilate(I_ne,SE);
    I_temp = imcomplement(I_dil);
    I_fill = imfill(I_temp,'holes');
    BW = I_fill;
      
%     Getting the pupil region which is assumed to be the largest connected
%     component.
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
       
%     In case of blink, there is no center. So take the previous center and
%     the half dimensions of the bounding box
    if isempty(s.Centroid)
        c1(i,:) = c1(i-1,:);
        l1(i) = l1(i-1);
        l2(i) = l2(i-1);
    else
        c1(i,:) = s.Centroid;
        l1(i) = floor(s.BoundingBox(3)/2);
        l2(i) = floor(s.BoundingBox(4)/2);
    end
%     In case of a blink in the first frame, take center as the center of
%     the image and bounding box of size 200x200
    if (s.BoundingBox(3)*s.BoundingBox(4)) < 700
        c1(i,1) = floor(hei/2);
        c1(i,2) = floor(wid/2);
        l1(i) = 100;
        l2(i) = 100;
    end
    
%     In case of blink, previous frame's area is taken.
    if size(centers) == 0
        radii_right(1,i) = radii_right(1,i-1);
        area_pupil_right(1,i) = area_pupil_right(1,i-1);
    else
        x = centers(1,1);
        y = centers(1,2);
        radii_right(1,i) = diameters/2;
        radii_right(1,i) = radii_right(1,i) .* 0.264583333;
        area_pupil_right(1,i) = pi * radii_right(1,i)^2;
    end
            % Uncomment the below 6 lines to see the contour overlayed on
            % the pupil and write them into a file
            
            % imshow(I);
            % hold on;
            % contour(I_fill,'-r');
            % f=getframe(gca)
            % [X, map] = frame2im(f);
            % imwrite(X,fname2)
end

            
    
