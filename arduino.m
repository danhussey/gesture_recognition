
% Author: Daniel Hussey
% Capture a gesture using arduino and radar module

%% Initialisation
% Connect to the arduino
ardPort = '/dev/cu.usbmodem14221';
ard = arduino(ardPort);

% Check if arduino is connected
if (~ard)
    error('Error connecting to arduino.');
end

% Check if the analog pints

%% Capture

% Capture a 2 second reading from the module
t_start = 0;
t_end = 2;


% Perform signal processing

% Generate spectrogram

% Label and save spectrogram to disk