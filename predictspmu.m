function label = predictspmu( sample, fr , SVM)
zffs = ZPZDZFFS(sample,fr);
% PSR of HE of LPR
psr = psrhelpr_lite(sample,zffs,fr,0.0002,0);
% log mel energy
lme = logMelEnergy2(sample,fr,0); 
%% spectral centroid
% cent = spectralCentroid(sample,fr);
% cent = [cent; cent(end)*[1;1]]; 
% %% spectral flux
% flux = spectralFlux(sample,fr);
% flux = [flux; flux(end)*[1;1]];
%% spectral rolloff Point
rop = spectralRolloffPoint(sample,fr); %100numvalues/sec -2numvalue
rop = [rop; rop(end)*[1;1]];
%% prediction
T = floor( length(lme)/1000 );
numfeature = 3;
TestDeta = zeros(T,numfeature);
for t=1:T
    TestDeta(t,1) = mean( psr( (t-1)*1000+1:t*1000 ));
    TestDeta(t,2) = var(  lme( (t-1)*1000+1:t*1000 ));
    %TestDeta(t,3) = var( cent( (t-1)*100 +1:t*100 ));
    TestDeta(t,3) = var( rop(  (t-1)*100 +1:t*100 ));
    %TestDeta(t,5) = var( flux( (t-1)*100 +1:t*100 ));
end
TestDeta(:,1:end) = TestDeta(:,1:end)./max(TestDeta(:,1:end)); %normalization
label = predict(SVM, TestDeta);

%% graph
figure
subplot(numfeature+2,1,1)
plot((0:length(sample)-1)/fr, sample)
ylabel('signal');

strarray = ["Y", "PSR", "lme", "rolloff", "centroid", "zcr", "flux"];
for i=1:numfeature
    subplot(numfeature+2,1,i+1)
    plot( (0.5:1:T-0.5),TestDeta(:,i) )
    ylabel(strarray(i+1))
end
subplot(numfeature+2,1,numfeature+2)
plot((0.5:1:T-0.5),label,'--gs','LineWidth',2,'MarkerSize',10,...
    'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,0.5]);

xlabel('Time (sec)');