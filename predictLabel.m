%ÉçÅ[Éh
%filename = './dataset/speech_music2.m4a';
filename = './music_speech/musp_wav/d2.wav'; 

%% ì¡í•ó 
D2 = calcFeatures(filename,0);
D2(:,1) = D2(:,1) / max(D2(:,1));
D2(:,2) = D2(:,2) / max(D2(:,2));
%% plot 4 seatures
figure
[sample, fr] = audioread( filename );
sample = downsample(sample,5);
fr = 8000;

subplot(5,1,1)
plot((0:length(sample)-1)/fr, sample)
title(filename);
ylabel('signal');

% subplot(5,1,2)
% plot((0:length(D(:,1))-1)/1000, D(:,1))
% ylabel('NAPS of ZFFS');

subplot(5,1,2)
plot((0:length(D2(:,1))-1)/1000, D2(:,1));
ylabel('PSR of HE of LPR');

subplot(5,1,3)
plot((0:length(D2(:,2))-1)/1000, D2(:,2));
ylabel('log mel energy');

% subplot(5,1,5)
% plot((0:length(D(:,4))-1)/1000, D(:,4));
% ylabel('Mod Spec');

xlabel('Time (sec)');
%% predict
label = predict(Mdl,D2(:,1:2));
label = smooth(label,1000);
subplot(5,1,4)
plot((0:length(label)-1)/1000, label);
D2(:,3) = label;