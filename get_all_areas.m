% The folder 'Abnormal' should contain the folders - CSV, CSV_interp, Plots,
% Plots_interp, Videos. 

clc;
clear all;

dir_seg = dir('../Abnormal/CSV/*.csv');
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
        l_file = fullfile('../Abnormal/CSV', fname_left_txt);
        r_file = fullfile('../Abnormal/CSV', fname_right_txt);
        l = csvread(l_file);
        r = csvread(r_file);
        l = l(:,1);
        r = r(:,1);
        
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

xlswrite('../Abnormal/All_area.csv',all_areas);