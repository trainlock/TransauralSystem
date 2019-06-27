% Setup
clc;                % Clear the command window
close all;          % Close all figures
clear;              % Erase all exsisting variables
format compact;

% Read KEMAR-recorded audiofiles
sL = audioread("audiofiles/headphones+spkr/ZOOM0005_Tr1.wav");
sR = audioread("audiofiles/headphones+spkr/ZOOM0005_Tr3.wav");

audioLength = length(sL);

% Read filter audiofiles
% [gRR, fs] = audioread("audiofiles/headphones+spkr/R0e010a.wav");
% gRL = audioread("audiofiles/headphones+spkr/R0e350a.wav");
% gLR = audioread("audiofiles/headphones+spkr/L0e010a.wav");
% gLL = audioread("audiofiles/headphones+spkr/L0e350a.wav");
[gRR, fs] = audioread("audiofiles/elev0/R0e030a.wav");
gRL = audioread("audiofiles/elev0/R0e330a.wav");
gLR = audioread("audiofiles/elev0/L0e030a.wav");
gLL = audioread("audiofiles/elev0/L0e330a.wav");

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

% Covert to frequency domain using Fourier transformation
fftGRR = fft(gRR, audioLength);
fftGRL = fft(gRL, audioLength);
fftGLR = fft(gLR, audioLength);
fftGLL = fft(gLL, audioLength);

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

% Calculate denominator
denominator = (fftGRR .* fftGLL - fftGRL .* fftGLR);

% Filter (K-Suke-Filter=)
denominator(abs(denominator) >= 0.01) = 0.1 + 0.1i;

% Calculate H-values
hRR = fftGLL ./ denominator;
hRL = fftGLR ./ denominator;
hLR = fftGRL ./ denominator;
hLL = fftGRR ./ denominator;

% Covert to frequency domain using Fourier transformation
fftSR = fft(sR);
fftSL = fft(sL);

% Calculate X-values (Frequency domain)
xR = hRR .* fftSR - hLR .* fftSL;
xL = hRL .* fftSR - hLL .* fftSL;

% Calculate Y-values
% yR = xL .* gLL + xR .* gRL;
% yL = xR .* gRR + xR .* gLR;

% Transform back to Time domain using inverse Fourier transform
% Convert to the proper length symmetrically
xl = ifft(xL, 'symmetric');
xr = ifft(xR, 'symmetric');

% Write output audiofile
audio = [xl xr];
audiowrite("output.wav", audio, fs);

% subplot(2, 1, 1);
% plot(xr);
% subplot(2, 1, 2);
% plot(xl);

% subplot(2, 2, 3);
% plot(yR);
% subplot(2, 2, 4);
% plot(yL);