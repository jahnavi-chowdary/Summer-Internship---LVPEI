function stop_record(~, ~, val)
% A simple function to update the value of hte global variable record,
% which is read by the process_videos_func callback function which is
% called every time the preview window updates. THis will tell it to start
% and stop the test.

% display('STOP Record')
global record;
global arduino;
global stop;

record = 0;
stop = str2num(val);

fprintf(arduino, 'x') ;
