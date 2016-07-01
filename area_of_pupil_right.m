function area_of_pupil_right_new(im_rgt)
    display('Calculating Area_of_RightPupil...')
    global x_right;
    global y_right;
    global area_pupil_right;
    global initial_blink_right;
    global im_right;
    global time_right;
    global tstampstr_right;

    len = size(im_rgt,2); 
    actual_len_right = len;
    sampling_rate_right = ceil(len/350);
%     var = [1:len];
%     var = downsample(var,new_len);
%     im_lft = im_lft(var); 
    im_rgt = downsample(im_rgt,sampling_rate_right);
    im_right = im_rgt;
    time_right = downsample(time_right,sampling_rate_right);
    tstampstr_right = downsample(tstampstr_right,sampling_rate_right);
    
    area_pupil_right = [];
    
    len = size(im_rgt,2);
    % Getting area of Pupil
    for i = 1:len
        
        I = im_rgt{1,i}; 

        % imshow(I);
        % hold on
        [hei_I, wid_I ,dim_I] = size(I);
        if i == 1
            I_1 = I;
            
            I_1 = rgb2gray(I_1);
            I_2 = zeros(size(hei_I , wid_I));
            
            clear I_new;
            I_new = zeros(size(I_1));
            I_new(I_1<70) = 1;
            
            SE = strel('disk', 2);
            
            I_2 = imfill(imcomplement(imdilate(imcomplement(I_new),SE)),'holes');
            
        else
            rI = floor(x_right); cI = floor(y_right);
            % plot(x_right,y_right,'*');
            
            winSize1 = 100;
            winSize2 = 100;
            rl = max(1,rI - winSize1);
            cl = max(1,cI - winSize2);
            I_1 = I(cl:min(hei_I,(cl+2*winSize2)),rl:min(wid_I,(rl+2*winSize1)),:);
            
            I_1 = rgb2gray(I_1);
            I_2 = zeros(size(hei_I , wid_I));
            
            clear I_new;
            I_new = zeros(size(I_1));
            I_new(I_1<70) = 1;
            
            SE = strel('disk', 2);
            
            I_2(cl:min(hei_I,(cl+2*winSize2)),rl:min(wid_I,(rl+2*winSize1))) = imfill(imcomplement(imdilate(imcomplement(I_new),SE)),'holes');
            
        end
        
        
        BW = I_2;
        
        CC = bwconncomp(BW);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        [biggest,idx] = max(numPixels);
        BW(CC.PixelIdxList{idx}) = 0;
        D1 = imsubtract(I_2,BW);

        [Ilabel, num] = bwlabel(D1);
   
        if num == 0
        
            if ( size(area_pupil_right,2) == 0 )
                initial_blink_right = 1;
                area_pupil_right(1,1) = 0;
            else
                tmp = area_pupil_right(1,size(area_pupil_right,2));
                area_pupil_right = [area_pupil_right, tmp];
            end
    
        else
        
            for cnt = 1:num
                s = regionprops(Ilabel, 'BoundingBox', 'Area', 'Centroid','MajorAxisLength','MinorAxisLength');
                % rectangle('position', s(cnt).BoundingBox,'EdgeColor','r','linewidth',1);
                % pause(0.0001)
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
        end
    end
    assignin('base','area_pupil_right',area_pupil_right);
      
    if initial_blink_right == 1
        area_pupil_right(1,1) = area_pupil_right(1,2);
    end
    
    display('Area_of_RightPupil Computation Completed!!!')
end
    