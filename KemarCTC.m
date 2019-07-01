% Setup
clc;                % Clear the command window
close all;          % Close all figures
clear;              % Erase all exsisting variables
format compact;

% Read KEMAR-recorded audiofiles
[sL, fs] = audioread("audiofiles/headphones+spkr/ZOOM0005_Tr1.wav");
[sR, fs] = audioread("audiofiles/headphones+spkr/ZOOM0005_Tr3.wav");

NFFT = length(sL);

% Read filter audiofiles
% Use 30 degrees and 330 degrees for left and right ear
gRR = audioread("audiofiles/elev0/R0e030a.wav");
gRL = audioread("audiofiles/elev0/L0e030a.wav");
gLR = audioread("audiofiles/elev0/R0e330a.wav");
gLL = audioread("audiofiles/elev0/L0e330a.wav");

% Insert Graph 1

% Covert to frequency domain using Fourier transformation
fftSR = fft(sR);
fftSL = fft(sL);

% Covert to frequency domain using Fourier transformation
fftGRR = fft(gRR, NFFT);
fftGRL = fft(gRL, NFFT);
fftGLR = fft(gLR, NFFT);
fftGLL = fft(gLL, NFFT);

% Insert Graph 2

% Calculate denominator
denominator = (fftGRR .* fftGLL - fftGRL .* fftGLR);

% Filter (K-Suke-Filter)
denominator(abs(denominator) <= 0.1) = 0.1 + 0.1i;

% Calculate H-values
hRR = fftGLL ./  denominator;
hRL = fftGRL ./ -denominator;
hLR = fftGLR ./ -denominator;
hLL = fftGRR ./  denominator;

% Calculate X-values (Frequency domain)
xR = hRR .* fftSR + hLR .* fftSL;
xL = hRL .* fftSR + hLL .* fftSL;

% Calculate Y-values
% yR = xL .* gLL + xR .* gRL;
% yL = xR .* gRR + xR .* gLR;

% Transform back to Time domain using inverse Fourier transform
% Convert to the proper length symmetrically
xr = ifft(xR, NFFT, 'symmetric');
xl = ifft(xL, NFFT, 'symmetric');

% Write output audiofile
audio = [xr xl];
audiowrite("output.wav", audio, fs);

% Insert Graph 3

%% Graph 1
% Timestep (used for plotting)
% dt = 1/fs;
% t = 0:dt:(length(gRR) * dt) - dt;

% PLOT NORMAL VERSION
% subplot(2, 2, 1);
% plot(t,gRR);
% xlabel('Seconds');
% ylabel('Amplitude');
% title("R0e010a.WAV");

% subplot(2, 2, 2);
% plot(t,gRL);
% xlabel('Seconds');
% ylabel('Amplitude');
% title("R0e350a.WAV");

% subplot(2, 2, 3);
% plot(t,gLR);
% xlabel('Seconds');
% ylabel('Amplitude');
% title("L0e010a.WAV");

% subplot(2, 2, 4);
% plot(t,gRL);
% xlabel('Seconds');
% ylabel('Amplitude');
% title("L0e350a.WAV");

%% GRAPH 2
% PLOT FFT VERSION
% figure
% subplot(2, 2, 1);
% plot(abs(fftGRR));
% xlabel('Frequency');
% ylabel('Intensity');
% title("GRR FFT");

% subplot(2, 2, 2);
% plot(abs(fftGRL));
% xlabel('Frequency');
% ylabel('Intensity');
% title("GRL FFT");

% subplot(2, 2, 3);
% plot(abs(fftGLR));
% xlabel('Frequency');
% ylabel('Intensity');
% title("GLR FFT");

% subplot(2, 2, 4);
% plot(abs(fftGLL));
% xlabel('Frequency');
% ylabel('Intensity');
% title("GLL FFT");

%% GRAPH 3
% subplot(2, 1, 1);
% plot(xr);
% subplot(2, 1, 2);
% plot(xl);

% subplot(2, 2, 3);
% plot(yR);
% subplot(2, 2, 4);
% plot(yL);
