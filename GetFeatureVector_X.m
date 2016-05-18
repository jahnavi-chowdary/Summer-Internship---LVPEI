clc;
clear;
close all;

dir_seg = dir('../CSV_interp/*.csv');
len = length(dir_seg);
tic;
i = 1;

for k = 1:len
    
    % Get the User ID , the attempt number , Which eye the test is being done on.
    % Ex : N284524_0_left => ID = N284534 , Attempt = 0 , Side = Left
    % These are Used to name the CSV files and the Plots.
    
    fname = dir_seg(k).name;
    [ID rem1] = strtok(fname,'_');
    [Attempt rem2] = strtok(rem1,'_');
    [temp rem3] = strtok(rem2,'_');
    [Side rem4] = strtok(temp,'.');
    
        
    fname_right = strcat(ID,'_',Attempt,'.csv');

    csv_right = csvread(fullfile('../CSV_interp', fname)); % Reading the Right Eye Video
%     sizes_csv(i,:) = size(csv_right,1);
    area_left = csv_right(1:450,1)';
    area_right = csv_right(1:450,2)';
    
%     ids(i,:) = ID;
    feature_vector(i,:) = [area_right area_left];
    labels(i,:) = 0;
    i = i + 1;

end

% dlmwrite('../Abnormal/FeatureVector_X.csv',feature_vector);
xlswrite('../Normal_FeatureVector_X.csv',feature_vector);
xlswrite('../Normal_Labels_Y.csv',labels);

% xlswrite('../Abnormal/IDs.csv',ids);

toc;
