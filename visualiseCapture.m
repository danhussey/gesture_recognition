%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function to visualise the data features from a live gesture capture

close all;
clear; 
clc;

features = 4;
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

figure;
plot(1:(samples-1), data(2:end,:));

% spectrogram(data(:,1)'); % See feature 1 
% figure;
% plot(1:end, data(2:end,1));
% hold on;
% plot(1:end,data(2:end,2));
% grid on;
