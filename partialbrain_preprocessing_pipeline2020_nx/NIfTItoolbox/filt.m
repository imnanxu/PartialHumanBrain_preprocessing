function [ filt_out ] = myFilt( data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%filter the data
% All frequency values are in Hz.
Fs = 4/3;  % Sampling Frequency
N   = 50;    % Order
Fc1 = 0.01;  % First Cutoff Frequency
Fc2 = 0.2;   % Second Cutoff Frequency

%design a butterworth filter
h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hd = design(h, 'butter');

[n_vox, n_time] = size(data);
filt_out = zeros(size(data));

for i = 1:n_vox
    filt_out(i,:) = filter(Hd, data(i,:));
end

filt_out = filt_out(:,N+1:n_time-N);

end

