function process_videos_func_right(obj, event, himage, videoObj)
    % this is called each time the camera makes a new frame available.
    % the input arguments are passed automatically. You can add others if you need 
    % them, but they also have to be included where this function is created (above)
    % do all your real-time processing here in this function
    
    % display('Process_video_RIGHT');
    global record;
    global stop;
    global arduino;
    global area_pupil_right
    global time_right
    persistent flg;
    
    % TODO: save timestamps in a separate file
    % TODO: Save extracted pupil diameter with these timestamps

    % you get the image in this function from:
    im = event.Data;
    if (record == 1 && stop == 0)
        
        area_of_pupil_right(event);
        flg = 0;
        
    elseif (record == 0 && stop == 1)
        
        flg = flg + 1;
        % send OFF command to arduino
        % terminate videoObj
        if flg == 1
            
            dlmwrite('./Area_SOL_Time_CSV/RawAreas_Right.csv',area_pupil_right,'-append');
        
            dlmwrite('./Area_SOL_Time_CSV/Size_Right.csv',size(area_pupil_right,2),'-append');
        
            time_right = time_right - time_right(1,1);
            dlmwrite('./Area_SOL_Time_CSV/Times_Right.csv',time_right,'-append');
            % trsize = size(time_right)
        
            % Right Eye Area Vs Time
            ys = smooth(time_right,area_pupil_right,0.1,'rloess'); % This is used to smooth the curve for better visibility
            figure; plot(time_right,ys,'r')
            hold on
                
            clear area_pupil_right;
            clear time_right;
            delete(videoObj);
                        
        end
        
    else
        % display('There is a conflict between record and stop');
        % do nothing
        var = 1; % just a dummy action
    end

    % you actively need to display the image in this function
   
    set(himage, 'CData', im);
