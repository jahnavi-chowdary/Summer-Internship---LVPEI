function GetReportData(l_t,r_t,l,r)

import mlreportgen.dom.*

rpt_type = 'docx';

mr_no = evalin('base','mr_no');
first_name = evalin('base','first_name');
last_name = evalin('base','last_name');
age = evalin('base','age');
gender = evalin('base','gender');

% l_t = xql;
% r_t = xqr;
% l = vq2l;
% r = vq2r;

% l_ti = l_t(l_t>7000);
% r_ti = r_t(r_t>7000);

l_ti = l_t;
r_ti = r_t;

l_time = l_ti(l_ti<28000);
r_time = r_ti(r_ti<28000);

frames_removed_l = size(l_t,2) - size(l_ti,2);
frames_removed_r = size(r_t,2) - size(r_ti,2);

l_area = l((frames_removed_l+1):(frames_removed_l+size(l_time,2)));
r_area = r((frames_removed_r+1):(frames_removed_r+size(r_time,2)));

time_left = l_time;
time_right = r_time;
area_pupil_left = l_area;
area_pupil_right = r_area;
area_pupil_left = sqrt(area_pupil_left./2);
area_pupil_right = sqrt(area_pupil_right./2);

%% ------------------------- For Left Eye ------------------------------

% figure
ys = smooth(time_left,area_pupil_left,0.1,'rloess');
% plot(time_left,ys,'r')
% title('Radius of Left Pupil with Time')
[ymax_l,imax_l,ymin_l,imin_l] = extrema(ys);
% hold on
% plot(time_left(imax_l),ymax_l,'k*',time_left(imin_l),ymin_l,'g*')
% hold off

[tmp_max_l, ind_max_l] = sort(imax_l);
p = time_left(tmp_max_l);

%% For the 1st set
q = abs(p-0);
r = abs(p-7000);
[start_val, start_ind_l] = min(q);
[last_val, last_ind_l] = min(r);
start_l_1 = tmp_max_l(start_ind_l);
last_l_1 = tmp_max_l(last_ind_l);
time_left_1 = time_left(1,start_l_1:last_l_1);
ys_l_1 = ys(start_l_1:last_l_1,1);

l_area = ys_l_1;
l_time = time_left_1 - time_left_1(1,1);

xql = 0:110:max(l_time);

% Interpolation

vq2l = interp1(l_time',l_area',xql,'linear');

if size(vq2l,2) < 45
    vq2l(1,(size(vq2l,2)+1:45)) = 0;
end

baseline_left{1,1} = num2str(ys_l_1(1,1));
min_value_left{1,1} = num2str(min(ys_l_1));
[tp ind_minval] = min(ys_l_1);
per_change_left{1,1} = (abs(baseline_left{1,1} - min_value_left{1,1})/baseline_left{1,1}) * 100;
constrict_time_left{1,1} = abs(time_left_1(1,start_l_1) - time_left_1(1,ind_minval));
recovery_time_left{1,1} = abs(time_left_1(1,last_1_1) - time_left_1(1,ind_minval));

