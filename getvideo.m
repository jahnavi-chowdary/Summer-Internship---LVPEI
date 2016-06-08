function getvideo(im_left,im_right,tstampstr_left,tstampstr_right)
    tic;
    display('Saving Videos and Timestamps...')
    mkdir('./Videos')
    mr_no = evalin('base','mr_no');
    attempt = evalin('base','attempt');
    
    text_left_filename = strcat(mr_no,'_',num2str(attempt),'_left.txt');
    text_right_filename = strcat(mr_no,'_',num2str(attempt),'_right.txt');
    
    dlmwrite(fullfile('./Videos',text_left_filename),tstampstr_left','delimiter','');
    dlmwrite(fullfile('./Videos',text_right_filename),tstampstr_right','delimiter','');
    
    len_left = size(im_left,2);
    len_right = size(im_right,2);

    video_filename = strcat(mr_no,'_',num2str(attempt),'_left.avi');
    v_left = VideoWriter(fullfile('./Videos',video_filename));
    v_left.FrameRate = 30;
    v_left.Quality = 100;

    video_filename = strcat(mr_no,'_',num2str(attempt) ,'_right.avi');
    v_right = VideoWriter(fullfile('./Videos',video_filename));
    v_right.FrameRate = 30;
    v_right.Quality = 100;

    for i = 1:len_left
        im = im_left{1,i};
        open(v_left);
        writeVideo(v_left, im);
    end
    close(v_left);

    for i = 1:len_right
        im = im_right{1,i};
        open(v_right);
        writeVideo(v_right, im);
    end
    close(v_right);
    
    display('Videos and timestamps saved!!!')
    toc
    
end