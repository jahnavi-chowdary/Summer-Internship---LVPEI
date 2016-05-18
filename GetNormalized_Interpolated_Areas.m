function GetNormalized_Interpolated_Areas(save_all_csv,view_all_plots,save_all_plots)

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

mkdir ('./','Final_XY_Vectors'); % To store the final feature vectors and labels in a specified place.

% load('All_Areas_SOL_Times.mat')

dir_seg = dir('./CSV/*.csv'); % Change 'Normal' to 'Abnormal'
len = length(dir_seg);
all_areas = [];

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
  
        l = csvread(fullfile('./CSV', fname_right_txt));
        r = csvread(fullfile('./CSV', fname_left_txt));
        
        m = max(length(l), length(r));
        
        %         Insert zeros if the the lengths are different
        if length(l) ~= m
            l(length(l)+1:m) = 0;
        elseif length(r) ~= m
            r(length(r)+1:m) = 0;
        end
        
         areas = [l r];
%         Concatenate the areas
        all_areas = [all_areas; areas];
                                                                                    
    else
        continue
    end
    
end

mkdir ('./','CSV_Final')

l_min = min(all_areas(:,1));
r_min = min(all_areas(:,2));

l_max = max(all_areas(:,1));
r_max = max(all_areas(:,2));


k = 1;
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
        l = csvread(fullfile('./CSV', fname_left_txt));
        r = csvread(fullfile('./CSV', fname_right_txt));
        
        
        % Min-max normalization of the areas
        
        l_area = (l(:,1) - l_min) / (l_max - l_min);
        r_area = (r(:,1) - r_min) / (l_max - l_min);
        l_time = l(:,2);
        r_time = r(:,2);
         
        xq = 0:57:max(l_time);
        xqr = 0:57:max(r_time);
        m = max(length(xq), length(xqr));
        
        % If the lengths don't match, insert zeros
        
        if length(xq) ~= m
            xq(length(xq)+1:m) = 0;
        elseif length(xqr) ~= m
            xqr(length(xqr)+1:m) = 0;
        end
        
        % Interpolation
        
        vq2l = interp1(l_time,l_area,xq,'spline');
        vq2r = interp1(r_time,r_area,xqr,'spline');
        
        feature_vector(k,:) = [vq2l(1,1:450) vq2r(1,1:450)];
        k = k+1;
        

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
dlmwrite('./Final_XY_Vectors/FeatureVector_X.csv',feature_vector);
end
