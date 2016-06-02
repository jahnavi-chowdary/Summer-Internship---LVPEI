function process_videos_func_left(obj, event, himage, videoObj)
    % this is called each time the camera makes a new frame available.
    % the input arguments are passed automatically. You can add others if you need 
    % them, but they also have to be included where this function is created (above)
    % do all your real-time processing here in this function
    
    % display('Process_video_LEFT');
    global record;
    global stop;
    global arduino;
    global area_pupil_left;
    global time_left;
    persistent flg;
    global initial_blink_left;
    
    im = event.Data;
    
     if (record == 1 && stop == 0)
        
        subplot(1,2,1); 
        hold on
        area_of_pupil_left(event,himage);
        flg = 0;
        
    elseif (record == 0 && stop == 1)
        % send OFF command to arduino
        % terminate videoObj
        flg = flg +1;
        if flg == 1
            
            if initial_blink_left == 1
                area_pupil_left(1,1) = area_pupil_left(1,2);
            end
            
            dlmwrite('./Area_SOL_Time_CSV/RawAreas_Left.csv',area_pupil_left,'-append');
            % aplsize = size(area_pupil_left)
        
            dlmwrite('./Area_SOL_Time_CSV/Size_Left.csv',size(area_pupil_left,2),'-append');
        
            time_left = time_left - time_left(1,1);
            dlmwrite('./Area_SOL_Time_CSV/Times_Left.csv',time_left,'-append');        
            tlsize = size(time_left)
        
            % Left Eye Area Vs Time
            ys = smooth(time_left,area_pupil_left,0.1,'rloess'); % This is used to smooth the curve for better visibility
            figure ; plot(time_left,ys,'b')
            hold on
        
            clear area_pupil_left;
            clear time_left;
            delete(videoObj);
            
        end
    else
        % display('There is a conflict between record and stop');
        % do nothing
        var = 1; % just a dummy action
    end

    % you actively need to display the image in this function
    set(himage, 'CData', im);

