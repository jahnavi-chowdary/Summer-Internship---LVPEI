function Predicted_Label =  Test_Data(test_X)

global bestEpsilon

mu = csvread('./Training_Module_CSV/mu.csv');
sigma2 = csvread('./Training_Module_CSV/sigma2.csv');

p = bsxfun(@times,(2*pi*sigma2).^(-1/2),exp(-bsxfun(@rdivide,(bsxfun(@minus,test_X,mu)).^2,2*sigma2)));
p = prod(p,2);

if p < bestEpsilon
    Predicted_Label = 0
    display('Unfortunately ABMORMAL :(');
else
    Predicted_Label = 1
    display('Yayyy NORMAL :)')
end

