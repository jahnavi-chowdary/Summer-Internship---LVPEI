function AnomalyDetection()

global bestEpsilon;

format long
degree = 6;
degree = degree+1;

% read the csv files which contain the data. all_X stores the areas and

all_Y = csvread('./Final_XY_Vectors/Labels_Y.csv');
all_X_l = csvread('./Thetas_R2_CSV/thetasLeft.csv');
all_X_r = csvread('./Thetas_R2_CSV/thetasRight.csv');
R2_l = csvread('./Thetas_R2_CSV/R2Left.csv');
R2_r = csvread('./Thetas_R2_CSV/R2Right.csv');

X_norm=zeros(size(all_X_l,1),(degree)*2);

for i=1:degree
    X_norm(:,i) = (all_X_l(:,i) + all_X_l(:,i+degree) + all_X_l(:,i+2*degree))./3;
    X_norm(:,i+degree) = (all_X_r(:,i) + all_X_r(:,i+degree) + all_X_r(:,i+2*degree))./3;
end

for i=1:size(all_X_l,1)
    [val, ind] = max(R2_l(i,:));
    X_norm(i,1:degree) = all_X_l(i,(ind-1)*degree+(1:degree));
    [val, ind] = max(R2_r(i,:));
    X_norm(i,(degree+1):(degree*2)) = all_X_r(i,(ind-1)*degree+(1:degree));
end

%separate the training examples into two sets. Negative contains all of the
%normal examples and Positive contains all the abnormal examples
% all_Y_new = zeros(size(all_Y));
% all_Y_new(all_Y~=1) = 1;

all_Y_new = all_Y ~= 1;

all_Y = all_Y_new;

negative_X = X_norm(all_Y==0,:);
positive_X = X_norm(all_Y==1,:);

negative_Y = all_Y(all_Y==0,:);
positive_Y = all_Y(all_Y==1,:);

%rearrange them randomly
%select frames? [75:375,525:825]
a1 = randperm(size(negative_X,1));
a2 = randperm(size(positive_X,1));

negative_X_rand = negative_X(a1,:);
negative_Y_rand = negative_Y(a1,:);
positive_X_rand = positive_X(a2,:);
positive_Y_rand = positive_Y(a2,:);

%separate the examples into a further 3 sets. The training set is for
%creating the model. This contains only negative examples. The validation
%and test sets are for testing the model. They contain a mix of positive
%and negative examples, but more negative than positive.q = 55;

q = 2 * size(negative_X,1)/3;
r = size(negative_X,1);
s = size(positive_X,1);

training_X = negative_X_rand(1:q,:);
validation_X = [negative_X_rand((q+1):r,:); positive_X_rand(1:s,:)];

training_Y = negative_Y_rand(1:q,:);
validation_Y = [negative_Y_rand((q+1):r,:); positive_Y_rand(1:s,:)];

% %==TRAINING==% 

mu = mean(training_X);
sigma2 = var(training_X, 0, 1);

if (exist('./Training_Module_CSV/mu.csv','file') == 2)
    delete('./Training_Module_CSV/mu.csv');
end
dlmwrite('./Training_Module_CSV/mu.csv',mu);

if (exist('./Training_Module_CSV/sigma2.csv','file') == 2)
    delete('./Training_Module_CSV/sigma2.csv');
end
dlmwrite('./Training_Module_CSV/sigma2.csv',sigma2);

p = bsxfun(@times,(2*pi*sigma2).^(-1/2),exp(-bsxfun(@rdivide,(bsxfun(@minus,validation_X,mu)).^2,2*sigma2)));

p = prod(p,2);

bestEpsilon = 0;
bestF1 = 0;
bestPrec = 0;
F1 = 0;

X_test = p;
stepsize = (max(X_test) - min(X_test)) / 10000;

for epsilon = min(X_test):stepsize:max(X_test)    

    truePos = sum((X_test < epsilon) & validation_Y);
    falsePos = sum((X_test < epsilon) & ~validation_Y); 
    trueNeg = sum((X_test >= epsilon) & ~validation_Y);
    falseNeg = sum((X_test >= epsilon) & validation_Y);

    prec = truePos/(truePos + falsePos);
    rec = truePos/(truePos + falseNeg);
    F1 = (2*prec*rec)/(prec + rec);    

    if F1 > bestF1
       bestF1 = F1;
       bestEpsilon = epsilon;
       bestRec = rec;
       bestPrec = prec;
    end

end

bestEpsilon
bestRec
bestPrec
bestF1

confusionmat(validation_Y, X_test < bestEpsilon)

