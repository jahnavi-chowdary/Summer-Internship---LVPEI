clc;
clear;
close all;

dir_seg = dir('./Videos/*.avi');
len = length(dir_seg);
tic;

% Change save_all_csv to 1 if you want to save the csv's and similarly for
% the other 2 parameters.
save_all_csv = 0;
view_all_plots = 0;
save_all_plots = 0;

if save_all_csv == 1
    mkdir ('./','CSV');
end
if save_all_plots == 1
    mkdir ('./','Plots');
end

i = 1;

for k = 1:len
    
    clear area_pupil_right;
    clear area_pupil_left;
    clear area_state_right;
    clear area_state_left;
    
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
    time_rgt = [hour_right,min_right,sec_right];
    
    [hour_left var1 min_left var2 sec_left] = textread(fullfile('../Videos', fname_left_txt), '%d %c %d %c %f'); % Getting the Hour,Minutes,Seconds separately for the Left Eye
    time_lft = [hour_left,min_left,sec_left];
    
    % Getting the Area of Right and Left Eyes Pupils
    
    [area_pupil_right] = area_of_pupil(video_right);
    [area_pupil_left] = area_of_pupil(video_left);

    area_right = area_pupil_right(1,1:450);
    area_left = area_pupil_left(1,1:450);
    
    all_areas(i,:) = [area_right area_left];
    
    % Getting the State of Light for the Right and Left Videos 
    
    [state_of_light_right] = state_of_light_detect(video_right);
    [state_of_light_left] = state_of_light_detect(video_left);
    
    sol_right = state_of_light_right(1:450,1);
    sol_left = state_of_light_left(1:450,1);
    
    all_sol(i,:) = [state_of_light_right' state_of_light_right'];
    
    
    %% Shifting the starting of time values to zero (So that all the videos have a common origin)
    % To do so subtracting the time values with the value of the first
    % timestamp and finally obtaining the times in 'milliseconds'

    % Getting the timestamps of Right eye
    
    h = time_rgt(1,1);
    m = time_rgt(1,2);
    s = time_rgt(1,3);
    hour_right = time_rgt(:,1) - h; 
    min_right = time_rgt(:,2) - m;
    sec_right = time_rgt(:,3) - s;
    time_rgt = ((3600 .* hour_right) + (60 .* min_right) + sec_right) * 1000; 
    time_right = time_rgt(1:450,1); 
        
    % Getting the timestamps of Left eye
    
    h = time_lft(1,1);
    m = time_lft(1,2);
    s = time_lft(1,3);
    hour_left = time_lft(:,1) - h;
    min_left = time_lft(:,2) - m;
    sec_left = time_lft(:,3) - s;
    time_lft = ((3600 .* hour_left) + (60 .* min_left) + sec_left ) * 1000; 
    time_left = time_lft(1:450,1);

    all_times(i,:) = [time_right' time_left'];
    
    i = i+1;
    save('All_Areas_SOL_Times.mat','all_areas','all_sol','all_times');
     
    %% Getting the CSV in the Format required i.e 2 columns - 1st -> Area , 2nd -> Time in ms          
    if save_all_csv == 1

        area_state_time_right = [area_pupil_right' time_rgt  state_of_light_right];
        area_state_time_left = [area_pupil_left' time_lft state_of_light_left];
    
        fname_right_csv = strcat(ID,'_',Attempt,'_','right','.csv');
        fname_left_csv = strcat(ID,'_',Attempt,'_','left','.csv');
   
        dlmwrite(fullfile('./CSV', fname_right_csv),area_state_time_right);
        dlmwrite(fullfile('./CSV', fname_left_csv),area_state_time_left);

     end
    %% Plotting the Area of Right and Left Vs Time in ms
    if strcmp(view_all_plots , 'true')

        % figure;
        % Right Eye Area Vs Time
        ys = smooth(time_rgt,area_pupil_right,0.1,'rloess'); % This is used to smooth the curve for better visibility
        plot(time_rgt,ys,'r')
        hold on
    
        % Left Eye Area Vs Time
        ys = smooth(time_lft,area_pupil_left,0.1,'rloess'); % This is used to smooth the curve for better visibility
        plot(time_lft,ys,'b')
        hold on
    
        state_of_light_right = state_of_light_right * 10000 ;
        plot(time_rgt,state_of_light_right,'g')
        hold on
    
        state_of_light_left = state_of_light_left * 10000 ;
        plot(time_lft,state_of_light_left + 500,'y')
    
        xlabel('Time in milliseconds');
        ylabel('Area of Pupil');
        
        
        %% Saving the plot as an image in the folder named 'Plots'
        if strcmp(save_all_plots , 'true')
            % Write a parameter - True/False for wanting to save the Plots. (Note: Above parameter to view the plots also needs to be enabled)

            F = getframe(gcf);
            Image = F.cdata;
            plot_area = Image;
    
            fname_plot = strcat(ID,'_',Attempt,'_','_','plot','.jpg');
            imwrite(plot_area,fullfile('./Plots',fname_plot));
        end
    end
    else
        continue
    end
end

%% Getting the normalized interpolated areas for all the videos
% This function reads the areas from the csv files contained in the folder
% CSV (created above) , computes the normalized interpolated areas and
% saves them all as csv's in a folder named CSV_Final.
% Change save_all_csv to 1 if you want to save the csv's and similarly for
% the other 2 parameters.
save_all_csv = 0;
view_all_plots = 0;
save_all_plots = 0;

GetNormalized_Interpolated_Areas_1(save_all_csv,view_all_plots,save_all_plots);

%% Getting the labels Y
% This functions gets the labels of all the data from the ground truth
% given in the 'ID,Labels.txt'. Label for Normal = 1, Right diseased = 2, Left
% diseased = 3. It saves the labels in a csv format in a folder named
% Final_XY_Vectors
GetLabels_Y;

%% Training and Testing the system using Logistic Regression
% This function trains and tests the system using One-Vs-All Logistic
% Regression and returns the accuracies,confusion matrices and the data split
% for both the training and testing data.
% accuracies,data_split,CM are parameters and if equal to 1 they display the accuracies,data_split,confusion matrix 
%of train and test data 
trainset_size = 35;
testset_size = 34;
accuracies = 1;
data_split = 1;
CM = 1;

LogisticRegression(trainset_size,testset_size,accuracies,data_split,CM);

toc;

