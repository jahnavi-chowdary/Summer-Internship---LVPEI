function [state_of_light] = light_detect_bb2(video_right)

numFrames_right = video_right.NumberOfFrames;
n = numFrames_right;
len = n;

for i = 1:1:n
        
    I = read(video_right,i);
  
    I = rgb2gray(I);
    [hei1 wid1] = size(I);
    I_2 = zeros(size(I));
    I_new1 = zeros(size(I));
    [hei wid] = size(I);

    for k = 1:hei
        for j = 1:wid
            if I(k,j) > 210
                I_new1(k,j) = 1;
            else
                I_new1(k,j) = 0;
            end
        end
    end
    
    SE1 = strel('disk', 2);
    I_ne1 = imcomplement(I_new1);
    I_dil1 = imdilate(I_ne1,SE1);
    SE2 = strel('disk', 3);
    I_er1 = imerode(I_dil1, SE2);
    I_temp1 = imcomplement(I_er1);
    
    
    if i ~= 1
        
        c = floor(c1(i-1,:)); % Center of the previous frame
        rI = c(1); cI = c(2);
        winSize1 = (l1(i-1)+50); % Half of the height of the window = 1/2 (height of bounding box) + 25;
        winSize2 = (l2(i-1)+50); % Half of the width of the window = 1/2 (width of bounding box) + 25;
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
    BW1 = BW;
    CC = bwconncomp(BW);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggest,idx] = max(numPixels);
    BW(CC.PixelIdxList{idx}) = 0;
    Ir = imsubtract(BW1,BW);
    D1 = Ir;
    [Ilabel num] = bwlabel(D1);
    
    imshow(D1);
    for cnt = 1:num
        s = regionprops(Ilabel, 'BoundingBox', 'Area', 'Centroid','MajorAxisLength','MinorAxisLength');
    end
%     
%     diameters = mean([s.MajorAxisLength s.MinorAxisLength],2);
%     centers = s.Centroid;
       
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
    
    if i ~= 1
        c = floor(c1(i-1,:)); % Center of the previous frame
        rI = c(1); cI = c(2);
        winSize1 = (l1(i-1)+50); % Half of the height of the window = 1/2 (height of bounding box) + 25;
        winSize2 = (l2(i-1)+50); % Half of the width of the window = 1/2 (width of bounding box) + 25;
        rl = max(1,rI - winSize1); 
        cl = max(1,cI - winSize2); % (rl, cl) - top left corner point
        I_1 = I_temp1(cl:min((cl+2*winSize2),hei1),rl:min((rl+2*winSize1),wid1));
        
        [Ilabel num] = bwlabel(I_1);
        cc_length(i) = length(find(I_1 == 1));
        n_circles(i) = num;

% %         Uncomment below to get the image with the bounding box around
% %         the required patch  

%         bb = [rl cl min((2*winSize2),hei1) min((2*winSize1),wid1)];
%         imshow(I_temp1)
%         rectangle('position', bb,'EdgeColor','r','linewidth',2);
%         f=getframe(gca);
%         [X, map] = frame2im(f);
%         imwrite(X,['Image' int2str(i), '.jpg']);
%          
    else
        c = floor(c1);
        rI = c(1); cI = c(2);
        winSize1 = l1(1)+50;
        winSize2 = l2(1)+50;
        rl = max(1,rI - winSize1); 
        cl = max(1,cI - winSize2); 
        I_1 = I_temp1(cl:min((cl+2*winSize2),hei1),rl:min((rl+2*winSize1),wid1));

        [Ilabel num] = bwlabel(I_1);
        cc_length(i) = length(find(I_1 == 1));
        n_circles(i) = num;

% %         Uncomment below to get the image with the bounding box around
% %         the required patch  

%         bb = [rl cl min((2*winSize2),hei1) min((2*winSize1),wid1)];
%         imshow(I_temp1)
%         rectangle('position', bb,'EdgeColor','r','linewidth',2);
%         f=getframe(gca);
%         [X, map] = frame2im(f);
%         imwrite(X,['Image' int2str(i), '.jpg']);
    end
    
end

state_of_light = zeros(1,len);
m = mean(cc_length);

for l = 1 : len
   if n_circles(l) <= 3 
%     if cc_length(l) < m
       state_of_light(l) = 0;
   elseif n_circles(l) > 3
%     elseif cc_length(l) > m
       state_of_light(l) = 1;
   end
end
sol_original = state_of_light;

for l = 1 : len
   if state_of_light(l) < 0
       if cc_length(l) > m
           state_of_light(l) = -sol_original(l);
       end   
   end
end

m1 = mean(cc_length(state_of_light > 0));
m2 = mean(cc_length(state_of_light < 0));

for l = 1 : len
   if state_of_light(l) > 0
       if cc_length(l) < m2
           state_of_light(l) = -sol_original(l);
       end   
   end
   if state_of_light(l) < 0
       if cc_length(l) > m1
           state_of_light(l) = -sol_original(l);
       end   
   end
end

for l = 2 : len-1
    if cc_length(l) > cc_length(l-1) && cc_length(l) > cc_length(l+1) && cc_length(l) > m
        state_of_light(l) = state_of_light(l-1);
    end
end

o1 = 1;
for l = 2 : len-1
    if cc_length(l) < cc_length(l-1) && cc_length(l) < cc_length(l+1) && cc_length(l) < m
        state_of_light(l) = state_of_light(l-1);
    end
end

state_of_light = state_of_light';            
