addpath './DOAToolbox'
addpath './wav'
%% Initializations
%Variables:
%Fixed:
% l: distance between sensors in m
% m: number of sensors
% fs: sampling frequency
%Tunables:
% wlen: affects frequency precision, is the most important parameter
% bins: number of samples for the narrowband algo to work with
% wlen and bins set the total number of necessary samples, N
% olf: overlapping factor, integer between 0 and wlen-1
% L: precision/ resolution, how many slices to divide the angle domain
l = 0.04;        %distance between sensors in m
m = 8;           %num of sensors
fs = 8820;       %sampling frequency
wlen = 512;      %fft order, or window size
bins = 10;       %num of windows 
olf = wlen/2;    %overlapping factor for stft( fft_separate)
L = 180;         %num of divisions for [-pi/2, pi/2]
sig = 0.1;
%% Generate data
[highb,Fs ] = wavread('mono_highpitch.wav');
n = 1;
doa = [12];
[Y, ~] = simsound_planar(doa(1) * pi/180, m, l, highb(:, 1), Fs);
[Y, Fs] = downsample(Y,Fs, 5);
Y = addnoise(Y, sig);
%% Wideband DOA
[N, phicapon, phimusic , thetaesprit, f] = wideband_doa(Y, l, fs, n, wlen, bins, olf, L);

%% Spectrum
highbfft = fft(highb(:,1), length(f)*2);
figure(3);
plot(f,2*abs(Y(1:length(f)))) 

%% Plotting
% figure(3)
% plot(t, real(Y));
% xlabel('Time');
% ylabel('Value');
% title('Data set');
% legend('Sensor 1','Sensor 2','Sensor 3','Sensor 4','Sensor 5','Sensor 6','Sensor 7','Sensor 8');
% grid on

%% Plot the spatial spectrum
figure(1)
x = ((0:(L-1)) .* pi/L - pi/2); % x in radians
x = x * 180/pi; %x in degrees
imagesc(x,f, phicapon.');
xlabel('Degrees');
ylabel('Frequency');
title('Capon estimation');
grid on

figure(2)
x = ((0:(L-1)) .* pi/L - pi/2); % x in radians
x = x * 180/pi; %x in degrees
imagesc(x,f, phimusic.');
xlabel('Degrees');
ylabel('Frequency');
title('MUSIC estimation');
grid on

%% Clean-up
rmpath './DOAToolbox'
rmpath './wav'
clear Fs L N Y bins f fs l m n olf phicapon phimusic thetaesprit wlen x doa highb highbfft sig