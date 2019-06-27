[y1,fs1] = audioread('ZOOM0005_Tr1.WAV');
y1 = y1(:,1);
dt = 1/fs1;
t = 0:dt:(length(y1)*dt)-dt;
plot(t,y1);
xlabel('Seconds');
ylabel('Amplitude');
title("ZOOM0005_Tr1.WAV");

figure
data_fft = fft(y1);
plot(abs(data_fft(:,1)));
title("ZOOM0005_Tr1.WAV's Frequencies");

figure
[y3,fs3] = audioread('ZOOM0005_Tr3.WAV');
y3 = y3(:,1);
dt = 1/fs3;
t = 0:dt:(length(y3)*dt)-dt;
plot(t,y3);
xlabel('Seconds');
ylabel('Amplitude');
title("ZOOM0005_Tr3.WAV");

figure
data_fft = fft(y3);
plot(abs(data_fft(:,1)));
title("ZOOM0005_Tr5WAV's Frequencies");

