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
global tstampstr_left;
global tstampstr_right;

record = 0;
stop = str2num(val);

fprintf(arduino, 'x') ;

time_left = time_left - time_left(1,1);
time_right = time_right - time_right(1,1);

var_left = time_left(1,2:size(time_left,2));
diff_left = var_left - time_left(1,1:(size(time_left,2)-1));
avgtimediff_left = mean(diff_left)

var_right = time_right(1,2:size(time_right,2));
diff_right = var_right - time_right(1,1:(size(time_right,2)-1));
avgtimediff_right = mean(diff_right)

imrightsize = size(im_right);
time_r = size(time_right)

imleftsize = size(im_left);
time_l = size(time_left)

assignin('base', 'im_left', im_left);
assignin('base', 'im_right', im_right);
assignin('base','tstampstr_right',tstampstr_right);
assignin('base','tstampstr_left',tstampstr_left);

tic

figure('Name','Left Pupil')
area_of_pupil_left(im_left);
close('Left Pupil')

figure('Name','Right Pupil')
area_of_pupil_right(im_right);
close('Right Pupil')

ys = smooth(time_left,area_pupil_left,0.1,'rloess'); % This is used to smooth the curve for better visibility
figure ;
plot(time_left,ys,'b')
hold on

ys = smooth(time_right,area_pupil_right,0.1,'rloess'); % This is used to smooth the curve for better visibility
plot(time_right,ys,'r')
toc;

pause(8)
            
% Now what to do with the obtained new data
            
choice = questdlg('Would you like to use this data for Retraining the System ?','Action on Data' , 'Yes' , 'No, TEST this data instead' , 'No , DISCARD this data' , 'Yes');
            
switch choice
    case 'Yes'                
        
        dlmwrite('./Area_SOL_Time_CSV/RawAreas_Left.csv',area_pupil_left,'-append');
        dlmwrite('./Area_SOL_Time_CSV/Size_Left.csv',size(area_pupil_left,2),'-append');
        dlmwrite('./Area_SOL_Time_CSV/Times_Left.csv',time_left,'-append');
        clear time_left;
        
        dlmwrite('./Area_SOL_Time_CSV/RawAreas_Right.csv',area_pupil_right,'-append'); 
        dlmwrite('./Area_SOL_Time_CSV/Size_Right.csv',size(area_pupil_right,2),'-append');
        dlmwrite('./Area_SOL_Time_CSV/Times_Right.csv',time_right,'-append');
        clear time_right;
                       
        % Here need to update the training module
        feature_vector = GetNormalized_Interpolated_Areas(0,0,0);
        
        if (exist('./Final_XY_Vectors/FeatureVector_X.csv','file') == 2)
            delete('./Final_XY_Vectors/FeatureVector_X.csv');
        end
        dlmwrite('./Final_XY_Vectors/FeatureVector_X.csv',feature_vector);
        
        display('Feature Vector calculation completed');
        
        GroundTruth = evalin('base','GroundTruth');
        dlmwrite('./Final_XY_Vectors/Labels_Y.csv',GroundTruth,'-append');
        display('Label saved')
        
        % Saving the Videos
        getvideo(im_left,im_right,tstampstr_left,tstampstr_right);
        
        % TO DO : Get the train set and test set size
        % trainset_size = ?
        % testset_size = ?
        accuracies = 1;
        data_split = 1;
        CM = 1;
        % LogisticRegression(trainset_size,testset_size,accuracies,data_split,CM)
        
    case 'No, TEST this data instead'
        
        dlmwrite('./Area_SOL_Time_CSV/RawAreas_Left.csv',area_pupil_left,'-append');
        dlmwrite('./Area_SOL_Time_CSV/Size_Left.csv',size(area_pupil_left,2),'-append');
        dlmwrite('./Area_SOL_Time_CSV/Times_Left.csv',time_left,'-append');
        clear time_left;
        
        dlmwrite('./Area_SOL_Time_CSV/RawAreas_Right.csv',area_pupil_right,'-append'); 
        dlmwrite('./Area_SOL_Time_CSV/Size_Right.csv',size(area_pupil_right,2),'-append');
        dlmwrite('./Area_SOL_Time_CSV/Times_Right.csv',time_right,'-append');
        clear time_right;
        
        
        % Use the existing theta values and get the predicted value.
        feature_vector = GetNormalized_Interpolated_Areas(0,0,0);
        
        if (exist('./Final_XY_Vectors/FeatureVector_X.csv','file') == 2)
            delete('./Final_XY_Vectors/FeatureVector_X.csv');
        end
        dlmwrite('./Final_XY_Vectors/FeatureVector_X.csv',feature_vector);
        display('Feature Vector calculation completed');
        
        GroundTruth = evalin('base','GroundTruth');
        dlmwrite('./Final_XY_Vectors/Labels_Y.csv',GroundTruth,'-append');
        display('Label saved')
        
        all_X = csvread('./Final_XY_Vectors/FeatureVector_X.csv');
        test_X = all_X(size(all_X,1),:);
        predicted_label = Test_Data(test_X);
        display(predicted_label);
        
        % Saving the Videos
        getvideo(im_left,im_right,tstampstr_left,tstampstr_right);
            
    case 'No , DISCARD this data'
        % Delete the label from the Labels_Y.csv
        
%         row = size(csvread('./Final_XY_Vectors/Labels_Y.csv'),1);
%         dlmwrite('./Final_XY_Vectors/Labels_Y.csv',[dlmread('./Final_XY_Vectors/Labels_Y.csv',',',[0 0 row-2 0]);[]],',');
        display('Current Test Discarded');
end