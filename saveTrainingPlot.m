% Helper function to save the plot of the trained neural network

function stop=saveTrainingPlot(info)
stop=false;  %prevents this function from ending trainNetwork prematurely
if info.State=='done'   %check if all iterations have completed
    % if true
    filename = ["plots/" + num2str(now) + "_training_plot.eps"];
    f = findall(groot, 'Type', 'Figure');
    saveas(f(1),filename)  % save figure as .png, you can change this
end
end