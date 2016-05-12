% The folder 'Abnormal' should contain the folders - CSV, CSV_interp, Plots,
% Plots_interp, Videos. 

clc;
clear all;

dir_seg = dir('../Abnormal/CSV/*.csv');
len = length(dir_seg);

all_areas = csvread('../Abnormal/All_area.csv');

l_min = min(all_areas(:,1));
r_min = min(all_areas(:,2));

l_max = max(all_areas(:,1));
r_max = max(all_areas(:,2));

for i = 1 : len
    
    clear area_state_time;
    fname = dir_seg(i).name;
    [ID rem1] = strtok(fname,'_');
    [Attempt rem2] = strtok(rem1,'_');
    [temp rem3] = strtok(rem2,'_');
    [Side rem4] = strtok(temp,'.');
    
    if strcmp(Side,'right')
        
        fname_right_txt = strcat(ID,'_',Attempt,'_','right','.csv');
        fname_left_txt = strcat(ID,'_',Attempt,'_','left','.csv');
        l_file = fullfile('../Abnormal/CSV', fname_left_txt);
        r_file = fullfile('../Abnormal/CSV', fname_right_txt);
        l = csvread(l_file);
        r = csvread(r_file);
%         Normalization of the areas
        l_area = (l(:,1) - l_min) / (l_max - l_min);
        r_area = (r(:,1) - r_min) / (l_max - l_min);
        l_time = l(:,2);
        r_time = r(:,2);
%         
        xq = 0:57:max(l_time);
        xqr = 0:57:max(r_time);
        m = max(length(xq), length(xqr));
%         If the lengths don't match, insert zeros
        if length(xq) ~= m
            xq(length(xq)+1:m) = 0;
        elseif length(xqr) ~= m
            xqr(length(xqr)+1:m) = 0;
        end
%         Interpolation
        vq2 = interp1(l_time,l_area,xq,'spline');
        vq2r = interp1(r_time,r_area,xqr,'spline');
        
        area_state_time = [vq2' vq2r' xq'];
        fname_right_csv = strcat(ID,'_',Attempt,'.csv');
        
        xlswrite(fullfile('../Abnormal/CSV_interp', fname_right_csv),area_state_time);
        
%         Uncomment the below part of the code to get the plots

%         figure;
% %         ys = smooth(xq, vq2, 0.1, 'rloess');
% %         plot(xq, ys, 'b', xq, vq2, 'b*')
%         scatter(xq, vq2, '.');
%         hold on
%     
% %         ys = smooth(xqr, vq2r, 0.1, 'rloess');
% %         plot(xqr, ys, 'r', xqr, vq2r, 'r*')
%         scatter(xqr, vq2r, '*');
%         xlabel('Time in sec');
%         ylabel('Area of Pupil'); 
% %     
% %         % Saving and returning the plot as an image
% %         F = getframe(gcf);
% %         Image = F.cdata;
% %         figure; imshow(Image);
% %         plot_area = Image;
% %     
% %         fname_plot = strcat(ID,'_',Attempt,'_','right','_','plot','.jpg');
% %         imwrite(plot_area,fullfile('../Abnormal/Plots_interp',fname_plot));

    else
        continue
    end
end
