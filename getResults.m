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
cleanModel = 1;
samples = 500;
features = 8;
examplesPerCat = 100;
labels = {'left', 'right', 'nothing'};
categories = length(labels);
captures = categories*examplesPerCat;

filenameBase = num2str(now) + "flat_stationary_3";


%%  2. Capture Data (Optional)
if (cleanBuild == 0)
    load('data/737722.9685flat_config_left_right.mat');
    
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
    
end

%% 3 Proprocess Data

for capt = 1:captures
       
    for feat = 1:features
        featureSamples = xData{capt}(feat,:);
        
        % Norm the feature and replace the raw values (garbage in garbage
        % out)
        if (mod(feat,2) == 0)
            
            featureMax = max(featureSamples);
            featureMean = mean(featureSamples);
            
            % Replace feature raw values with normed values
            xData{capt}(feat,:) = featureSamples/featureMax;
            
%             % Add diff from other features
%             xData(
%             xData{capt}(end+1,:) = (featurefeature
        end
        
    end
%     
%     % Augment with Diffs from capture mean
%     vOutMeans = mean(xData{capt}([1,3,8],:));
end

if (cleanBuild)
    % Save capture
    filename = ["data/" + filenameBase + ".mat"];
    fprintf('Saving data from capture session in %s\n.', filename);
    save(filename, 'xData', 'yData', 'features', 'samples', 'labels', 'examplesPerCat', 'captures');
    
end


 %%  2.5 Construct deep learning model
if (cleanModel)
gpu1 = gpuDevice(1)

% inputSize = features;
% maxEpochs = 500;
% miniBatchSize = 100;
% numHiddenUnits = 10;
% numClasses = categories;
% layers = [ ...
%     sequenceInputLayer(inputSize)
%     lstmLayer(numHiddenUnits,'OutputMode','last')
%     fullyConnectedLayer(numClasses)
%     softmaxLayer
%     classificationLayer];

inputSize = features;
maxEpochs = 500;
miniBatchSize = 50;
numHiddenUnits1 = 10;
numHiddenUnits2 = 10;
numClasses = categories;
layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits1,'OutputMode','sequence')
    dropoutLayer(0.2)
    lstmLayer(numHiddenUnits2,'OutputMode','last')
    dropoutLayer(0.2)
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];



% Randomize dataset
idx = randperm(captures);
P = .8;
splitIdx = round(P*captures);

% Randomize dataset
idx = randperm(captures);
P = .8;
splitIdx = round(P*captures);

xTrain = xData(idx(1:splitIdx));
yTrain = yData(idx(1:splitIdx));

% Validate trained data
xTest = xData(idx(splitIdx+1:end));
yTest = yData(idx(splitIdx+1:end));

options = trainingOptions('adam', ...
    'ExecutionEnvironment','gpu', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest', ...
    'Shuffle','once', ...
    'Verbose',1, ...
    'Plots','training-progress', ...
    'OutputFcn',@(info)saveTrainingPlot(info),...
    'ValidationData', {xTest, yTest});

diary flat_config_left_right_3.txt
net = trainNetwork(xTrain,yTrain,layers,options);
diary off

yPred = classify(net,xTest);
plotconfusion(yTest, yPred);
filename = ["plots/" + filenameBase + "_confusion_plot.fig"];
saveas(gcf,filename)  % save figure as .png, you can change this
save("models/" + filenameBase + "_model.mat", 'net');
end

%% Visualie results

% dims = features/2;
% 
% Visualise all channel data for each category, example picked at random.
% figure
% subplot(2,1,1);
% plot(1:(samples), xData{1}([1,3,5],1:end));
% title('Right hand configuration: Voltage out ADC Readings. Left swipe gesture.','interpreter','tex');
% grid on;
% 
% xlabel('Sample #');
% ylabel('Square Wave Logicial Value')
% set(get(gca,'Title'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'XLabel'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'XAxis'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'YLabel'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'YAxis'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'ZLabel'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'ZAxis'),'Fontname','Times','FontSize',12.5);
% 
% subplot(2,1,2);
% plot(1:(samples), xData{1}([2,4,6],1:end));
% title('Right hand configuration: PWM out. Left swipe gesture.','interpreter','tex');
% 
% colorbar off
% grid on;
% xlabel('Sample #');
% ylabel('ADC Reading');
% set(get(gca,'Title'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'XLabel'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'XAxis'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'YLabel'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'YAxis'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'ZLabel'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'ZAxis'),'Fontname','Times','FontSize',12.5);
% 
% Spectrograms of each channel
% spectrogram(xData{1}([1,3,5],:));
% view(0,0);
% set(get(gca,'Title'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'XLabel'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'XAxis'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'YLabel'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'YAxis'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'ZLabel'),'Fontname','Times','FontSize',12.5);
% set(get(gca,'ZAxis'),'Fontname','Times','FontSize',12.5);
% 
% 
% 
