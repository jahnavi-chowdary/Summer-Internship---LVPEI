function process_videos_func(obj, event, himage, videoObj)
    % this is called each time the camera makes a new frame available.
    % the input arguments are passed automatically. You can add others if you need 
    % them, but they also have to be included where this function is created (above)
    % do all your real-time processing here in this function
    global record;
    global arduino;
    
    threshold_dark = 0.8;
    threshold_bright = 0.87;

    % TODO: save timestamps in a separate file
    % TODO: Save extracted pupil diameter with these timestamps
    tstampstr = event.Timestamp;
    dlmwrite(strcat(strtok(videoObj.Filename,'.'),'.txt'),tstampstr,'delimiter','','-append');

    % you get the image in this function from:
    im = event.Data;
    % im_processed = process_pupil(im, 1, 180,threshold_dark, threshold_bright);
    
    if (record == 1)
        % send ON command to arduino
        % create video object and start recording
        % fprintf(arduino, 's');
        open(videoObj);
        writeVideo(videoObj, im);      %% THIS IS GOING TO GIVE STRANGE OUTPUT
    else
        % send OFF command to arduino
        % terminate videoObj
        close(videoObj);
        % calculate FPS using timestamps and save the video
    end

    % you actively need to display the image in this function
    set(himage, 'CData', im, 'EraseMode', 'none');

