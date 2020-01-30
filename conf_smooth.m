%ÉçÅ[Éh
%filename = './dataset/KWGEsp_mu_mid.wav';
filename = './dataset/speech_music2.m4a';
[sample, fr] = audioread( filename );

[r,c] = size(sample);
if(r<c)
    sample = transpose(sample);
end
[r,c] = size(sample);
if(c>1)
    sample = mean(sample,2);
end

%downsample
newfr = 8000;
Ratio = floor(fr / newfr);
sample = downsample(sample, Ratio);
fr = newfr;

%ê≥ãKâª
sample = sample/max(abs(sample));

m=5;
zffs = ZPZDZFFS(sample,fr);
psr = psrhelpr_lite(sample,zffs,fr,0.002,0);
lme = logMelEnergy2(sample,fr,0);
rop = zeros(length(lme),1);
ro = spectralRolloffPoint(sample,fr,'Window', rectwin(0.002*fr),'OverlapLength',0.001*fr);
rop(1:length(ro)) = ro;
rop = smooth(rop,10);
D = [psr, lme, rop];
D = D./max(D);

str = ["PSR of HE of LPR","Log Mel Energy", "Spectral Rolloff Point"];

figure
subplot(4,1,1)
plot((0:length(sample)-1)/fr, sample)
title('signal')
for i=2:4
    subplot(4,1,i)
    plot((0:length(D(:,i-1))-1)/1000, D(:,i-1));
    title(str(i-1));
end