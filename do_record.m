function do_record_new(~, ~, val)
% A simple function to update the value of hte global variable record,
% which is read by the process_videos_func callback function which is
% called every time the preview window updates. THis will tell it to start
% and stop the test.

% global x_left;
% global x_right;
% global y_left;
% global y_right;
global area_pupil_right;
global area_pupil_left;
global time_right;
global time_left;
global record;
global arduino;
global stop;
global im_left;
global im_right;
global tstampstr_left;
global tstampstr_right;

im_left = [];
im_right = [];
tstampstr_left = [];
tstampstr_right = [];

% waitfor(msgbox('Please align the Pupils correctly and then click on the centre of both the pupils.'));
% [x,y] = ginput(2);
% 
% assignin('base','x_cord',x)
% assignin('base','y_cord',y)
% 
% x_left = y(1,1);
% x_right = y(2,1);
% 
% y_left = x(1,1);
% y_right = x(2,1);

area_pupil_right = [];
area_pupil_left = [];
time_left = [];
time_right = [];

display('DO Record')

stop = 0;
record = str2num(val);

fprintf(arduino, 's');
