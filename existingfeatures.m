config;

zcr = ZCR(sample,fr);
centroid = spectralCentroid(sample,fr);
centroid = smooth(centroid, fr/100);
flux = spectralFlux(sample,fr);
rolloff = spectralRolloffPoint(sample,fr);
rolloff = smooth(rolloff, fr*1.3/100);
entropy = spectralEntropy(sample, fr);
entropy = smooth(entropy, fr*0.5/100);

figure
subplot(6,1,1)
plot((0:length(sample)-1)/fr, sample);
subplot(6,1,2)
plot((0:length(zcr)-1)/1000, zcr);
ylabel('ZCR (%)')
subplot(6,1,3)
t = linspace(0,length(sample)/fr,length(centroid));
plot(t,centroid)
ylabel('Centroid (Hz)')
subplot(6,1,4)
t = linspace(0,length(sample)/fr,length(flux));
plot(t,flux)
ylabel('Flux')
subplot(6,1,5)
t = linspace(0,length(sample)/fr,length(rolloff));
plot(t,rolloff)
ylabel('Rolloff Point (Hz)')
subplot(6,1,6)
t = linspace(0,size(sample,1)/fr,size(entropy,1));
plot(t,entropy)
ylabel('Entropy')
xlabel('Time (s)')