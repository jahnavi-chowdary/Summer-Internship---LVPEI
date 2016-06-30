function Get3SetsOfAreas(l_t,r_t,l,r)

% l_t = xql;
% r_t = xqr;
% l = vq2l;
% r = vq2r;

l_ti = l_t(l_t>7000);
r_ti = r_t(r_t>7000);

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

%% For all the 3 test together
q = abs(p-7000);
r = abs(p-28000);
[start_val, start_ind_l] = min(q);
[last_val, last_ind_l] = min(r);
start_l_1 = tmp_max_l(start_ind_l);
last_l_3 = tmp_max_l(last_ind_l);
time_left_all3 = time_left(1,start_l_1:last_l_3);
ys_l_all3 = ys(start_l_1:last_l_3,1);

l_area = ys_l_all3;
l_time = time_left_all3 - time_left_all3(1,1);

xql = 0:110:max(l_time);

% Interpolation

vq2l = interp1(l_time',l_area',xql,'linear');

if size(vq2l,2) < 45
    vq2l(1,(size(vq2l,2)+1:45)) = 0;
end

dlmwrite('./Area_Size_Time_Cut_CSV/All_3/RawInterpolatedAreas_Left.csv',vq2l(1,1:45),'-append');
dlmwrite('./Area_Size_Time_Cut_CSV/All_3/RawAreas_Left.csv',ys_l_all3','-append');
dlmwrite('./Area_Size_Time_Cut_CSV/All_3/Times_Left.csv',time_left_all3,'-append');
dlmwrite('./Area_Size_Time_Cut_CSV/All_3/Sizes_Left.csv',size(time_left_all3,2),'-append');

%% For the 1st set
q = abs(p-7000);
r = abs(p-14000);
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

dlmwrite('./Area_Size_Time_Cut_CSV/1/RawInterpolatedAreas_Left.csv',vq2l(1,1:45),'-append');
dlmwrite('./Area_Size_Time_Cut_CSV/1/RawAreas_Left.csv',ys_l_1','-append');
dlmwrite('./Area_Size_Time_Cut_CSV/1/Times_Left.csv',time_left_1,'-append');
dlmwrite('./Area_Size_Time_Cut_CSV/1/Sizes_Left.csv',size(time_left_1,2),'-append');

%% For the 2nd set
r = abs(p-21000);
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

dlmwrite('./Area_Size_Time_Cut_CSV/2/RawInterpolatedAreas_Left.csv',vq2l(1,1:45),'-append');
dlmwrite('./Area_Size_Time_Cut_CSV/2/RawAreas_Left.csv',ys_l_2','-append');
dlmwrite('./Area_Size_Time_Cut_CSV/2/Times_Left.csv',time_left_2,'-append');
dlmwrite('./Area_Size_Time_Cut_CSV/2/Sizes_Left.csv',size(time_left_2,2),'-append');


%% For the 3rd set
start_l_3 = last_l_2;
last_l_3;
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

dlmwrite('./Area_Size_Time_Cut_CSV/3/RawInterpolatedAreas_Left.csv',vq2l(1,1:45),'-append');
dlmwrite('./Area_Size_Time_Cut_CSV/3/RawAreas_Left.csv',ys_l_3','-append');
dlmwrite('./Area_Size_Time_Cut_CSV/3/Times_Left.csv',time_left_3,'-append');
dlmwrite('./Area_Size_Time_Cut_CSV/3/Sizes_Left.csv',size(time_left_3,2),'-append');


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

%% For all the 3 test together
q = abs(p-7000);
r = abs(p-28000);
[start_val, start_ind_r] = min(q);
[last_val, last_ind_r] = min(r);
start_r_1 = tmp_max_r(start_ind_r);
last_r_3 = tmp_max_r(last_ind_r);
time_right_all3 = time_right(1,start_r_1:last_r_3);
ys_r_all3 = ys(start_r_1:last_r_3,1);

r_area = ys_r_all3;
r_time = time_right_all3 - time_right_all3(1,1);

xqr = 0:110:max(r_time);

% Interpolation

vq2r = interp1(r_time',r_area',xqr,'linear');

if size(vq2r,2) < 45
    vq2r(1,(size(vq2r,2)+1:45)) = 0;
end

dlmwrite('./Area_Size_Time_Cut_CSV/All_3/RawInterpolatedAreas_Right.csv',vq2r(1,1:45),'-append');
dlmwrite('./Area_Size_Time_Cut_CSV/All_3/RawAreas_Right.csv',ys_r_all3','-append');
dlmwrite('./Area_Size_Time_Cut_CSV/All_3/Times_Right.csv',time_right_all3,'-append');
dlmwrite('./Area_Size_Time_Cut_CSV/All_3/Sizes_Right.csv',size(time_right_all3,2),'-append');

% figure('Name','1')
% plot(time_left_all3,ys_l_all3,'r')
% hold on
% plot(time_right_all3,ys_r_all3,'b')
% legend('OS','OD')
% xlabel('Time(s)')
% ylabel('Radius(px)')
% hold off

% F = getframe(gcf);
% Img = F.cdata;
% plot_area = Img;
% fname_plot = strcat(num2str(i),'.jpg');
% imwrite(plot_area,fullfile('./Area_Size_Time_Cut_CSV/All_3/Plots',fname_plot));
% close('1')

%% For the 1st set
q = abs(p-7000);
r = abs(p-14000);
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

dlmwrite('./Area_Size_Time_Cut_CSV/1/RawInterpolatedAreas_Right.csv',vq2r(1,1:45),'-append');
dlmwrite('./Area_Size_Time_Cut_CSV/1/RawAreas_Right.csv',ys_r_1','-append');
dlmwrite('./Area_Size_Time_Cut_CSV/1/Times_Right.csv',time_right_1,'-append');
dlmwrite('./Area_Size_Time_Cut_CSV/1/Sizes_Right.csv',size(time_right_1,2),'-append');

% figure('Name','1')
% plot(time_left_1,ys_l_1,'r')
% hold on
% plot(time_right_1,ys_r_1,'b')
% legend('OS','OD')
% xlabel('Time(s)')
% ylabel('Radius(px)')
% hold off

% F = getframe(gcf);
% Img = F.cdata;
% plot_area = Img;
% fname_plot = strcat(num2str(i),'.jpg');
% imwrite(plot_area,fullfile('./Area_Size_Time_Cut_CSV/1/Plots',fname_plot));
% close('1')

%% For the 2nd set
r = abs(p-21000);
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

dlmwrite('./Area_Size_Time_Cut_CSV/2/RawInterpolatedAreas_Right.csv',vq2r(1,1:45),'-append');
dlmwrite('./Area_Size_Time_Cut_CSV/2/RawAreas_Right.csv',ys_r_2','-append');
dlmwrite('./Area_Size_Time_Cut_CSV/2/Times_Right.csv',time_right_2,'-append');
dlmwrite('./Area_Size_Time_Cut_CSV/2/Sizes_Right.csv',size(time_right_2,2),'-append');

% figure('Name','1')
% plot(time_left_2,ys_l_2,'r')
% hold on
% plot(time_right_2,ys_r_2,'b')
% legend('OS','OD')
% xlabel('Time(s)')
% ylabel('Radius(px)')
% hold off

% F = getframe(gcf);
% Img = F.cdata;
% plot_area = Img;
% fname_plot = strcat(num2str(i),'.jpg');
% imwrite(plot_area,fullfile('./Area_Size_Time_Cut_CSV/2/Plots',fname_plot));
% close('1')

%% For the 3rd set
start_r_3 = last_r_2;
last_r_3;
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

dlmwrite('./Area_Size_Time_Cut_CSV/3/RawInterpolatedAreas_Right.csv',vq2r(1,1:45),'-append');
dlmwrite('./Area_Size_Time_Cut_CSV/3/RawAreas_Right.csv',ys_r_3','-append');
dlmwrite('./Area_Size_Time_Cut_CSV/3/Times_Right.csv',time_right_3,'-append');
dlmwrite('./Area_Size_Time_Cut_CSV/3/Sizes_Right.csv',size(time_right_3,2),'-append');

% figure('Name','1')
% plot(time_left_3,ys_l_3,'r')
% hold on
% plot(time_right_3,ys_r_3,'b')
% legend('OS','OD')
% xlabel('Time(s)')
% ylabel('Radius(px)')
% hold off

% F = getframe(gcf);
% Img = F.cdata;
% plot_area = Img;
% fname_plot = strcat(num2str(i),'.jpg');
% imwrite(plot_area,fullfile('./Area_Size_Time_Cut_CSV/3/Plots',fname_plot));
% close('1')

end
