function ret = MTF( sig, fr )

%critical band filter (gammatonefilter‚Å‹ß—)
gtfb = gammatoneFilterBank([0,4000], 18);
filteredSig = gtfb(sig);

%half wave refrection and low pass
lowpassSig = lowpass(max(filteredSig,0), 28, fr);%, 'steepness', 0.99);

%downsampling
newfr = 80;
Rate = floor(fr/newfr);
downsampled = downsample(lowpassSig, Rate);

%normalize
downsampled = downsampled-mean(downsampled);
%downsampled = downsampled./max(abs(downsampled));

M = length(downsampled);
N = floor( 250 * newfr / 1000 );
shiftsize = floor( 14 * newfr / 1000 );
iter = floor( (M-N)/shiftsize );
mtf = zeros(iter,1);
window_ham = hamming(N);
% figure
for i=1:iter        
    loc = shiftsize * (i-1);
    subxhat = downsampled(loc+1:loc+N, :).*window_ham;
    Xhat = abs(fft( subxhat ));
    %4Hz¬•ª‚ğæ‚èo‚µ‚Ä18ƒ`ƒƒƒlƒ‹‚Ì˜a‚ğæ‚é
    index4Hz = floor(4*N/newfr);
    modSpecAmp4Hz = Xhat(index4Hz,:);%/max(Xhat(index4Hz,:));
    mtf(i) = sum(modSpecAmp4Hz.^2);
%     if(i == floor(iter/4))
%         subplot(2,1,1)
%         plot(modSpecEnergy4Hz/max(modSpecEnergy4Hz))
%     end
%     if(i == floor(iter/4)*3)
%         subplot(2,1,2)
%         plot(modSpecEnergy4Hz/max(modSpecEnergy4Hz))
%     end
end

%ret = mtf;

%upsampling
ret = upsample(mtf,13);
for i = 1:12
    ret = ret + upsample(mtf,13,i);
end