% dlmwrite('./Area_Size_Time_Cut_CSV/1/RawInterpolatedAreas_Left.csv',vq2l(1,1:45),'-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/1/RawAreas_Left.csv',ys_l_1','-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/1/Times_Left.csv',time_left_1,'-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/1/Sizes_Left.csv',size(time_left_1,2),'-append');

%% For the 2nd set
r = abs(p-14000);
[last_val, last_ind_l] = min(r);
start_l_2 = last_l_1;
last_l_2 = tmp_max_l(last_ind_l);
time_left_2 = time_right(1,start_l_2:last_l_2);
ys_l_2 = ys(start_l_2:last_l_2,1);

l_area = ys_l_2;
l_time = time_left_2 - time_left_2(1,1);

xql = 0:110:max(l_time);

% Interpolation

vq2l = interp1(l_time',l_area',xql,'linear');

if size(vq2l,2) < 45
    vq2l(1,(size(vq2l,2)+1:45)) = 0;
end

baseline_left{1,2} = num2str(ys_l_2(1,1));
min_value_left{1,2} = num2str(min(ys_l_2));
[tp ind_minval] = min(ys_l_2);
per_change_left{1,2} = (abs(baseline_left{1,2} - min_value_left{1,2})/baseline_left{1,2}) * 100;
constrict_time_left{1,2} =abs( time_left_2(1,start_l_2) - time_left_2(1,ind_minval));
recovery_time_left{1,2} = abs(time_left_2(1,last_1_2) - time_left_2(1,ind_minval));
% 
% dlmwrite('./Area_Size_Time_Cut_CSV/2/RawInterpolatedAreas_Left.csv',vq2l(1,1:45),'-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/2/RawAreas_Left.csv',ys_l_2','-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/2/Times_Left.csv',time_left_2,'-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/2/Sizes_Left.csv',size(time_left_2,2),'-append');

%% For the 3rd set
r = abs(p-21000);
[last_val, last_ind_l] = min(r);
start_l_3 = last_l_2;
last_l_3 = tmp_max_l(last_ind_l);
time_left_3 = time_left(1,start_l_3:last_l_3);
ys_l_3 = ys(start_l_3:last_l_3,1);

l_area = ys_l_3;
l_time = time_left_3 - time_left_3(1,1);

xql = 0:110:max(l_time);

% Interpolation

vq2l = interp1(l_time',l_area',xql,'linear');

if size(vq2l,2) < 45
    vq2l(1,(size(vq2l,2)+1:45)) = 0;
end

baseline_left{1,3} = num2str(ys_l_3(1,1));
min_value_left{1,3} = num2str(min(ys_l_3));
[tp ind_minval] = min(ys_l_3);
per_change_left{1,3} = (abs(baseline_left{1,3} - min_value_left{1,3})/baseline_left{1,3}) * 100;
constrict_time_left{1,3} =abs( time_left_3(1,start_l_3) - time_left_3(1,ind_minval));
recovery_time_left{1,3} = abs(time_left_3(1,last_1_3) - time_left_3(1,ind_minval));

% dlmwrite('./Area_Size_Time_Cut_CSV/3/RawInterpolatedAreas_Left.csv',vq2l(1,1:45),'-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/3/RawAreas_Left.csv',ys_l_3','-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/3/Times_Left.csv',time_left_3,'-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/3/Sizes_Left.csv',size(time_left_3,2),'-append');

%% For the 4th set
r = abs(p-28000);
[last_val, last_ind_l] = min(r);
start_l_4 = last_l_3;
last_l_4 = tmp_max_l(last_ind_l);
time_left_4 = time_left(1,start_l_4:last_l_4);
ys_l_4 = ys(start_l_4:last_l_4,1);

l_area = ys_l_4;
l_time = time_left_4 - time_left_4(1,1);

xql = 0:110:max(l_time);

% Interpolation

vq2l = interp1(l_time',l_area',xql,'linear');

if size(vq2l,2) < 45
    vq2l(1,(size(vq2l,2)+1:45)) = 0;
end

baseline_left{1,4} = num2str(ys_l_4(1,1));
min_value_left{1,4} = num2str(min(ys_l_4));
[tp ind_minval] = min(ys_l_4);
per_change_left{1,4} = (abs(baseline_left{1,4} - min_value_left{1,4})/baseline_left{1,4}) * 100;
constrict_time_left{1,4} =abs( time_left_4(1,start_l_4) - time_left_4(1,ind_minval));
recovery_time_left{1,4} = abs(time_left_4(1,last_1_4) - time_left_4(1,ind_minval));

% dlmwrite('./Area_Size_Time_Cut_CSV/3/RawInterpolatedAreas_Left.csv',vq2l(1,1:45),'-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/3/RawAreas_Left.csv',ys_l_3','-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/3/Times_Left.csv',time_left_3,'-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/3/Sizes_Left.csv',size(time_left_3,2),'-append');


%% ---------------------------- For Right Eye -------------------------- %%

ys = smooth(time_right,area_pupil_right,0.1,'rloess');
% figure
% plot(time_right,ys,'b')
% title('Radius of Right Pupil with Time')
[ymax_r,imax_r,ymin_r,imin_r] = extrema(ys);
% hold on
% plot(time_right(imax_r),ymax_r,'k*',time_right(imin_r),ymin_r,'g*')
% hold off

[tmp_max_r, ind_max_r] = sort(imax_r);
p = time_right(tmp_max_r);

%% For the 1st set
q = abs(p-0);
r = abs(p-7000);
[start_val, start_ind_r] = min(q);
[last_val, last_ind_r] = min(r);
start_r_1 = tmp_max_r(start_ind_r);
last_r_1 = tmp_max_r(last_ind_r);
time_right_1 = time_right(1,start_r_1:last_r_1);
ys_r_1 = ys(start_r_1:last_r_1,1);

r_area = ys_r_1;
r_time = time_right_1 - time_right_1(1,1);

xqr = 0:110:max(r_time);

% Interpolation

vq2r = interp1(r_time',r_area',xqr,'linear');

if size(vq2r,2) < 45
    vq2r(1,(size(vq2r,2)+1:45)) = 0;
end

baseline_right{1,1} = num2str(ys_r_1(1,1));
min_value_right{1,1} = num2str(min(ys_r_1));
[tp ind_minval] = min(ys_r_1);
per_change_right{1,1} = (abs(baseline_right{1,1} - min_value_right{1,1})/baseline_right{1,1}) * 100;
constrict_time_right{1,1} =abs( time_right_1(1,start_r_1) - time_right_1(1,ind_minval));
recovery_time_right{1,1} = abs(time_right_1(1,last_r_1) - time_right_1(1,ind_minval));


% dlmwrite('./Area_Size_Time_Cut_CSV/1/RawInterpolatedAreas_Right.csv',vq2r(1,1:45),'-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/1/RawAreas_Right.csv',ys_r_1','-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/1/Times_Right.csv',time_right_1,'-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/1/Sizes_Right.csv',size(time_right_1,2),'-append');

%% For the 2nd set
r = abs(p-14000);
[last_val, last_ind_r] = min(r);
start_r_2 = last_r_1;
last_r_2 = tmp_max_r(last_ind_r);
time_right_2 = time_right(1,start_r_2:last_r_2);
ys_r_2 = ys(start_r_2:last_r_2,1);

r_area = ys_r_2;
r_time = time_right_2 - time_right_2(1,1);

xqr = 0:110:max(r_time);

% Interpolation

vq2r = interp1(r_time',r_area',xqr,'linear');

if size(vq2r,2) < 45
    vq2r(1,(size(vq2r,2)+1:45)) = 0;
end

baseline_right{1,2} = num2str(ys_r_2(1,1));
min_value_right{1,2} = num2str(min(ys_r_2));
[tp ind_minval] = min(ys_r_2);
per_change_right{1,2} = (abs(baseline_right{1,2} - min_value_right{1,2})/baseline_right{1,2}) * 100;
constrict_time_right{1,2} =abs( time_right_2(1,start_r_2) - time_right_2(1,ind_minval));
recovery_time_right{1,2} = abs(time_right_2(1,last_r_2) - time_right_2(1,ind_minval));

% dlmwrite('./Area_Size_Time_Cut_CSV/2/RawInterpolatedAreas_Right.csv',vq2r(1,1:45),'-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/2/RawAreas_Right.csv',ys_r_2','-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/2/Times_Right.csv',time_right_2,'-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/2/Sizes_Right.csv',size(time_right_2,2),'-append');


%% For the 3rd set
r = abs(p-21000);
[last_val, last_ind_r] = min(r);
start_r_3 = last_r_2;
last_r_3 = tmp_max_r(last_ind_r);
time_right_3 = time_right(1,start_r_3:last_r_3);
ys_r_3 = ys(start_r_3:last_r_3,1);

r_area = ys_r_3;
r_time = time_right_3 - time_right_3(1,1);

xqr = 0:110:max(r_time);

% Interpolation

vq2r = interp1(r_time',r_area',xqr,'linear');

if size(vq2r,2) < 45
    vq2r(1,(size(vq2r,2)+1:45)) = 0;
end

baseline_right{1,3} = num2str(ys_r_3(1,1));
min_value_right{1,3}= num2str(min(ys_r_3));
[tp ind_minval] = min(ys_r_3);
per_change_right{1,3} = (abs(baseline_right{1,3} - min_value_right{1,3})/baseline_right{1,3}) * 100;
constrict_time_right{1,3} =abs( time_right_3(1,start_r_3) - time_right_3(1,ind_minval));
recovery_time_right{1,3} = abs(time_right_3(1,last_r_3) - time_right_3(1,ind_minval));

% dlmwrite('./Area_Size_Time_Cut_CSV/3/RawInterpolatedAreas_Right.csv',vq2r(1,1:45),'-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/3/RawAreas_Right.csv',ys_r_3','-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/3/Times_Right.csv',time_right_3,'-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/3/Sizes_Right.csv',size(time_right_3,2),'-append');


%% For the 3rd set
r = abs(p-28000);
[last_val, last_ind_r] = min(r);
start_r_4 = last_r_3;
last_r_4 = tmp_max_r(last_ind_r);
time_right_4 = time_right(1,start_r_4:last_r_4);
ys_r_4 = ys(start_r_4:last_r_4,1);

r_area = ys_r_4;
r_time = time_right_4 - time_right_4(1,1);

xqr = 0:110:max(r_time);

% Interpolation

vq2r = interp1(r_time',r_area',xqr,'linear');

if size(vq2r,2) < 45
    vq2r(1,(size(vq2r,2)+1:45)) = 0;
end

baseline_right{1,4} = num2str(ys_r_4(1,1));
min_value_right{1,4}= num2str(min(ys_r_4));
[tp ind_minval] = min(ys_r_4);
per_change_right{1,4} = (abs(baseline_right{1,4} - min_value_right{1,4})/baseline_right{1,4}) * 100;
constrict_time_right{1,4} =abs( time_right_4(1,start_r_4) - time_right_4(1,ind_minval));
recovery_time_right{1,4} = abs(time_right_4(1,last_r_4) - time_right_4(1,ind_minval));

% dlmwrite('./Area_Size_Time_Cut_CSV/3/RawInterpolatedAreas_Right.csv',vq2r(1,1:45),'-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/3/RawAreas_Right.csv',ys_r_3','-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/3/Times_Right.csv',time_right_3,'-append');
% dlmwrite('./Area_Size_Time_Cut_CSV/3/Sizes_Right.csv',size(time_right_3,2),'-append');

os_data = [baseline_left;min_val_left;per_change_left;constrict_time_left;recovery_time_left];
od_data = [baseline_right;min_val_right;per_change_right;constrict_time_right;recovery_time_right];

l= [];
% side_of_eye = {l;'OD';'OS'};
% side_of_eye = {l;l;l;'OD';l;l;l;l;'OS';l;l};
% side_heading = {l;'Baseline (px)';'Minimum Radius (px)';'Change (%)';'T1 (ms)';'T2 (ms)';'Baseline (px)';'Minimum Radius (px)';'Change (%)';'T1 (ms)';'T2 (ms)'};
% heading = {'Initial Baseline','S1','S2','S3','S4'};
% all_data = [side_of_eye,[side_heading,[heading;[od_data;os_data]]]]
% all_data = [side_heading,[heading;[od_data;os_data]]]

heading = {l,l,'S1','S2','S3','S4'};
side_heading = {'Baseline (px)';'Minimum Radius (px)';'Change (%)';'T1 (ms)';'T2 (ms)'};
od_side = {l;l;'OD';l;l};
os_side = {l;l;'OS';l;l};
all_od = [od_side,side_heading,od_data];
all_os = [os_side,side_heading,os_data];

% -------------------------- Generating Report ---------------------- %

%% Simple Report
doc = Document(fullfile('./Reports',mr_no),rpt_type); %Create an empty pdf document
% append(doc, 'Hello World'); %Add some content

%% Insert Date,Day,Time

time_date = char(datetime('now'));
DayForm = 'long';
[DayNumber,DayName] = weekday(date,DayForm);
paraObj = Paragraph(char(strcat({blanks(30)},DayName,{blanks(3)},time_date)));
paraObj.Style = {FontSize('10pt'),HAlign('right')}
append(doc, paraObj); % Append paragraph to document


%% Insert an image
imageObj = Image(which('Logo.png')); % Create an image object
% imageObj.Width = '1.5in';
% imageObj.Height = '1in';
append(doc,imageObj);

%% Add a Paragraph
paraObj = Paragraph('____________________________________________________________________________________');
append(doc, paraObj); % Append paragraph to document

%% Add a Paragraph
name = strcat(first_name,last_name);
% age = '20';
sex = gender;
blnk = {blanks(10)};
paraObj = Paragraph(char(strcat('Name :',{blanks(1)},name,blnk,'Age :',{blanks(1)},age,blnk,'Sex :',{blanks(1)},sex)));
append(doc, paraObj); % Append paragraph to document

%% Add a Paragraph
paraObj = Paragraph('____________________________________________________________________________________');
append(doc, paraObj); % Append paragraph to document

%% Insert a table 
% tableObj = Table(magic(6));

% t1 = Table(all_data);
% % t1.Style = {};
% t1.Style = {RowHeight('0.14in'),FontSize('8pt'),Width('90%'),HAlign('center')};
% t1.Border = 'solid';
% t1.BorderWidth = '0.5pt';
% t1.ColSep = 'solid';
% t1.ColSepWidth = '0.5';
% t1.RowSep = 'solid';
% t1.RowSepWidth = '0.5';
% append(doc,t1);

t1 = Table(heading);
% t1.Style = {};
t1.Style = {RowHeight('0.16in'),FontSize('10pt'),Width('90%'),HAlign('center')};
t1.Border = 'solid';
t1.BorderWidth = '0.5pt';
t1.ColSep = 'solid';
t1.ColSepWidth = '0.5';
t1.RowSep = 'solid';
t1.RowSepWidth = '0.5';
append(doc,t1);

t2 = Table(all_od);
% t1.Style = {};
t2.Style = {RowHeight('0.14in'),FontSize('8pt'),Width('90%'),HAlign('center'),VAlign('bottom')};
t2.Border = 'solid';
t2.BorderWidth = '0.5pt';
t2.ColSep = 'solid';
t2.ColSepWidth = '0.5';
t2.RowSep = 'none';
t2.RowSepWidth = '0';
append(doc,t2);

% paraObj = Paragraph('____________________________________________________________________________________');
% paraObj.Style = {Width('90%'),HAlign('center')};
% append(doc, paraObj); % Append paragraph to document

%  paraObj = Paragraph(char(strcat({blanks(10)})));
% paraObj.Style = {FontSize('0.1pt')}
% append(doc, paraObj); % Append paragraph to document

paraObj = Paragraph();
% paraObj.Style = {FontSize('0.1pt')}
paraObj.WhiteSpace = 'pre';
append(doc, paraObj); % Append paragraph to document
% 
t1 = Table(heading);
% t1.Style = {};
t1.Style = {RowHeight('0.16in'),FontSize('10pt'),Width('90%'),HAlign('center')};
t1.Border = 'solid';
t1.BorderWidth = '0.5pt';
t1.ColSep = 'solid';
t1.ColSepWidth = '0.5';
t1.RowSep = 'solid';
t1.RowSepWidth = '0.5';
append(doc,t1);


t3 = Table(all_os);
% t1.Style = {};
t3.Style = {RowHeight('0.14in'),FontSize('8pt'),Width('90%'),HAlign('center'),VAlign('bottom')};
t3.Border = 'solid';
t3.BorderWidth = '0.5pt';
t3.ColSep = 'solid';
t3.ColSepWidth = '0.5';
% t3.RowSep = 'solid';
% t3.RowSepWidth = '0.01';
append(doc,t3);

% paraObj = Paragraph('____________________________________________________________________________________');
% append(doc, paraObj); % Append paragraph to document

% t2 = Table(side_of_eye);
% % t.BorderCollapse = 'on';
% t2.Border = 'solid';
% t2.BorderWidth = '0.5pt';
% t2.ColSep = 'solid';
% t2.ColSepWidth = '0.5';
% t2.Width = '1mm';
% 
% t2.RowSep = 'solid';
% t2.RowSepWidth = '0.5';
% rowObj1 = row(t2, 2);
% rowObj1.Height = '1in';
% rowObj2 = row(t2,3);
% rowObj2.Height = '1in';
% t2.TableEntriesHAlign = 'center';
% t2.TableEntriesVAlign = 'middle';
% 
% append(doc,t2);

% grps(1) = TableColSpecGroup;
% grps(1).RowSep = 'solid';
% grps(1).RowSepWidth = '0';
% % grps(1).Style = {Color('red')};
% specs(1) = TableColSpec;
% % specs(1).Style = {Color('green')};
% grps(1).ColSpecs = specs;
% % t = Table(magic(5));
% t.ColSpecGroups = grps;
% append(doc, t);

%% Add a Paragraph
paraObj = Paragraph('____________________________________________________________________________________');
append(doc, paraObj); % Append paragraph to document

%% Insert an image
imageObj = Image(which('plot.jpg')); % Create an image object
imageObj.Width = '4in';
imageObj.Height = '2.5in';
append(doc,imageObj);

%% Add a Paragraph
paraObj = Paragraph('Remarks:');
append(doc, paraObj); % Append paragraph to document

%% Footer
footer = DOCXPageFooter();
paraObj = Paragraph('Remarks:');
append(footer, paraObj); % Append paragraph to document
% append(doc,footer)

%% Close and view the report
close(doc); % Close the document and write to disk
rptview(doc.OutputPath,'pdf'); % Open document in in-built PDF viewer


end
