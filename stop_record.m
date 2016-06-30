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
global area_pupil_right;
global time_left;
global time_right
global im_left;
global im_right;
global tstampstr_left;
global tstampstr_right;
global bestEpsilon;

record = 0;
stop = str2num(val);

fprintf(arduino, 'x') ;

tic

% figure('Name','Left Pupil')
area_of_pupil_left(im_left);
% close('Left Pupil')

% figure('Name','Right Pupil')
area_of_pupil_right(im_right);
% close('Right Pupil')

time_left = time_left - time_left(1,1);
time_right = time_right - time_right(1,1);

% var_left = time_left(1,2:size(time_left,2));
% diff_left = var_left - time_left(1,1:(size(time_left,2)-1));
% avgtimediff_left = mean(diff(time_left))

% var_right = time_right(1,2:size(time_right,2));
% diff_right = var_right - time_right(1,1:(size(time_right,2)-1));
% avgtimediff_right = mean(diff(time_right))

imrightsize = size(im_right)
time_r = size(time_right);

imleftsize = size(im_left)
time_l = size(time_left);

assignin('base', 'im_left', im_left);
assignin('base', 'im_right', im_right);
assignin('base','tstampstr_right',tstampstr_right);
assignin('base','tstampstr_left',tstampstr_left);

ys = smooth(time_left,area_pupil_left,0.1,'rloess'); % This is used to smooth the curve for better visibility
figure ;
plot(time_left,ys,'b')
hold on
ys = smooth(time_right,area_pupil_right,0.1,'rloess'); % This is used to smooth the curve for better visibility
plot(time_right,ys,'r')
legend('OS','OD')
hold on

toc;

pause(8)
 
bestEpsilon = 4.389450424379703e-20;

% Now what to do with the obtained new data
            
choice = questdlg('Would you like to use this data for Retraining the System ?','Action on Data' , 'Yes' , 'No, TEST this data instead' , 'No , DISCARD this data' , 'Yes');
            
switch choice
    case 'Yes'                
        
        dlmwrite('./Area_SOL_Time_CSV/RawAreas_Left.csv',area_pupil_left,'-append');
        dlmwrite('./Area_SOL_Time_CSV/Size_Left.csv',size(area_pupil_left,2),'-append');
        dlmwrite('./Area_SOL_Time_CSV/Times_Left.csv',time_left,'-append');
        
        dlmwrite('./Area_SOL_Time_CSV/RawAreas_Right.csv',area_pupil_right,'-append'); 
        dlmwrite('./Area_SOL_Time_CSV/Size_Right.csv',size(area_pupil_right,2),'-append');
        dlmwrite('./Area_SOL_Time_CSV/Times_Right.csv',time_right,'-append');
                       
        % Here need to update the training module
        
        l_area = area_pupil_left;
        r_area = area_pupil_right;
        
        l_time = time_left;
        r_time = time_right;
         
        xql = 0:110:max(l_time);
        xqr = 0:110:max(r_time);
        m = min(length(xql), length(xqr));
        
        % If the lengths don't match, insert zeros
        
        if length(xql) ~= m
            xql = xql(1,1:m);
        elseif length(xqr) ~= m
            xqr = xqr(1,1:m);
        end
        
        % Interpolation
        
        vq2l = interp1(l_time',l_area',xql,'linear');
        vq2r = interp1(r_time',r_area',xqr,'linear');
        
        Get3SetsOfAreas(xql,xqr,vq2l,vq2r);
        
        feature_vector_450 = [vq2l(1,1:225) vq2r(1,1:225)];
      
        dlmwrite('./Final_XY_Vectors/FeatureVector_X_450.csv',feature_vector_450,'-append');
        
        feature_vector_14 = GetThetas();
        
        display('Feature Vector calculation completed');
        
        GroundTruth = evalin('base','GroundTruth');
        dlmwrite('./Final_XY_Vectors/Labels_Y.csv',GroundTruth,'-append');
        display('Label saved')
        
        % Get the train set and test set size
        
        AnomalyDetection();
        
        % GetReportData(xql,xqr,vq2l,vq2r);
        
        % Saving the Videos
        getvideo(im_left,im_right,tstampstr_left,tstampstr_right);
        if ~exist('./Plots','dir')
            mkdir('./Plots');
        end
        F = getframe(gcf);
        Image = F.cdata;
        plot_area = Image;
        mr_no = evalin('base','mr_no');
        attempt = evalin('base','attempt');
    
        fname_plot = strcat(mr_no,'_',num2str(attempt),'_plot','.jpg');
        imwrite(plot_area,fullfile('./Plots',fname_plot));
        display('Plot Saved!!!')
        
        existing_worksheet_data = evalin('base','existing_worksheet_data');
        
        first_name = evalin('base', 'first_name');
        last_name = evalin('base', 'last_name');
        age = evalin('base', 'age');
        gender = evalin('base', 'gender');
        rapd_notes = evalin('base', 'rapd_notes');
        mr_no = evalin('base', 'mr_no');
        os = evalin('base', 'os');
        od = evalin('base', 'od');
        
        patient_data = [{first_name} {last_name} attempt {age} gender(1) {rapd_notes} mr_no os od];
        strcat('A', num2str(existing_worksheet_data + 1));
        xlswrite(strcat(date, '.xls'), patient_data, 'Sheet1', strcat('A', num2str(existing_worksheet_data + 1)));
        display('CURRENT DATA COLLECTION COMPLETED!!!')
        
        
    case 'No, TEST this data instead'
        
        dlmwrite('./Area_SOL_Time_CSV/RawAreas_Left.csv',area_pupil_left,'-append');
        dlmwrite('./Area_SOL_Time_CSV/Size_Left.csv',size(area_pupil_left,2),'-append');
        dlmwrite('./Area_SOL_Time_CSV/Times_Left.csv',time_left,'-append');
        
        dlmwrite('./Area_SOL_Time_CSV/RawAreas_Right.csv',area_pupil_right,'-append'); 
        dlmwrite('./Area_SOL_Time_CSV/Size_Right.csv',size(area_pupil_right,2),'-append');
        dlmwrite('./Area_SOL_Time_CSV/Times_Right.csv',time_right,'-append');        
        
        % Use the existing theta values and get the predicted value.
        l_area = area_pupil_left;
        r_area = area_pupil_right;
        
        l_time = time_left;
        r_time = time_right;
         
        xql = 0:110:max(l_time);
        xqr = 0:110:max(r_time);
        m = min(length(xql), length(xqr));
        
        % If the lengths don't match, insert zeros
        if length(xql) ~= m
            xql = xql(1,1:m);
        elseif length(xqr) ~= m
            xqr = xqr(1,1:m);
        end
        
        % Interpolation
        
        vq2l = interp1(l_time',l_area',xql,'linear');
        vq2r = interp1(r_time',r_area',xqr,'linear');
        
        Get3SetsOfAreas(xql,xqr,vq2l,vq2r);
        
        feature_vector_450 = [vq2l(1,1:225) vq2r(1,1:225)];
      
        dlmwrite('./Final_XY_Vectors/FeatureVector_X_450.csv',feature_vector_450,'-append');
        
        feature_vector_14 = GetThetas();
        
        display('Feature Vector calculation completed');
        
        GroundTruth = evalin('base','GroundTruth');
        dlmwrite('./Final_XY_Vectors/Labels_Y.csv',GroundTruth,'-append');
        display('Label saved')
        
        % Test and give a predicted result
        test_X = feature_vector_14;
        Predicted_Label = Test_Data(test_X);
