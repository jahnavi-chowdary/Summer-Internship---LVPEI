function varargout = rapdi_gui(varargin)
% RAPDI_GUI MATLAB code for rapdi_gui.fig
%      RAPDI_GUI, by itself, creates a new RAPDI_GUI or raises the existing
%      singleton*.
%
%      H = RAPDI_GUI returns the handle to a new RAPDI_GUI or the handle to
%      the existing singleton*.
%
%      RAPDI_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RAPDI_GUI.M with the given input arguments.
%
%      RAPDI_GUI('Property','Value',...) creates a new RAPDI_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rapdi_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rapdi_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rapdi_gui

% Last Modified by GUIDE v2.5 01-Feb-2016 17:46:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rapdi_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @rapdi_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before rapdi_gui is made visible.
function rapdi_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rapdi_gui (see VARARGIN)

% Choose default command line output for rapdi_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rapdi_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rapdi_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global v_left;
global v_right;
global h1;
global h2;
global attempt;

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% The strings are written into variables, and then passed onto the rest of hte whole function
first_name = get(handles.edit1, 'String');
last_name = get(handles.edit2, 'String');
age = get(handles.edit3, 'String');
gender = get(get(handles.uipanel1, 'SelectedObject'), 'String');
rapd_notes = get(handles.edit4, 'String');
mr_no = get(handles.edit5, 'String');

% handle the dropdown separately
os_strings = get(handles.popupmenu1, 'String');
os = os_strings(get(handles.popupmenu1, 'Value'));
od_strings = get(handles.popupmenu2, 'String');
od = od_strings(get(handles.popupmenu2, 'Value'));

%% Add to workspace
assignin('base', 'first_name', first_name);
assignin('base', 'last_name', last_name);
assignin('base', 'age', age);
assignin('base', 'gender', gender);
assignin('base', 'rapd_notes', rapd_notes);
assignin('base', 'mr_no', mr_no);
assignin('base', 'os', os);
assignin('base', 'od', od);

%% close the ui
close;

%% Prepare the XLS file
% Write patient details to a file, name the file
% First we read it and see how many rows are written...

existing_worksheet_data = 0;
if (exist(strcat(date, '.xls'), 'file'))
    % if the excel sheet exists, then read it in
    [~, ~, existing_worksheet_data] = xlsread(strcat(date, '.xls'));
    existing_worksheet_data = size(existing_worksheet_data, 1);
end
if (existing_worksheet_data == 0)  % i.e. no rows are filled
    % disp('empty');
    xlswrite(strcat(date, '.xls'), [{'First Name'} {'Last Name'} {'Attempt'} {'Age'} {'Gender'} {'Notes'} {'MR Number'} {'OS'} {'OD'}], 'Sheet1', 'A1');
    existing_worksheet_data = existing_worksheet_data + 1;    % so that the next thing written will be after the present row
end

assignin('base','existing_worksheet_data',existing_worksheet_data);

attempt = 0;
[num,txt,raw] = xlsread(strcat(date, '.xls'));

p = raw(:,7); 

All_IDs = p(2:size(p,1),1);

for i = 1:length(All_IDs)
    var = strcmp(num2str(All_IDs{i}),mr_no);
    if var == 1
        attempt = attempt+1;
    end
end

assignin('base', 'attempt', attempt);

% % write the excel file with the user's data
% patient_data = [{first_name} {last_name} attempt {age} gender(1) {rapd_notes} mr_no os od];
% strcat('A', num2str(existing_worksheet_data + 1));
% xlswrite(strcat(date, '.xls'), patient_data, 'Sheet1', strcat('A', num2str(existing_worksheet_data + 1)));

% -------------------------------------------------------------------------

% Getting the label of the patient

    if strcmp(os,'OS: Normal')
        if ~strcmp(od,'OD: Normal')
            GroundTruth = 2; % Right Diseased
            p = od;
            % Grade(1,2) = str2num(p(1,size(p,2)));
            % Grade(1,1) = 0;
            clear p
        else
            GroundTruth = 1; % Normal
            % Grade(1,1) = 0;
            % Grade(1,2) = 0;
        end
    end
    if strcmp(od,'OD: Normal')
        if ~strcmp(os,'OS: Normal')
            GroundTruth = 3; % Left Diseased
            p = os;
            % Grade(1,1) = str2num(p(1,size(p,2)));
            % Grade(1,2) = 0;
            clear p;
        end
    end
    assignin('base','GroundTruth',GroundTruth);

% -------------------------------------------------------------------------

%% Create the video object
video_filename = strcat(mr_no,'_',num2str(attempt),'_left.avi');
%close(v_left);
v_left = VideoWriter(video_filename);
v_left.FrameRate = 30;
v_left.Quality = 100;

video_filename = strcat(mr_no,'_',num2str(attempt) ,'_right.avi');
%close(v_right);
v_right = VideoWriter(video_filename);
v_right.FrameRate = 30;
v_right.Quality = 100;

setappdata(h1, 'UpdatePreviewWindowFcn', @(obj, evt, h1)process_videos_func_left(obj, evt, h1, v_left));
setappdata(h2, 'UpdatePreviewWindowFcn', @(obj, evt, h2)process_videos_func_right(obj, evt, h2, v_right));

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
