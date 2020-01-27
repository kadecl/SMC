function label = predictspmu( sample, fr , SVM)
zffs = ZPZDZFFS(sample,fr);
% PSR of HE of LPR
psr = psrhelpr_lite(sample,zffs,fr,0.0002);
psr = psr / max(psr);
% log mel energy
lme = logMelEnergy2(sample,fr); 
lme = lme / max(lme);

%% prediction
D = [psr, lme];
label = predict(SVM, D);

%% graph
figure
subplot(5,1,1)
plot((0:length(sample)-1)/fr, sample)
ylabel('signal');

% subplot(5,1,2)
% plot((0:length(D(:,1))-1)/1000, D(:,1))
% ylabel('NAPS of ZFFS');

subplot(5,1,2)
plot((0:length(D(:,1))-1)/1000, D(:,1));
ylabel('PSR of HE of LPR');

subplot(5,1,3)
plot((0:length(D(:,2))-1)/1000, D(:,2));
ylabel('log mel energy');

subplot(5,1,4)
plot((0:length(label)-1)/1000, label);

xlabel('Time (sec)');