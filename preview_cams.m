clear all;
close all;
clc;

% Show the preview of the cameras in a custom GUI
% Also save the timestamps of both.
% Also save the live video stream at the end
% If this is possible, then the whole thing should happen this way
global record;
global stop;
global arduino;
global v_left;      % The videoWriter objects, which change each time the patient info is changed
global v_right;
global h1;
global h2;
global attempt;

record = 2;     % A neutral value that it only takes at the start
stop = 2;

%% Establish connection to the arduino
ports = instrhwinfo('serial');
ports_list = ports.AvailableSerialPorts;

for i = 1:size(ports_list, 1)
    if ~strcmp(ports_list(i), 'COM1')
        arduino_port = ports_list(i)    % TODO: establish comm to prove it is the arduino
        break
    else
        arduino_port = ports_list(i+1)
    end
end

if ~(exist('arduino_port'))
    msgbox('Arduino not plugged in! Exiting...');
    return
end

arduino = serial(arduino_port{1});  % establish comm.
set(arduino,'BaudRate',9600);
fopen(arduino);

%% Establish connection to the cameras
if (~exist('w1'))
    w1 = webcam1;
    start(w1);
end

if (~exist('w2'))
    w2 = webcam2;
    start(w2);
end

vidRes = w1.VideoResolution;    % assume w1 and w2 same which we know
nBands = w1.NumberOfBands;

hImage1 = zeros(vidRes(2), vidRes(1), nBands);
hImage2 = hImage1;

% Create figure and use it to display previews of both cameras
f = figure('CloseRequestFcn',@cleanup);
subplot(1,2,1); h1 = subimage(hImage1);     % h1 and h2 are the handles to the subimages 
subplot(1,2,2); h2 = subimage(hImage2);

preview(w1, h2); 
preview(w2, h1);           % display the images as subplots

if ~exist('./Area_SOL_Time_CSV','dir')
    mkdir('./Area_SOL_Time_CSV');
end
if ~exist('./Final_XY_Vectors','dir')
    mkdir('./Final_XY_Vectors');
end
start_button = uicontrol(f,'Style','pushbutton','String','START', 'Position',[50 20 60 40], 'Callback', {@do_record, '1'});
stop_button = uicontrol(f,'Style','pushbutton','String','STOP', 'Position',[450 20 60 40], 'Callback', {@stop_record, '1'});
another_button = uicontrol(f,'Style','pushbutton','String','NEW PATIENT', 'Position',[230 20 100 40], 'Callback', @rapdi_gui);

%% get inputs from the examiner
h = rapdi_gui;