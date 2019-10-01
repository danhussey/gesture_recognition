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
% Data generation parameters
cleanBuild = 1;
samples = 1000;



%%  2. Capture Data (Optional)
if (cleanBuild == 1)
    labels = {'rock', 'paper', 'scissors'};
    gestureData = cell(3, 10);
    
    for i = 1:3
        fprintf("Next Gesture: %s. READY?\n", labels{i});
        pause(2);
        for m = 1:10
            disp("Next Example");
            gestureData{i, m} = generateData(samples);
        end
    end
    
    savefile = 'data.mat';
    save(savefile, 'gestureData');
end

%%  2.5 Construct deep learning model in Matlab Class
