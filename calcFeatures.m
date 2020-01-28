function D = calcFeatures(filename, sp_mu, numfeatures)
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

    M = length( sample );
    %N = floor(30 * fr / 1000);
    %shiftsize = floor(fr * 1 / 1000);
    %iter = floor((M-N) / shiftsize)+30;

    zffs = ZPZDZFFS(sample,fr);
    T = floor(M/fr);%入ってきたサンプルの時間
    D = zeros(T,7);
    if(sp_mu == 1)
        D(:,1) = 1;
    end
    
    %% naps of zffs
    % naps = NAPS(zffs, fr);
    %% PSR of HE of LPR
    psr = psrhelpr_lite(sample,zffs,fr,0.0002,0);
    %% log mel energy
    lme = logMelEnergy2(sample,fr,0);
    %% modulation spectrogram
    %mtf = MTF(sample,fr);
    %mtf = smooth(mtf,floor(fr*0.1));
    %% spectral centroid
    cent = spectralCentroid(sample,fr);
    cent = [cent; cent(end)*[1;1]]; 
    %% spectral flux
    flux = spectralFlux(sample,fr);
    flux = [flux; flux(end)*[1;1]];
    %% spectral rolloff Point
    rop = spectralRolloffPoint(sample,fr); %100numvalues/sec -2numvalue
    rop = [rop; rop(end)*[1;1]];
    
    if T ~= floor(length(rop)/100)
        exit()
    end
    
    %% zero crossing rate
    zcr = ZCR(sample,fr);
    
    for t=1:T
        D(t,2) = mean(psr( (t-1)*1000+1:t*1000 ));
        D(t,3) = var( lme( (t-1)*1000+1:t*1000 ));
        D(t,4) = var( cent( (t-1)*100 +1:t*100 ));
        D(t,5) = var( flux( (t-1)*100 +1:t*100 ));
        D(t,6) = var( rop(  (t-1)*100 +1:t*100 ));        
    end
    D(:,7) = zcr;
    %% plot 4 seatures
figure
% [sample, fr] = audioread( filename );
% sample = downsample( sample, floor(fr/1000) );
% subplot(4,1,1)
% plot((0:length(sample)-1)/fr, sample)
% title(filename);
% ylabel('signal');
% 
% subplot(3,1,1)
% plot((0:length(naps)-1)/1000, naps)
% ylabel('NAPS of ZFFS');

strarray = ["Y","PSR", "lme", "centroid", "flux", "rolloff", "zcr"];
title(filename);
for i=1:numfeatures
    subplot(numfeatures,1,i)
    plot(D(:,i+1));
    ylabel(strarray(i+1));
end
title(filename);
xlabel('Time (sec)');
end