function LogisticRegression(trainset_size,testset_size,accuracies,data_split,CM)

% This function trains and tests the system using One-Vs-All Logistic
% Regression and returns the accuracies,data split and the confusion matrices 
% for both the training and testing data based on whether the respective
% parameter is 1 or 0.
% It also saves all the 'thetas' in a csv named 'LogR_Theta.csv' in the
% current folder.

all_X = csvread('./Final_XY_Vectors/FeatureVector_X.csv');
all_Y = csvread('./Final_XY_Vectors/Labels_Y.csv');

h = randperm(size(all_X,1));
all_X_new = all_X(h,:);
all_Y_new = all_Y(h,:);

train_X = all_X_new(1:trainset_size,:);
train_Y = all_Y_new(1:trainset_size,:);

no_disease_train = (find(train_Y==1));
right_disease_train = (find(train_Y==2));
left_disease_train = (find(train_Y==3));

test_X = all_X_new((trainset_size + 1):(trainset_size + testset_size),:);
test_Y = all_Y_new((trainset_size + 1):(trainset_size + testset_size),:);

no_disease_test = (find(test_Y==1));
right_disease_test = (find(test_Y==2));
left_disease_test = (find(test_Y==3));

% Training 
lambda = 0.1;
num_labels = 3;
[all_theta] = oneVsAll(train_X, train_Y, num_labels, lambda);

if (exist('./LogR_Theta.csv','file') == 2)
    delete('./LogR_Theta.csv');
end

dlmwrite('./LogR_Theta.csv',all_theta);

% Prediction

predicted_labels_train = predictOneVsAll(all_theta, train_X);
predicted_labels_test = predictOneVsAll(all_theta, test_X);

% Accuracies of Training and Testing
if accuracies == 1

    accuracy_train = ((size(train_Y,1) -(nnz(abs(predicted_labels_train - train_Y))))/size(train_Y,1) ) * 100
    accuracy_test = ((size(test_Y,1) - (nnz(abs(predicted_labels_test - test_Y))))/size(test_Y,1) ) * 100
end

% Data Split
if data_split == 1
    temp_train = [length(no_disease_train) length(right_disease_train) length(left_disease_train)];
    temp_test = [length(no_disease_test) length(right_disease_test) length(left_disease_test)];

    data_split = [temp_train;temp_test] % 1st row corresponds to Train data and 2nd to Test data. 1st Column is Normal, 2nd Right Diseased , 3rd Left Diseased
end

% Confusion Matrices of Training and Testing
if CM == 1

    C_train = confusionmat(train_Y,predicted_labels_train) % 1st Row,Column is Normal, 2nd Right Diseased , 3rd Left Diseased
    C_test = confusionmat(test_Y,predicted_labels_test)  % 1st Row,Column is Normal, 2nd Right Diseased , 3rd Left Diseased   
end
end
