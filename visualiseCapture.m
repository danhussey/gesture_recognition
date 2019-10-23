%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function to visualise the data features from a live gesture capture

close all;
clear; 
clc;

features = 8;
samples = 1000;

% Open serial connection
s1 = serial("/dev/cu.usbmodem14101", 'BaudRate', 115200);
fopen(s1);


% Data capture
iter = 1;
dataRaw = cell(iter,1);
tic
for iter = 1:samples
    dataRaw{iter} = fscanf(s1);
    if (iter==1)
        fprintf("REC ");
    end
end
fprintf("END\n");
toc

fclose(s1);
delete(s1);

data = zeros(samples, features);
for i = 2:samples
    data(i,1:features)= str2num(dataRaw{i})';
end


% Plot 
figure
subplot(2,1,1);
plot(1:(samples), data(1:end,[1,3,5,7]));
title('Triangular configuration: Voltage out ADC Reading.','interpreter','tex');
grid on;

xlabel('Sample #');
ylabel('Square Wave Logicial Value (0 or 1)')
set(get(gca,'Title'),'Fontname','Times','FontSize',12.5);
set(get(gca,'XLabel'),'Fontname','Times','FontSize',12.5);
set(get(gca,'XAxis'),'Fontname','Times','FontSize',12.5);
set(get(gca,'YLabel'),'Fontname','Times','FontSize',12.5);
set(get(gca,'YAxis'),'Fontname','Times','FontSize',12.5);
set(get(gca,'ZLabel'),'Fontname','Times','FontSize',12.5);
set(get(gca,'ZAxis'),'Fontname','Times','FontSize',12.5);
subplot(2,1,2);
plot(1:(samples), data(1:end,[2,4,6,8]));

% spectrogram(data(:,2)'); % See feature 1 
% view(0,0);

title('Triangular configuration: Voltage out.','interpreter','tex');

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

% plot(1:end, data(2:end,1));
% hold on;
% plot(1:end,data(2:end,2));
% grid on;
