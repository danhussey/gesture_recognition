%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function to generate categorised spectrograms of digit gestures

function data = generateData (samples, features)


% Open serial connection
s1 = serial("/dev/cu.usbmodem14201", 'BaudRate', 115200);
fopen(s1);
fprintf(s1, '*IDN?');
idn = fscanf(s1);

% Data capture
% dataRaw = cell(iter,1);
for iter = 1:samples
    if (iter==1)
        fprintf("REC ");
    end
    dataRaw{iter} = fscanf(s1);
end
fprintf("END\n");

fclose(s1);
delete(s1);

data = zeros(samples, features);
for i = 1:samples
    data(i,1:features)= str2num(dataRaw{i});
end

data = data';
end