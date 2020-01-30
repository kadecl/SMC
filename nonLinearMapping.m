function label = nonLinearMapping( s , fr)
zffs = ZPZDZFFS(s,fr);
% PSR of HE of LPR
psr = psrhelpr_lite(s,zffs,fr,0.0002,1);
psr = psr / max(psr);

% log mel energy
lme = logMelEnergy2(s,fr,1); 
lme = lme / max(lme);

% rolloff
rop = zeros(length(lme),1);
ro = spectralRolloffPoint(s,fr,'Window', rectwin(0.002*fr),'OverlapLength',0.001*fr);
rop(1:length(ro)) = ro;
rop = movvar(rop,fr);
%disp(length(lme)-length(rop));
rop = rop / max(rop);

%% graph
figure
subplot(5,1,1)
plot((0:length(s)-1)/fr, s)
ylabel('signal');
subplot(5,1,2)
plot((0:length(psr)-1)/1000, psr);
ylabel('PSR of HE of LPR');
subplot(5,1,3)
plot((0:length(lme)-1)/1000, lme);
ylabel('log mel energy');
subplot(5,1,4)
plot((0:length(rop)-1)/1000, rop);
ylabel('spectral rolloff point');
%%
th_psr = input('enter threshold of psr: ');
th_lme = input('enter threshold of lme: ');
th_rop = input('enter threshold of lme: ');
psr = mapping( psr,th_psr );
lme = mapping( lme,th_lme );
rop = mapping( rop, th_rop);
summedEvidence = mapping(psr + lme + rop, 0.4);

M = length(summedEvidence);
N = 1000;
T = floor(M/N);
label = zeros(T,1);
for t = 1:T
    label(t) = mean( summedEvidence( (t-1)*N+1:t*N ) ) - 0.5 > 0;
end
figure
subplot(5,1,1)
plot((0:length(s)-1)/fr, s)
title('signal');
subplot(5,1,2)
plot((0:length(psr)-1)/1000, psr);
ylim([-0.1 1.1])
title(['PSR of HE of LPR \theta = ',num2str(th_psr)] );
subplot(5,1,3)
plot((0:length(lme)-1)/1000, lme);
ylim([-0.1 1.1])
title(['log mel energy \theta = ',num2str(th_lme)]);
subplot(5,1,4)
plot((0:length(rop)-1)/1000, rop);
ylim([-0.1 1.1])
title(['rolloff point \theta = ',num2str(th_rop)]);
subplot(5,1,5)
plot((0.5:1:length(label)-0.5), label,'-o','MarkerIndices',1:length(label));
title('speech/music');

xlabel('Time (sec)');
end

function ret = mapping( evid, theta )
alpha = 0;
tau = 0.001;
ret = 1./(1+exp( -(evid-theta)/tau  ) ) + alpha;
end