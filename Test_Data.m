function predicted_labels_test =  Test_Data(test_X)

all_theta = csvread('./LogR_Theta.csv');

predicted_labels_test = predictOneVsAll(all_theta, test_X);
display(predicted_labels_test);