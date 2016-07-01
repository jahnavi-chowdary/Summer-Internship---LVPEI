function area_of_pupil_left_new(im_lft)
    display('Calculating Area_of_LeftPupil...')
    global x_left;
    global y_left;
    global area_pupil_left;
    global initial_blink_left;
    global im_left;
    global time_left;
    global tstampstr_left;
    
    len = size(im_lft,2); 
    actual_len_left = len;
    sampling_rate_left = ceil(len/350);
%     var = [1:len];
%     var = downsample(var,new_len);
%     im_lft = im_lft(var); 
    im_lft = downsample(im_lft,sampling_rate_left);
    im_left = im_lft;
    time_left = downsample(time_left,sampling_rate_left);
    tstampstr_left = downsample(tstampstr_left,sampling_rate_left);
    
    area_pupil_left = [];
    
    len = size(im_lft,2);
    % Getting area of Pupil
    
    for i = 1:len
        
        I = im_lft{1,i}; 
       
        % imshow(I);
        % hold on
        [hei_I, wid_I , dim_I] = size(I);
        
        if i == 1
            I_1 = I;   
            
            I_1 = rgb2gray(I_1);
            I_2 = zeros(hei_I , wid_I);
            
            clear I_new;
            I_new = zeros(size(I_1));
            I_new(I_1<70) = 1;
            
            SE = strel('disk', 2);
            
            I_2 = imfill(imcomplement(imdilate(imcomplement(I_new),SE)),'holes');

            
        else          
            rI = floor(x_left); cI = floor(y_left);
            % plot(x_left,y_left,'*');
            
            winSize1 = 100;
            winSize2 = 100;
            rl = max(1,rI - winSize1);
            cl = max(1,cI - winSize2);
            I_1 = I(cl:min(hei_I,(cl+2*winSize2)),rl:min(wid_I,(rl+2*winSize1)),:);      
            
            I_1 = rgb2gray(I_1);
            I_2 = zeros(hei_I , wid_I);
            
            clear I_new;
            I_new = zeros(size(I_1));
            I_new(I_1<70) = 1;
            
            SE = strel('disk', 2);
            
            I_2(cl:min(hei_I,(cl+2*winSize2)),rl:min(wid_I,(rl+2*winSize1))) = imfill(imcomplement(imdilate(imcomplement(I_new),SE)),'holes');
            
            
        end
        
        BW = I_2;
        size(BW);
        
        CC = bwconncomp(BW);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        [biggest,idx] = max(numPixels);
        BW(CC.PixelIdxList{idx}) = 0;
        D1 = imsubtract(I_2,BW);

        [Ilabel, num] = bwlabel(D1);
        if num == 0
        
            if ( size(area_pupil_left,2) == 0 )
                initial_blink_left = 1;
                area_pupil_left(1,1) = 0;
            else
                tmp = area_pupil_left(1,size(area_pupil_left,2));
                area_pupil_left = [area_pupil_left, tmp];
            end
        else
            for cnt = 1:num
                s = regionprops(Ilabel, 'BoundingBox', 'Area', 'Centroid','MajorAxisLength','MinorAxisLength');
                % rectangle('position', s(cnt).BoundingBox,'EdgeColor','b','linewidth',1);
                % pause(0.0001)
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
        end
    end
    assignin('base','area_pupil_left',area_pupil_left);
    
    if initial_blink_left == 1
        area_pupil_left(1,1) = area_pupil_left(1,2);
    end
    
    display('Area_of_LeftPupil Computation Completed!!!');
end