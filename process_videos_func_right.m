function process_videos_func_right(obj, event, himage, videoObj)
    % this is called each time the camera makes a new frame available.
    % the input arguments are passed automatically. You can add others if you need 
    % them, but they also have to be included where this function is created (above)
    % do all your real-time processing here in this function
    global record;
    global stop;
    global area_pupil_right
    global time_right
   
    % TODO: save timestamps in a separate file
    % TODO: Save extracted pupil diameter with these timestamps
    tstampstr = event.Timestamp;
    [hour_right, temp1] = strtok(tstampstr,':');
    [min_right, temp2] = strtok(temp1,':');
    [sec_right] = strtok(temp2,':');
    
    time_rgt = ((3600 .* hour_right) + (60 .* min_right) + sec_right) * 1000; 

    % you get the image in this function from:
    im = event.Data;
    % im_processed = process_pupil(im, 1, 180,threshold_dark, threshold_bright);
    
    if (record == 1 && stop == 0)
        % send ON command to arduino
        % create video object and start recording

        area_of_pupil_right(im);
        time_right = [time_right , time_rgt];
    end
          
    if (record == 0 && stop == 1)
        % send OFF command to arduino
        % terminate videoObj
        
        dlmwrite('./Area_SOL_Time_CSV/RawAreas_Right.csv',area_pupil_right,'-append');
    
        dlmwrite('./Area_SOL_Time_CSV/Size_Right.csv',size(area_pupil_right,2),'-append');
        
        time_right = time_right - time_right(1,1);
        dlmwrite('./Area_SOL_Time_CSV/Times_Right.csv',time_right','-append');
        
        % Right Eye Area Vs Time
        ys = smooth(time_right,area_pupil_right,0.1,'rloess'); % This is used to smooth the curve for better visibility
        plot(time_right,ys,'r')
        hold on
                
        clear area_pupil_right;
        clear time_right;

        % Now that the videos are saved, along with timestamps, we will
        % process using ML
        % main_file(v_right.Filename);
    end

    % you actively need to display the image in this function
    set(himage, 'CData', im, 'EraseMode', 'none');

