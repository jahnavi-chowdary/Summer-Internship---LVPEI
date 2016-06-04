function stop_record(~, ~, val)
% A simple function to update the value of hte global variable record,
% which is read by the process_videos_func callback function which is
% called every time the preview window updates. THis will tell it to start
% and stop the test.
display('STOP Record')
global record;
global arduino;
global stop;
global area_pupil_left;
global time_left;
global area_pupil_right
global time_right
global im_left;
global im_right;

record = 0;
stop = str2num(val);

fprintf(arduino, 'x') ;

time_left = time_left - time_left(1,1);
time_right = time_right - time_right(1,1);

imrightsize = size(im_right)
time_r = size(time_right)

imleftsize = size(im_left)
time_l = size(time_left)

assignin('base', 'im_left', im_left);
assignin('base', 'im_right', im_right);
assignin('base','time_right',time_right);
assignin('base','time_left',time_left);

display('Values assigned to workspace')

tic
% subplot(1,2,1)
% hold on
area_of_pupil_left(im_left);
 
% subplot(1,2,2)
% hold on
area_of_pupil_right(im_right);

ys = smooth(time_left,area_pupil_left,0.1,'rloess'); % This is used to smooth the curve for better visibility
figure ;
plot(time_left,ys,'b')

ys = smooth(time_right,area_pupil_right,0.1,'rloess'); % This is used to smooth the curve for better visibility
figure; 
plot(time_right,ys,'r')
toc;

% tic
% % Saving the Videos
% getvideo(im_left,im_right);
% display('Videos saved')
% toc;

pause(8)
            
% Now what to do with the obtained new data
            
choice = questdlg('Would you like to use this data for Retraining the System ?','Action on Data' , 'Yes' , 'No, TEST this data instead' , 'No , DISCARD this data' , 'Yes');
            
switch choice
    case 'Yes'                
        
        try
            p = csvread('./Area_SOL_Time_CSV/RawAreas_Left.csv');
            vary = 1;
        catch err
            dlmwrite('./Area_SOL_Time_CSV/RawAreas_Left.csv',area_pupil_left);
            vary = 0;
        end
        clear p;
        if vary ==1
            dlmwrite('./Area_SOL_Time_CSV/RawAreas_Left.csv',area_pupil_left,'-append');
            clear vary;
        end
        
        try
            p = csvread('./Area_SOL_Time_CSV/Size_Left.csv');
            vary = 1;
        catch err
            dlmwrite('./Area_SOL_Time_CSV/Size_Left.csv',size(area_pupil_left,2));
            vary = 0;
        end
        clear p;
        if vary == 1
            dlmwrite('./Area_SOL_Time_CSV/Size_Left.csv',size(area_pupil_left,2),'-append');
            clear vary;
        end
        
        try
            p = csvread('./Area_SOL_Time_CSV/Times_Left.csv');
            vary = 1;
        catch err
            dlmwrite('./Area_SOL_Time_CSV/Times_Left.csv',time_left);
            vary = 0;
        end
        clear p;
        if vary == 1
            dlmwrite('./Area_SOL_Time_CSV/Times_Left.csv',time_left,'-append');
            clear vary;
        end
        clear time_left;
        
        try
            p = csvread('./Area_SOL_Time_CSV/RawAreas_Right.csv');
            vary = 1;
        catch err
            dlmwrite('./Area_SOL_Time_CSV/RawAreas_Right.csv',area_pupil_right);
            vary = 0;
        end
        clear p;
        if vary == 1
            dlmwrite('./Area_SOL_Time_CSV/RawAreas_Right.csv',area_pupil_right,'-append'); 
            clear vary;
        end
        
        try
            p = csvread('./Area_SOL_Time_CSV/Size_Right.csv');
            vary = 1;
        catch err
            dlmwrite('./Area_SOL_Time_CSV/Size_Right.csv',size(area_pupil_right,2));
            vary = 0;
        end
        clear p;
        if vary == 1
            dlmwrite('./Area_SOL_Time_CSV/Size_Right.csv',size(area_pupil_right,2),'-append');
            clear vary;
        end
        
        try
            p = csvread('./Area_SOL_Time_CSV/Times_Right.csv');
            vary = 1;
        catch err
            dlmwrite('./Area_SOL_Time_CSV/Times_Right.csv',time_right);
            vary = 0;
        end
        clear p;
        if vary == 1
            dlmwrite('./Area_SOL_Time_CSV/Times_Right.csv',time_right,'-append');
            clear vary;
        end
        clear time_right;
        
        % Here need to update the training module
