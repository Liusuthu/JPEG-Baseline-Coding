clear;clc;
a=[1];
b=[-1 1];
[h w]=freqz(b,a);

plot(w/pi,20*log10(abs(h)))
ax = gca;
ax.YLim = [-50 10];
ax.XTick = 0:.5:2;
title('Frequency Response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (dB)');