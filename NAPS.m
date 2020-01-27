function [np] = NAPS(zffs, fr)
%　信号の正規化自己相関ピーク強度を計算
%  Nはフレーム幅
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M = length( zffs );
N = floor(30 * fr / 1000); %フレーム幅は30ms
shiftsize = floor(fr * 1 / 1000);

iter = floor((M-N) / shiftsize) +1;
np = zeros(iter,1);
ends = floor(N/2);
for i=1:iter
    init = ( i-1 )*shiftsize;
    suby = zffs( init+1:init+N );
    r = zeros(N,1);
    %自己相関の求め方は議論の余地あり
    for k=1:N
        for j=k+1:N
            r(k) = r(k) + suby(j)*suby(j-k);
        end
    end      
    peak = findpeaks(r(1:ends),'NPeaks',1);
    if(~isempty(peak) && peak > 0)
        %den = sum( suby.^2 );
        np(i) = peak / max(r);
    end
end
np = smooth(np,floor(0.7*1000));
np = [np; np(end)*ones(29,1)];
end

