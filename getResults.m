%%  What's the minimum I need to code to get the most results done by tomorrow?

%   Hypothesis: 
% Then I need to:
%   1. Capture several (tonnes) snapshots of two getures moving in front of
%   the sensor(s), with othervariables being controlled for. Like an 
%   experiment.
%   2. Generate several spectrograms of each digit gesture
%   2.5 Construct a Deep Learning model in the Matlab toolbox
%   3. Train a multi-category cnn on the spectrograms, each example labelled with their gesture category.
%   4. Test the cnn on a validation set
%   5. Graph the validation set accuracy and hyperparameter values vs epoch
%   6. Comment on the level of accuracy reached, why you think you got
%   your results, how you could do better next time. Refine your
%   hypothesis

%%  1. Init 

clear;
clc;
close all;
instrreset;

% Data generation parameters
cleanBuild = 0;
cleanModel = 0;
samples = 1000;
features = 4;
examplesPerCat = 20;
labels = {'left', 'right', 'none'};
categories = length(labels);
captures = categories*examplesPerCat;

filenameBase = num2str(now);


%%  2. Capture Data (Optional)
if (cleanBuild == 0)
    load('data/737713.9615.mat');
    
elseif (cleanBuild == 1)
    
    xData = cell(examplesPerCat, categories);
    yData = zeros(examplesPerCat, categories);
    
    for i = 1:categories
        fprintf("Next Gesture: %s. READY?\n", labels{i});
        pause(2);
        for m = 1:examplesPerCat
            disp("Next Example");
            xData{m,i} = generateData(samples, features);
            yData(m,i) = i;
        end
    end
    
    xData = reshape(xData,categories*examplesPerCat,1);
    yData = categorical( reshape(yData,categories*examplesPerCat,1) );
    
    filename = ["data/" + filenameBase + ".mat"];
    fprintf('Saving [xData, yData] from session in %s\n.', filename);
    save(filename, 'xData', 'yData');
    
end

%% Visualise Data
close all;
rng(3,'twister');
randIndex = randi([0, captures],1,1);

% Show an example of a capture
figure;
plot(1:samples, xData{randIndex}, 'ro');
grid on;
xlabel('Sample #');
ylabel('Raw Value');
titleStr = ["RAW feature values against t (s/div), capture #", randIndex];
title(titleStr);

% Show those same features normalised for that one sample.
% for i = 1:features
%     featureSamples = xData{randIndex}(i,:);
%     featureMax = max(featureSamples);
%     featureMean = mean(featureSamples);
%     
%     xDataNormed(i,:) = featureSamples/ featureMax;
%     
% end
% figure;
% plot(1:samples, xDataNormed, 'ro');
% grid on;
% xlabel('Sample #');
% ylabel('Normed Value');
% titleStr = ["NORMED feature values against t (s/div), capture #", randIndex];
% title(titleStr);



%%  2.5 Construct deep learning model
% load('data/737701.6178.mat');

numHiddenUnits = 15;
numClasses = categories;
inputSize = features;

% gpu1 = gpuDevice(1)

layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

maxEpochs = 10000;
miniBatchSize = 100;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','gpu', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest', ...
    'Shuffle','once', ...
    'Verbose',1, ...
    'Plots','training-progress', ...
    'OutputFcn',@(info)saveTrainingPlot(info));

% Randomize dataset
idx = randperm(captures);
P = .8;
// splitIdx = round(P*captures);

% Randomize dataset
idx = randperm(captures);
P = .8;
splitIdx = round(P*captures);

xTrain = xDataNormed(idx(1:splitIdx));
yTrain = yData(idx(1:splitIdx));

net = trainNetwork(xTrain,yTrain,layers,options);

% Validate trained data
xTest = xDataNormed(idx(splitIdx+1:end));
yTest = yData(idx(splitIdx+1:end));

yPred = classify(net,xTest);
plotconfusion(yTest, yPred);