%         feature_vector = GetNormalized_Interpolated_Areas(0,0,0);
%         
%         if (exist('./Final_XY_Vectors/FeatureVector_X.csv','file') == 2)
%             delete('./Final_XY_Vectors/FeatureVector_X.csv');
%         end
%         dlmwrite('./Final_XY_Vectors/FeatureVector_X.csv',feature_vector);
%         
%         display('Feature Vector calculation completed');
        
        % TO DO : Get the train set and test set size
        % trainset_size = ?
        % testset_size = ?
        accuracies = 1;
        data_split = 1;
        CM = 1;
        % LogisticRegression(trainset_size,testset_size,accuracies,data_split,CM)
        
    case 'No, TEST this data instead'
        
        try
            p = csvread('./Area_SOL_Time_CSV/RawAreas_Left.csv');
            vary = 1;
        catch err
            dlmwrite('./Area_SOL_Time_CSV/RawAreas_Left.csv',area_pupil_left);
            vary = 0;
        end
        clear p;
        if vary ==1
            dlmwrite('./Area_SOL_Time_CSV/RawAreas_Left.csv',area_pupil_left,'-append');
            clear vary;
        end
        
        try
            p = csvread('./Area_SOL_Time_CSV/Size_Left.csv');
            vary = 1;
        catch err
            dlmwrite('./Area_SOL_Time_CSV/Size_Left.csv',size(area_pupil_left,2));
            vary = 0;
        end
        clear p;
        if vary == 1
            dlmwrite('./Area_SOL_Time_CSV/Size_Left.csv',size(area_pupil_left,2),'-append');
            clear vary;
        end
        
        try
            p = csvread('./Area_SOL_Time_CSV/Times_Left.csv');
            vary = 1;
        catch err
            dlmwrite('./Area_SOL_Time_CSV/Times_Left.csv',time_left);
            vary = 0;
        end
        clear p;
        if vary == 1
            dlmwrite('./Area_SOL_Time_CSV/Times_Left.csv',time_left,'-append');
            clear vary;
        end
        
        try
            p = csvread('./Area_SOL_Time_CSV/RawAreas_Right.csv');
            vary = 1;
        catch err
            dlmwrite('./Area_SOL_Time_CSV/RawAreas_Right.csv',area_pupil_right);
            vary = 0;
        end
        clear p;
        if vary == 1
            dlmwrite('./Area_SOL_Time_CSV/RawAreas_Right.csv',area_pupil_right,'-append'); 
            clear vary;
        end
        
        try
            p = csvread('./Area_SOL_Time_CSV/Size_Right.csv');
            vary = 1;
        catch err
            dlmwrite('./Area_SOL_Time_CSV/Size_Right.csv',size(area_pupil_right,2));
            vary = 0;
        end
        clear p;
        if vary == 1
            dlmwrite('./Area_SOL_Time_CSV/Size_Right.csv',size(area_pupil_right,2),'-append');
            clear vary;
        end
        
        try
            p = csvread('./Area_SOL_Time_CSV/Times_Right.csv');
            vary = 1;
        catch err
            dlmwrite('./Area_SOL_Time_CSV/Times_Right.csv',time_right);
            vary = 0;
        end
        clear p;
        if vary == 1
            dlmwrite('./Area_SOL_Time_CSV/Times_Right.csv',time_right,'-append');
            clear vary;
        end
        
        
        % Use the existing theta values and get the predicted value.
%        feature_vector = GetNormalized_Interpolated_Areas(0,0,0);
%        
%        if (exist('./Final_XY_Vectors/FeatureVector_X.csv','file') == 2)
%            delete('./Final_XY_Vectors/FeatureVector_X.csv');
%        end
%        dlmwrite('./Final_XY_Vectors/FeatureVector_X.csv',feature_vector);
%        
%        display('Feature Vector calculation completed');
%        all_X = csvread('./Final_XY_Vectors/FeatureVector_X.csv');
%        test_X = all_X(size(all_X,1),:);
        % predicted_label = Test_Data(test_X);
        % display(predicted_label);
        
    case 'No , DISCARD this data'
        % Delete the label from the Labels_Y.csv
        
        row = size(csvread('./Final_XY_Vectors/Labels_Y.csv'),1);
        dlmwrite('./Final_XY_Vectors/Labels_Y.csv',[dlmread('./Final_XY_Vectors/Labels_Y.csv',',',[0 0 row-2 0]);[]],',');
        display('Corresponding Label deleted');
end
