clc; clear; close all;

% For Abnormal, change the 'Normal' in the paths to 'Abnormal'

dir_seg = dir('../Normal/Videos/*.avi'); 
len = length(dir_seg);

for k = 1:len
    
    clear area_pupil_right;
    clear area_pupil_left;
    clear state_of_light_right;
    clear state_of_light_left;
    clear area_state_right;
    clear area_state_left;
    
    % Get the User ID , the attempt number , Which eye the test is being done on.
    % Ex : N284524_0_left => ID = N284534 , Attempt = 0 , Side = Left
    % These are Used to name the CSV files and the Plots.
    
    fname = dir_seg(k).name;
    [ID rem1] = strtok(fname,'_');
    [Attempt rem2] = strtok(rem1,'_');
    [temp rem3] = strtok(rem2,'_');
    [Side rem4] = strtok(temp,'.');
    
    % If the Video is a Right Eye Video -> Do the processing, i.e get the areas of both the Right Eye and Left eye of that particular user and 
    % plot both the areas across time.
    
    % It the Video is a Left Eye Video -> Ignore (because the Left Eye videos are automatically processed along with the Right Eye videos and 
    % we do not want it to be processed twice.)
    
    if strcmp(Side,'right')
        
    fname_right = strcat(ID,'_',Attempt,'_','right','.avi');
    fname_left = strcat(ID,'_',Attempt,'_','left','.avi');

    video_right = VideoReader(fullfile('../Normal/Videos', fname_right)); % Reading the Right Eye Video
    video_left = VideoReader(fullfile('../Normal/Videos', fname_left)); % Reading the Left Eye Video
    
    fname_right_txt = strcat(ID,'_',Attempt,'_','right','.txt'); % Reading the timestamps corresponding to the Right Eye.
    fname_left_txt = strcat(ID,'_',Attempt,'_','left','.txt'); % Reading the timestamps corresponding to the Left Eye.
    
    [hour_right var1 min_right var2 sec_right] = textread(fullfile('../Normal/Videos', fname_right_txt), '%d %c %d %c %f'); % Getting the Hour,Minutes,Seconds separately for the Right Eye
    time_right = [hour_right,min_right,sec_right];
    
    [hour_left var1 min_left var2 sec_left] = textread(fullfile('../Normal/Videos', fname_left_txt), '%d %c %d %c %f'); % Getting the Hour,Minutes,Seconds separately for the Left Eye
    time_left = [hour_left,min_left,sec_left];
    
    [area_pupil_right] = samples_new_j(video_right);
    [area_pupil_left] = samples_new_j(video_left);
    
    [state_of_light_right] = light_detect_bb2(video_right);
    [state_of_light_left] = light_detect_bb2(video_left);
    
    
%     % Shifting the starting of time values to zero (So that all the videos have a common origin)
%     % To do so subtracting the time values with the value of the first
%     % timestamp and finally obtaining the times in 'milliseconds'
% 
%     % Getting the timestamps of Right eye
    
    h = time_right(1,1);
    m = time_right(1,2);
    s = time_right(1,3);
    hour_right = time_right(:,1) - h; 
    min_right = time_right(:,2) - m;
    sec_right = time_right(:,3) - s;
    time_right = ((3600 .* hour_right) + (60 .* min_right) + sec_right) * 1000; 
        
%     % Getting the timestamps of Left eye
    
    h = time_left(1,1);
    m = time_left(1,2);
    s = time_left(1,3);
    hour_left = time_left(:,1) - h;
    min_left = time_left(:,2) - m;
    sec_left = time_left(:,3) - s;
    time_left = ((3600 .* hour_left) + (60 .* min_left) + sec_left ) * 1000; 
            
%    % Getting the CSV in the Format required i.e 3 columns - 1st -> Area , 2nd -> Time in ms          

    area_state_time_right = [area_pupil_right' time_right  state_of_light_right];
    area_state_time_left = [area_pupil_left' time_left state_of_light_left];
    
    fname_right_csv = strcat(ID,'_',Attempt,'_','right','.csv');
    fname_left_csv = strcat(ID,'_',Attempt,'_','left','.csv');
    
    xlswrite(fullfile('../Normal/CSV_new', fname_right_csv),area_state_time_right);
    xlswrite(fullfile('../Normal/CSV_new', fname_left_csv),area_state_time_left);
    
% %     area_pupil_right = area_pupil_right ./ 1000;
% %     area_pupil_left = area_pupil_left ./1000 ;
    
%     % Plotting the Area of Right and Left
    r_area = csvread(fullfile('../Normal/CSV', fname_right_csv));
    l_area = csvread(fullfile('../Normal/CSV', fname_left_csv));
    area_pupil_right = r_area(:,1);
    area_pupil_left = l_area(:,1);
    
    figure;
    ys = smooth(time_right,area_pupil_right,0.1,'rloess');
    plot(time_right,ys,'r')
    hold on
    
    ys = smooth(time_left,area_pupil_left,0.1,'rloess');
    plot(time_left,ys,'b')
    hold on
    
    state_of_light_right = state_of_light_right * 10000 ;
    plot(time_right,state_of_light_right,'g')
    hold on
    
    state_of_light_left = state_of_light_left * 10000 ;
    plot(time_left,state_of_light_left + 500,'y')
    
    xlabel('Time in milliseconds');
    ylabel('Area of Pupil');
    
% % Saving and returning the plot as an image
    F = getframe(gcf);
    Image = F.cdata;
%     figure; imshow( Image );
    plot_area = Image;
    
    fname_plot = strcat(ID,'_',Attempt,'_','right','_','plot','.jpg');
    imwrite(plot_area,fullfile('../Normal/Plots_new',fname_plot));
   
    else
        continue
    end
end