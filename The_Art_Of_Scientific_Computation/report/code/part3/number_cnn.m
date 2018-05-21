%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Haonan Li, reference: MATLAB Documentation              %
% Purpose:  Train a classifier for hand write number recogonize     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load datasets
dataset = fullfile(matlabroot,'toolbox','nnet','nndemos', ...
    'nndatasets','DigitDataset');
imgs = imageDatastore(dataset, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');

%% display some iamges
% figure;
% perm = randperm(10000,15);
% for i = 1:15
%     subplot(3,5,i);
%     imshow(imgs.Files{perm(i)});
% end

% get the size of images, it will use in input layer
img = readimage(imgs,1);
size(img);
% count label for spliting training and test set
labelCount = countEachLabel(imds);

%% training and test set
train_size = 750;
[img_train,img_test] = splitEachLabel(imgs,train_size,'randomize');

%% network architecture
layers = [
    imageInputLayer([28 28 1])
    
    convolution2dLayer(3,8,'Padding',1)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding',1)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding',1)
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer];

% training options
options = trainingOptions('sgdm', ...
    'MaxEpochs',4, ...
    'ValidationData',img_test, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');

%% train network
net = trainNetwork(img_train,layers,options);

% result
pred_label = classify(net,img_test);
test_label = img_test.Labels;

accuracy = sum(pred_label == test_label)/numel(test_label)