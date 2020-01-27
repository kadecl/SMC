function D = calcFeatures(filename, sp_mu)
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
    %sample = sample/max(abs(sample));

    M = length( sample );
    N = floor(30 * fr / 1000);
    shiftsize = floor(fr * 1 / 1000);
    iter = floor((M-N) / shiftsize)+30;
    if(sp_mu == 0)
        Y = zeros(iter,1);
    else
        Y = ones(iter,1);
    end
    
    zffs = ZPZDZFFS(sample,fr);
    %% naps of zffs
    % naps = NAPS(zffs, fr);
    %% PSR of HE of LPR
    psr = psrhelpr_lite(sample,zffs,fr,0.0002);
    %% log mel energy
    lme = logMelEnergy2(sample,fr);
    %% modulation spectrogram
    %mtf = MTF(sample,fr);
    %mtf = smooth(mtf,floor(fr*0.1));
    
   D = [Y,psr,lme]; 
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

subplot(2,1,1)
plot((0:length(psr)-1)/1000, psr);
ylabel('PSR of HE of LPR');

subplot(2,1,2)
plot((0:length(lme)-1)/1000, lme);
ylabel('log mel energy');
% 
% % subplot(5,1,5)
% % plot((0:length(D(:,4))-1)/1000, D(:,4));
% % ylabel('Mod Spec');
% 
% xlabel('Time (sec)');
end