function feature_vector_14 = GetThetas()

%degree of polynomial to fit and sizeensions of the dataset
deg = 6;
setSize = [1 45 3];

%load CSV files
A_l = zeros(setSize);
A_r = zeros(setSize);

for i=1:3
    A_l_all(:,:,i)=csvread(strcat('Area_Size_Time_Cut_CSV\',num2str(i),'\RawInterpolatedAreas_Left.csv'));
    A_r_all(:,:,i)=csvread(strcat('Area_Size_Time_Cut_CSV\',num2str(i),'\RawInterpolatedAreas_Right.csv'));
end
A_l = A_l_all(size(A_l_all,1),:,:);
A_r = A_r_all(size(A_r_all,1),:,:);

training_l = A_l;
training_r = A_r;

%TRAINING
%X values (time axis)
time=(0:110:4840)';
time = time/1000;

%create the feature vector
X = zeros(length(time), deg+1);
for i=0:deg
    X(:,i+1) = time.^i;
end

% thetas_l = zeros(size(training_l,1),deg+1,3);    
% thetas_r = zeros(size(training_r,1),deg+1,3);    

thetas_l = zeros(1,deg+1,3);    
thetas_r = zeros(1,deg+1,3); 

%optimize

Y_l = permute(training_l(1,:,:),[2 1 3]);
Y_r = permute(training_r(1,:,:),[2 1 3]);
    
%find thetas using the normal equation
for j=1:3
    thetas_l(1,:,j) = (pinv(X'*X)*X'*Y_l(:,:,j))';
    thetas_r(1,:,j) = (pinv(X'*X)*X'*Y_r(:,:,j))';
end

%==R2==%
R2_l = zeros(size(training_l,1),3);
R2_r = zeros(size(training_r,1),3);

for i=1:3
    F_l = (X*thetas_l(:,:,i)')';
    F_r = (X*thetas_r(:,:,i)')';
    res_l = training_l(:,:,i) - F_l;
    res_r = training_r(:,:,i) - F_r;
    
    SStot_l = sum(bsxfun(@minus, training_l(:,:,i), mean(training_l(:,:,i),2)).^2,2);
    SStot_r = sum(bsxfun(@minus, training_r(:,:,i), mean(training_r(:,:,i),2)).^2,2);
    
    SSres_l = sum(res_l.^2,2);
    SSres_r = sum(res_r.^2,2);
    
    R2_l(:,i) = 1-(SSres_l./SStot_l);
    R2_r(:,i) = 1-(SSres_r./SStot_r);
end

dlmwrite('./Thetas_R2_CSV/thetasLeft.csv', [thetas_l(:,:,1) thetas_l(:,:,2) thetas_l(:,:,3)],'-append');
dlmwrite('./Thetas_R2_CSV/thetasRight.csv', [thetas_r(:,:,1) thetas_r(:,:,2) thetas_r(:,:,3)],'-append');
dlmwrite('./Thetas_R2_CSV/R2Left.csv', R2_l,'-append');
dlmwrite('./Thetas_R2_CSV/R2Right.csv', R2_r,'-append');

[val_l, ind_l] = max(R2_l);
[val_r, ind_r] = max(R2_r);

all_left = thetas_l(1,:,ind_l(1,1));
all_right = thetas_r(1,:,ind_r(1,1));

feature_vector_14 = [all_left, all_right];

dlmwrite('./Final_XY_Vectors/FeatureVector_X_14.csv',feature_vector_14,'-append');

end