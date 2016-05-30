function process_videos_func_left(obj, event, himage, videoObj)
    % this is called each time the camera makes a new frame available.
    % the input arguments are passed automatically. You can add others if you need 
    % them, but they also have to be included where this function is created (above)
    % do all your real-time processing here in this function
    global record;
    global stop;
    global area_pupil_left;
    global time_left;
   
    % TODO: save timestamps in a separate file
    % TODO: Save extracted pupil diameter with these timestamps
    tstampstr = event.Timestamp;
    [hour_left, temp1] = strtok(tstampstr,':');
    [min_left, temp2] = strtok(temp1,':');
    [sec_left] = strtok(temp2,':');
    
    time_lft = ((3600 .* hour_left) + (60 .* min_left) + sec_left) * 1000; 

    % you get the image in this function from:
    im = event.Data;
    % im_processed = process_pupil(im, 1, 180,threshold_dark, threshold_bright);
    
    if (record == 1 && stop == 0)
        % send ON command to arduino
        % create video object and start recording

        area_of_pupil_left(im);
        time_left = [time_left , time_lft];
    end
          
    if (record == 0 && stop == 1)
        % send OFF command to arduino
        % terminate videoObj
        
        dlmwrite('./Area_SOL_Time_CSV/RawAreas_Left.csv',area_pupil_left,'-append');
    
        dlmwrite('./Area_SOL_Time_CSV/Size_Left.csv',size(area_pupil_left,2),'-append');
        
        time_left = time_left - time_left(1,1);
        dlmwrite('./Area_SOL_Time_CSV/Times_Left.csv',time_left','-append');        
        
        % Left Eye Area Vs Time
        ys = smooth(time_left,area_pupil_left,0.1,'rloess'); % This is used to smooth the curve for better visibility
        plot(time_left,ys,'b')
        hold on
        
        clear area_pupil_left;
        clear time_left;
                
        % Now that the videos are saved, along with timestamps, we will
        % process using ML
        % main_file(v_right.Filename);
    end

    % you actively need to display the image in this function
    set(himage, 'CData', im, 'EraseMode', 'none');

