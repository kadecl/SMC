function label = nonLinearMapping( s , fr)
zffs = ZPZDZFFS(s,fr);
% PSR of HE of LPR
psr = psrhelpr_lite(s,zffs,fr,0.0002);
psr = psr / max(psr);

% log mel energy
lme = logMelEnergy2(s,fr); 
lme = lme / max(lme);

%% graph
figure
subplot(4,1,1)
plot((0:length(s)-1)/fr, s)
ylabel('signal');
subplot(4,1,2)
plot((0:length(psr)-1)/1000, psr);
ylabel('PSR of HE of LPR');
subplot(4,1,3)
plot((0:length(lme)-1)/1000, lme);
ylabel('log mel energy');
%%
th_psr = input('enter threshold of psr: ');
th_lme = input('enter threshold of lme: ');
psr = mapping( psr,th_psr );
lme = mapping( lme,th_lme );
summedEvidence = mapping(psr + lme, 0.4);

M = length(summedEvidence);
N = 1000;
T = floor(M/N);
label = zeros(M,1);
for t = 1:T
    label((t-1)*N+1:t*N) = mean( summedEvidence( (t-1)*N+1:t*N ) ) - 0.5 > 0;
end
figure
subplot(4,1,1)
plot((0:length(s)-1)/fr, s)
ylabel('signal');
subplot(4,1,2)
plot((0:length(psr)-1)/1000, psr);
ylabel('PSR of HE of LPR');
subplot(4,1,3)
plot((0:length(lme)-1)/1000, lme);
ylabel('log mel energy');
subplot(4,1,4)
plot((0:length(label)-1)/1000, label,'-o','MarkerIndices',1:N:length(label));
ylabel('speech/music');

xlabel('Time (sec)');
end

function ret = mapping( evid, theta )
alpha = 0;
tau = 0.001;
ret = 1./(1+exp( -(evid-theta)/tau  ) ) + alpha;
end