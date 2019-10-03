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



%%  2. Capture Data (Optional)
if (cleanBuild == 1)
    samples = 1000;
    features = 2;   
    examplesPerCat = 2;
    
%     labels = {'rock', 'paper', 'scissors'};
    labels = {'left', 'right'};
    
    categories = length(labels);
    
    
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

%%  2.5 Construct deep learning model
load('data/737701.6178.mat');

inputSize = 2;
numHiddenUnits = 100;
numClasses = 2;

layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

maxEpochs = 100;
miniBatchSize = 1;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest', ...
    'Shuffle','never', ...
    'Verbose',0, ...
    'Plots','training-progress');

xTrain = xData(1);
yTrain = yData(1);

net = trainNetwork(xTrain,yTrain,layers,options);

