function process_videos_func_right(obj, event, himage, videoObj)
    % this is called each time the camera makes a new frame available.
    % the input arguments are passed automatically. You can add others if you need 
    % them, but they also have to be included where this function is created (above)
    % do all your real-time processing here in this function
    
    global record;
    global stop;
    global arduino;
    global area_pupil_right
    global time_right
    persistent flg;
    global initial_blink_right;
    global im_right;
    global tstampstr_right;
    
    % TODO: save timestamps in a separate file
    % TODO: Save extracted pupil diameter with these timestamps

    % you get the image in this function from:
    im = event.Data;
    
    if (record == 1 && stop == 0)
        
        tstampstr_right{1,(size(tstampstr_right,2)+1)} = event.Timestamp;
        tstampstr = event.Timestamp;
        [hour_right, temp1] = strtok(tstampstr,':');
        [min_right, temp2] = strtok(temp1,':');
        [sec_right] = strtok(temp2,':');
    
        time_rgt = ((3600 .* str2num(hour_right)) + (60 .* str2num(min_right)) + str2num(sec_right)) * 1000;
        time_right = [time_right , time_rgt];
        
        im_right{1,(size(im_right,2)+1)} = im;
        
        flg = 0;
        
    elseif (record == 0 && stop == 1)
        
        delete(videoObj);
                  
    else
        % display('There is a conflict between record and stop');
        % do nothing
        var = 1; % just a dummy action 
    end

    % you actively need to display the image in this function
   
    set(himage, 'CData', im);
