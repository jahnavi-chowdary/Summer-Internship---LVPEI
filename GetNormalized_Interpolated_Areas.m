function feature_vector = GetNormalized_Interpolated_Areas_FV_X(save_all_csv,view_all_plots,save_all_plots)

% This function reads the areas,state of light,times from the mat file  
% 'All_Areas_SOL_Times.mat', computes the normalized interpolated areas and
% 1. Saves them all as csv's in a new folder named CSV_Final if save_all_csv == 1.
% 2. Displays the scatter plots of each video one by one if view_all_plots == 1.
% 3. Saves all these plots in a folder named ScatterPlots_FInal if save_all_plots == 1.
% It then computes the feature vector which is nothing but a concatenation of the left and right areas.
% It saves the labels in a csv format in a folder named Final_XY_Vectors
feature_vector = [];
if save_all_csv == 1
    mkdir ('./','CSV_Final');
end

if save_all_plots == 1
    mkdir ('./','ScatterPlots_Final');
end

% mkdir ('./','Final_XY_Vectors'); % To store the final feature vectors and labels in a specified place.

% load('All_Areas_SOL_Times.mat')

% dir_seg = dir('./CSV/*.csv'); % Change 'Normal' to 'Abnormal'
% len = length(dir_seg);

len = size(csvread('./Area_SOL_Time_CSV/RawAreas_Right.csv'),1);
sizes_right = csvread('./Area_SOL_Time_CSV/Size_Right.csv');
sizes_left = csvread('./Area_SOL_Time_CSV/Size_Left.csv');

all_min = 100000000000;
all_max = 0;

% Note : If a standard min and max area is being used then this whole function is not required 
% min and max values will durectly be the standard value and the the direct interpolated area 1:450 can be stored in the CSV

% Obtaining the min and max areas from the available raw areas.

for i = 1 : len 
    l = csvread('./Area_SOL_Time_CSV/RawAreas_Left.csv',i-1,0,[i-1 0 i-1 (sizes_left(i,1)-1)]);
    r = csvread('./Area_SOL_Time_CSV/RawAreas_Right.csv',i-1,0,[i-1 0 i-1 (sizes_right(i,1)-1)]);
        
    m = max(length(l), length(r));
        
    % Insert zeros if the the lengths are different
    if length(l) ~= m
        l(length(l)+1:m) = 0;
    elseif length(r) ~= m
        r(length(r)+1:m) = 0;
    end
        
    areas = [l r];
            
    minimum = min(areas);
    maximum = max(areas);
         
    if minimum < all_min
        all_min = minimum;
    end
         
    if maximum > all_max
        all_max = maximum;
    end
       
end

% Obtaining the normalized interpolated areas which is nothing but the feature vector X

for i = 1 : len 

    l = csvread('./Area_SOL_Time_CSV/RawAreas_Left.csv',i-1,0,[i-1 0 i-1 (sizes_left(i,1)-1)]);
    r = csvread('./Area_SOL_Time_CSV/RawAreas_Right.csv',i-1,0,[i-1 0 i-1 (sizes_right(i,1)-1)]);
    
    % Min-max normalization of the areas
        
    l_area = (l - all_min) / (all_max - all_min);
    r_area = (r - all_min) / (all_max - all_min);
        
    l_time = csvread('./Area_SOL_Time_CSV/Times_Left.csv',i-1,0,[i-1 0 i-1 (sizes_left(i,1)-1)]);
    r_time = csvread('./Area_SOL_Time_CSV/Times_Right.csv',i-1,0,[i-1 0 i-1 (sizes_right(i,1)-1)]);
         
    xql = 0:57:max(l_time);
    xqr = 0:57:max(r_time);
    m = max(length(xql), length(xqr));
        
    % If the lengths don't match, insert zeros
        
    if length(xql) ~= m
       xql(length(xql)+1:m) = 0;
    elseif length(xqr) ~= m
       xqr(length(xqr)+1:m) = 0;
    end
        
    % Interpolation
        
    vq2l = interp1(l_time',l_area',xql,'spline');
    vq2r = interp1(r_time',r_area',xqr,'spline');
        
    feature_vector(i,:) = [vq2l(1,1:450) vq2r(1,1:450)];
    
%      try
%          p = csvread('./Final_XY_Vectors/FeatureVector_X.csv');
%          vary = 1;
%      catch err
%          dlmwrite('./Final_XY_Vectors/FeatureVector_X.csv',feature_vector);
%          vary = 0;
%      end
%      clear p;
%      if vary == 1
%         dlmwrite('./Final_XY_Vectors/FeatureVector_X.csv',feature_vector,'-append');
%         clear vary;
%      end
%      clear feature_vector;
     
    % ---------------------------- Additional Requirements ------------------------------------ %
    
    if save_all_csv == 1
        % Write a parameter - True/False whether to save the CSV in format
        % [left right time] for each of the video in separate files or not.
        % Note : Write the fullfile_name reading part here. 
            
        fname = dir_seg(i).name;  
        [ID rem1] = strtok(fname,'_');
        [Attempt rem2] = strtok(rem1,'_');
        [temp rem3] = strtok(rem2,'_');
        [Side rem4] = strtok(temp,'.');
    
        if strcmp(Side,'right')

            area_state_time = [vq2l' vq2r' xq'];
            fname_csv = strcat(ID,'_',Attempt,'.csv');
        
            dlmwrite(fullfile('./CSV_Final', fname_csv),area_state_time);
        else
            continue;
        end
    end
        
    %% Uncomment the below part of the code to get the plots

    if view_all_plots == 1
            
        fname = dir_seg(i).name;  
        [ID rem1] = strtok(fname,'_');
        [Attempt rem2] = strtok(rem1,'_');
        [temp rem3] = strtok(rem2,'_');
        [Side rem4] = strtok(temp,'.');
    
        if strcmp(Side,'right')

            % Write a parameter - True/False as to whether to View/save the
            % scatter plots or not 
            % Note : Write the fullfile_name reading part here.

            figure;
            scatter(xq, vq2, '.'); % Left -> Blue
            hold on

            scatter(xqr, vq2r, '*'); % Right -> green
            xlabel('Time in sec');
            ylabel('Area of Pupil'); 
        
            %For saving and returning the plot as an image, uncommment the below
                
            if save_all_plots == 1
                F = getframe(gcf);
                Image = F.cdata;
                plot_area = Image;
                fname_plot = strcat(ID,'_',Attempt,'_','plot','.jpg');
                imwrite(plot_area,fullfile('./ScatterPlots_Final',fname_plot));
            end

        else
            continue
        end
    end
end

