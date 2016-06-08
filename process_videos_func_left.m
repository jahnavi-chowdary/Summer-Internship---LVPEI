function process_videos_func_left(obj, event, himage, videoObj)
    % this is called each time the camera makes a new frame available.
    % the input arguments are passed automatically. You can add others if you need 
    % them, but they also have to be included where this function is created (above)
    % do all your real-time processing here in this function
    
    global record;
    global stop;
    global arduino;
    global area_pupil_left;
    global time_left;
    persistent flg;
    global initial_blink_left;
    global im_left
    global tstampstr_left;
    
    im = event.Data;
    
    if (record == 1 && stop == 0)
     
        tstampstr_left{1,(size(tstampstr_left,2)+1)} = event.Timestamp;
        tstampstr = event.Timestamp;
        [hour_left, temp1] = strtok(tstampstr,':');
        [min_left, temp2] = strtok(temp1,':');
        [sec_left] = strtok(temp2,':');
    
        time_lft = ((3600 .* str2num(hour_left)) + (60 .* str2num(min_left)) + str2num(sec_left)) * 1000;
        time_left = [time_left , time_lft];
        
        im_left{1,(size(im_left,2)+1)} = im;

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

