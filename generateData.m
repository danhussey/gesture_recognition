%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function to generate categorised spectrograms of digit gestures

function data = generateData (samples)

features = 2;

% Open serial connection
s1 = serial("/dev/cu.usbmodem14201", 'BaudRate', 115200);
fopen(s1);

% Data capture
iter = 1;
dataRaw = cell(iter,1);
for iter = 1:samples
    dataRaw{iter} = fscanf(s1);
    if (iter==1)
        fprintf("REC ");
    end
end
fprintf("END\n");

% fprintf(s1, '*IDN?')
% idn = fscanf(s1)

fclose(s1);
delete(s1);

data = zeros(samples, features);
for i = 2:samples
    data(i,1:features)= str2num(dataRaw{i});
end

end