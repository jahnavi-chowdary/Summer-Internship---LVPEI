function getvideo(im_left,im_right)

    global mr_no;
    global attempt;
    
    len_left = size(im_left,2);
    len_right = size(im_right,2);

    video_filename = strcat(mr_no,'_',num2str(attempt),'_left.avi');
    v_left = VideoWriter(video_filename);
    % v_left.FrameRate = 30;
    v_left.Quality = 100;

    video_filename = strcat(mr_no,'_',num2str(attempt) ,'_right.avi');
    v_right = VideoWriter(video_filename);
    % v_right.FrameRate = 30;
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
end