%         if Predicted_Label == 0
%             legend(strcat('Label : ',sprintf('%d', Predicted_Label),'- Abnormal'),'Location','SouthEast');
%         else
%             legend(strcat('Label : ',sprintf('%d', Predicted_Label),'- Abnormal'),'Location','SouthEast');
%         end
%         hold off
                
        % GetReportData(xql,xqr,vq2l,vq2r);
        
        % Saving the Videos
        getvideo(im_left,im_right,tstampstr_left,tstampstr_right);
        if ~exist('./Plots','dir')
            mkdir('./Plots');
        end
        
        F = getframe(gcf);
        Image = F.cdata;
        plot_area = Image;
        mr_no = evalin('base','mr_no');
        attempt = evalin('base','attempt');
    
        fname_plot = strcat(mr_no,'_',num2str(attempt),'_plot','.jpg');
        imwrite(plot_area,fullfile('./Plots',fname_plot));
        display('Plot Saved!!!')
        
        existing_worksheet_data = evalin('base','existing_worksheet_data');
        
        first_name = evalin('base', 'first_name');
        last_name = evalin('base', 'last_name');
        age = evalin('base', 'age');
        gender = evalin('base', 'gender');
        rapd_notes = evalin('base', 'rapd_notes');
        mr_no = evalin('base', 'mr_no');
        os = evalin('base', 'os');
        od = evalin('base', 'od');
        
        patient_data = [{first_name} {last_name} attempt {age} gender(1) {rapd_notes} mr_no os od];
        strcat('A', num2str(existing_worksheet_data + 1));
        xlswrite(strcat(date, '.xls'), patient_data, 'Sheet1', strcat('A', num2str(existing_worksheet_data + 1)));
        display('CURRENT DATA COLLECTION COMPLETED!!!')
        
    case 'No , DISCARD this data'
        
        %legend(strcat('Label : ','NA','- Data Discarded'),'Location','SouthEast');
        
        % Saving the Videos
        getvideo(im_left,im_right,tstampstr_left,tstampstr_right);
        if ~exist('./Plots','dir')
            mkdir('./Plots');
        end
        F = getframe(gcf);
        Image = F.cdata;
        plot_area = Image;
        mr_no = evalin('base','mr_no');
        attempt = evalin('base','attempt');
    
        fname_plot = strcat(mr_no,'_',num2str(attempt),'_plot','.jpg');
        imwrite(plot_area,fullfile('./Plots',fname_plot));
        display('Plot Saved!!!')
        
        existing_worksheet_data = evalin('base','existing_worksheet_data');
        
        first_name = evalin('base', 'first_name');
        last_name = evalin('base', 'last_name');
        age = evalin('base', 'age');
        gender = evalin('base', 'gender');
        rapd_notes = evalin('base', 'rapd_notes');
        mr_no = evalin('base', 'mr_no');
        os = evalin('base', 'os');
        od = evalin('base', 'od');
        
        patient_data = [{first_name} {last_name} attempt {age} gender(1) {rapd_notes} mr_no os od];
        strcat('A', num2str(existing_worksheet_data + 1));
        xlswrite(strcat(date, '.xls'), patient_data, 'Sheet1', strcat('A', num2str(existing_worksheet_data + 1)));
        display('CURRENT DATA COLLECTION COMPLETED!!!')
        
        
        display('Current Test Discarded');
end