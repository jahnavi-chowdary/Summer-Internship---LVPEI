clc;
clear;
close all;

dir_seg = dir('../Videos/*.avi');
len = length(dir_seg);
tic;
for k = 1:len
    
    clear area_pupil_right;
    clear area_pupil_left;
    
    %% Get the User ID , the attempt number , Which eye the test is being done on.
    % Ex : N284524_0_left => ID = N284534 , Attempt = 0 , Side = Left
    % These are Used to name the CSV files and the Plots.
    
    fname = dir_seg(k).name;
    [ID rem1] = strtok(fname,'_');
    [Attempt rem2] = strtok(rem1,'_');
    [temp rem3] = strtok(rem2,'_');
    [Side rem4] = strtok(temp,'.');
    
    % If the Video is a Right Eye Video -> Do the processing, i.e get the areas of both the Right Eye and Left eye of that particular user and 
    % plot both the areas across time.
    
    % If the Video is a Left Eye Video -> Ignore (because the Left Eye videos are automatically processed along with the Right Eye videos and 
    % we do not want it to be processed twice.)
    
    if strcmp(Side,'right')
        
    fname_right = strcat(ID,'_',Attempt,'_','right','.avi');
    fname_left = strcat(ID,'_',Attempt,'_','left','.avi');

    video_right = VideoReader(fullfile('../Videos', fname_right)); % Reading the Right Eye Video
    video_left = VideoReader(fullfile('../Videos', fname_left)); % Reading the Left Eye Video
    
    fname_right_txt = strcat(ID,'_',Attempt,'_','right','.txt'); % Reading the timestamps corresponding to the Right Eye.
    fname_left_txt = strcat(ID,'_',Attempt,'_','left','.txt'); % Reading the timestamps corresponding to the Left Eye.
    
    [hour_right var1 min_right var2 sec_right] = textread(fullfile('../Videos', fname_right_txt), '%d %c %d %c %f'); % Getting the Hour,Minutes,Seconds separately for the Right Eye
    time_right = [hour_right,min_right,sec_right];
    
    [hour_left var1 min_left var2 sec_left] = textread(fullfile('../Videos', fname_left_txt), '%d %c %d %c %f'); % Getting the Hour,Minutes,Seconds separately for the Left Eye
    time_left = [hour_left,min_left,sec_left];
    
    % Getting the Area of Right and Left Eyes Pupils
    
    [area_pupil_right] = area_of_pupil(video_right);
    [area_pupil_left] = area_of_pupil(video_left);
    
    %% Shifting the starting of time values to zero (So that all the videos have a common origin)
    % To do so subtracting the time values with the value of the first
    % timestamp and finally obtaining the times in 'milliseconds'

    % Getting the timestamps of Right eye
    
    h = time_right(1,1);
    m = time_right(1,2);
    s = time_right(1,3);
    hour_right = time_right(:,1) - h; 
    min_right = time_right(:,2) - m;
    sec_right = time_right(:,3) - s;
    time_right = ((3600 .* hour_right) + (60 .* min_right) + sec_right) * 1000; 
        
    % Getting the timestamps of Left eye
    
    h = time_left(1,1);
    m = time_left(1,2);
    s = time_left(1,3);
    hour_left = time_left(:,1) - h;
    min_left = time_left(:,2) - m;
    sec_left = time_left(:,3) - s;
    time_left = ((3600 .* hour_left) + (60 .* min_left) + sec_left ) * 1000; 

    %% Getting the CSV in the Format required i.e 2 columns - 1st -> Area , 2nd -> Time in ms          

    area_time_right = [area_pupil_right' time_right];
    area_time_left = [area_pupil_left' time_left];
    
    fname_right_csv = strcat(ID,'_',Attempt,'_','right','.csv');
    fname_left_csv = strcat(ID,'_',Attempt,'_','left','.csv');
    
    xlswrite(fullfile('../CSV', fname_right_csv),area_time_right);
    xlswrite(fullfile('../CSV', fname_left_csv),area_time_left);
     
    %% Plotting the Area of Right and Left Vs Time in ms
    
    figure;
    % Right Eye Area Vs Time
    ys = smooth(time_right,area_pupil_right,0.1,'rloess'); % This is used to smooth the curve for better visibility
    plot(time_right,ys,'r')
    hold on
    
    % Left Eye Area Vs Time
    ys = smooth(time_left,area_pupil_left,0.1,'rloess'); % This is used to smooth the curve for better visibility
    plot(time_left,ys,'b')
    hold on
    
    xlabel('Time in milliseconds');
    ylabel('Area of Pupil');
    
    %% Saving the plot as an image in the folder named 'Plots'
    F = getframe(gcf);
    Image = F.cdata;
    plot_area = Image;
    
    fname_plot = strcat(ID,'_',Attempt,'_','_','plot','.jpg');
    imwrite(plot_area,fullfile('../Plots',fname_plot));
    else
        continue
    end
end
toc;
