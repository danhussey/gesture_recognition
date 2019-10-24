%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function to visualise the data features from a captured gesture
visualiseCapture

samples = 500;
features = 8;

data = generateData(samples, features);

 
figure
subplot(2,1,1);
plot(1:(samples), data(1:end,[1,3,5]));
title('Right hand configuration: Voltage out ADC Reading. Left swipe gesture.');
grid on;

xlabel('Sample #');
ylabel('Square Wave Logicial Value')
set(get(gca,'Title'),'Fontname','Times','FontSize',12.5);
set(get(gca,'XLabel'),'Fontname','Times','FontSize',12.5);
set(get(gca,'XAxis'),'Fontname','Times','FontSize',12.5);
set(get(gca,'YLabel'),'Fontname','Times','FontSize',12.5);
set(get(gca,'YAxis'),'Fontname','Times','FontSize',12.5);
set(get(gca,'ZLabel'),'Fontname','Times','FontSize',12.5);
set(get(gca,'ZAxis'),'Fontname','Times','FontSize',12.5);


subplot(2,1,2);
plot(1:(samples), data(1:end,[2,4,6]));
title('Right hand configuration: PWM out. Left swipe gesture.');

colorbar off
grid on;
xlabel('Sample #');
ylabel('ADC Reading');
set(get(gca,'Title'),'Fontname','Times','FontSize',12.5);
set(get(gca,'XLabel'),'Fontname','Times','FontSize',12.5);
set(get(gca,'XAxis'),'Fontname','Times','FontSize',12.5);
set(get(gca,'YLabel'),'Fontname','Times','FontSize',12.5);
set(get(gca,'YAxis'),'Fontname','Times','FontSize',12.5);
set(get(gca,'ZLabel'),'Fontname','Times','FontSize',12.5);
set(get(gca,'ZAxis'),'Fontname','Times','FontSize',12.5);

% Spectrograms of each channel
spectrogram(data(:,2)');
view(0,0);
set(get(gca,'Title'),'Fontname','Times','FontSize',12.5);
set(get(gca,'XLabel'),'Fontname','Times','FontSize',12.5);
set(get(gca,'XAxis'),'Fontname','Times','FontSize',12.5);
set(get(gca,'YLabel'),'Fontname','Times','FontSize',12.5);
set(get(gca,'YAxis'),'Fontname','Times','FontSize',12.5);
set(get(gca,'ZLabel'),'Fontname','Times','FontSize',12.5);
set(get(gca,'ZAxis'),'Fontname','Times','FontSize',12.5);




%% Question 4: Sensory Substitution Process
% 
% % Part A
% dims = features/2;
% t = linspace(0,0.5,samples);
% 
% % Part B
% 
% % Make sine waves of each frequency
% freqs = [];
% freq = 10;  % Hz
% for i = 1:dims
%     freqs{i} = sin(2*pi*freq*i*t);
% end
% 
% 
% waves = [];
% 
% % For each dimension 
% for j = 1 : dims
%     
%     if (mod(j,2)
%         
%     % Create the tone wave from each pair of inputs (dimensions / HB100's)
%     waves{j} = zeros(1,samples);
%     col = data(:,j)
%     col = xD z8_new(:,j)';
%     % Modulate Amplitude by returned square wave (tolerance .6*vcc)
%         waves{j} = waves{j} + freqs{i} * col(i);
%         
%         % Modulate Frequency by returned signal strength
%         waves{j} = waves{j} + freqs{i} * col(i);
% 
%     % Itterate for each dimension
%     for i = 1 : dims
%         % Modulate Amplitude by returned square wave (tolerance .6*vcc)
%         waves{j} = waves{j} + freqs{i} * col(i);
%         
%         % Modulate Frequency by returned signal strength
%         waves{j} = waves{j} + freqs{i} * col(i);
%         
%     end
%     
%     % Normalise the wave
%     waves{j} = normalize(waves{j},'range',[-1,1]);
% 
% end
% 
% % Creates a figure
% figure(5);
% set(gcf,'color','w');
% % Title for overall figure
% subtitle('Spatial components');
% for i = 1 : dims
%     subplot(dims, 1, i)
%     plot(t,waves{i});
%     y_lab = sprintf('Dimension %.f', i);
%     ylabel(y_lab);
% end
% 
% 
% xlabel('time(s)');

% plot(1:end, data(2:end,1));
% hold on;
% plot(1:end,data(2:end,2));
% grid on;
