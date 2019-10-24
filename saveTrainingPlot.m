% Helper function to save the plot of the trained neural network

function stop=saveTrainingPlot(info)
% if info.State ~= 'start'
%     filename = "logs/rh_config_refined_training_log.mat";
%     storedTrainingData = load(filename);
%     storedTrainingData(end+1) = info;
% end

stop=false;  %prevents this function from ending trainNetwork prematurely
if info.State=='done'   %check if all iterations have completed
    % if true
    filename = ["plots/" + num2str(now) + "_training_plot.eps"];
    f = findall(groot, 'Type', 'Figure');
    saveas(f(1),filename)  % save figure as .png, you can change this
end
end