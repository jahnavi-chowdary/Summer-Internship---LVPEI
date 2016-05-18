function GetLabels_Y()

% This functions gets the labels of all the data from the ground truth
% given in the 'ID,Labels.txt'. Label for Normal = 1, Right diseased = 2, Left
% diseased = 3. It saves the labels in a csv format in a folder named
% Final_XY_Vectors

[All_IDs var1 GroundTruth] = textread('./ID,Labels.txt','%7s %1c %s');
len_ids = size(All_IDs,1);

dir_seg = dir('./Videos/*.avi');
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
    
    % If the Video is a Right Eye Video -> Do the processing, i.e get the areas of both the Right Eye and Left eye of that particular user and 
    % plot both the areas across time.
    
    % It the Video is a Left Eye Video -> Ignore (because the Left Eye videos are automatically processed along with the Right Eye videos and 
    % we do not want it to be processed twice.)
    
    if strcmp(Side,'right')
        clear var;
        for p = 1:len_ids
            var = strcmp(All_IDs(p),ID);
            if var == 1
                idx = p;
                flag = 0;
            else
                flag = 1;
            end
        end
        
        if flag == 0
            lbl = GroundTruth(idx);
            if strcmp(lbl,'Right')
                labels(i,:) = 2;
                i = i+1;
            end
            if strcmp(lbl,'Left')
                labels(i,:) = 3;
                i = i+1;
            end
        else
            labels(i,:) = 1;
            i = i+1;
        end
    
    else
        continue
    end
end

dlmwrite('./Final_XY_Vectors/Labels_Y.csv',labels);

end