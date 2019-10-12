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
samples = 1000;
features = 2;
examplesPerCat = 50;
labels = {'left', 'right'};
categories = length(labels);
captures = categories*examplesPerCat;


%%  2. Capture Data (Optional)
if (cleanBuild == 1)
    
    
    xData = cell(examplesPerCat, categories);
    yData = zeros(examplesPerCat, categories);
    
    for i = 1:categories
        fprintf("Next Gesture: %s. READY?\n", labels{i});
        pause(2);
        for m = 1:examplesPerCat
            disp("Next Example");
            xData{m,i} = generateData(samples);
            yData(m,i) = i;
        end
    end
    
    xData = reshape(xData,categories*examplesPerCat,1);
    yData = categorical( reshape(yData,categories*examplesPerCat,1) );
    
    filename = ["data/" + num2str(now) + ".mat"];
    fprintf('Saving [xData, yData] from session in %s\n.', filename);
    save(filename, 'xData', 'yData');
    
end

load('data/737701.6431.mat');

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
for i = 1:features
    featureSamples = xData{randIndex}(i,:);
    featureMax = max(featureSamples);
    featureMean = mean(featureSamples);
    
    xDataNormed(i,:) = featureSamples/ featureMax;
    
end
figure;
plot(1:samples, xDataNormed, 'ro');
grid on;
xlabel('Sample #');
ylabel('Normed Value');
titleStr = ["NORMED feature values against t (s/div), capture #", randIndex];
title(titleStr);



%%  2.5 Construct deep learning model
% load('data/737701.6178.mat');

numHiddenUnits = 10;
numClasses = categories;
inputSize = features;

gpu1 = gpuDevice(1)

layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

maxEpochs = 100;
miniBatchSize = 128;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest', ...
    'Shuffle','never', ...
    'Verbose',1, ...
    'Plots','training-progress');

trainIdx = 0.8*length(xData);
valIdx = length(xData);

xTrain = xDataNormed(1:trainIdx);
yTrain = yData(1:trainIdx);

net = trainNetwork(xTrain,yTrain,layers,options);

