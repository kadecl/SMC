function psr = psrhelpr_lite(sig, zffs, fr, threshold)
M = length(sig);
N = 30*fr/1000;
shiftsize = 1*fr/1000;
iter = floor( (M-N)/shiftsize ) +1;
psr = zeros(iter,1);

searchRangeHalf = 3*fr/(1000); %ゼロ交差からepochを探すときの範囲の半分
halfPitchPeriod = floor(0.005*fr/2); %片側サイドローブのサンプル数

for j = 1:iter
    loc = (j-1)*shiftsize;
    x = sig(loc+1: loc+N);
    e = filter( lpc(x, 10), 1, x );
    he = abs( hilbert(e));
    ZeroCrossLoc = zci(zffs(loc+1:loc+N));
    
    num_zc = length(ZeroCrossLoc);
    psrs = zeros(num_zc,1);
    if num_zc ~= 0
        for i=1:num_zc
            zeroloc = ZeroCrossLoc(i); %i番目のゼロクロス
            search_start = max(1,zeroloc-searchRangeHalf);
            search_end = min(N,zeroloc+searchRangeHalf);
            [peak,peakindex] = max(he(search_start:search_end));
            epochlocation = peakindex + search_start -1; %i番目のゼロクロスに対するピークのフレーム内インデックス
            if epochlocation > (5+halfPitchPeriod) && ...
                    epochlocation < (N-4-halfPitchPeriod) && peak > threshold
                sidelobe = [he(epochlocation-5-halfPitchPeriod : epochlocation-5);...
                    he(epochlocation+5 : epochlocation+5+halfPitchPeriod)];                     
                psrs(i) = peak/(var(sidelobe));
            %             epochs(epochlocation) = peaks_j;%イラン
            %             sidelobe_var(epochlocation) = var(sidelobe); %イラン
            %             frame = [he(epochlocation-5-halfPitchPeriod : epochlocation-5);...
            %                he(epochlocation);he(epochlocation+5 : epochlocation+5+halfPitchPeriod)];
            %             figure; plot(frame); %ピークとサイドローブがどうなってるかを確認
            end
        end
        psr(j) = mean(psrs);
    end
end 

psr = smooth(psr,floor(1000*1));
psr = [psr;psr(end)*ones(29,1)];
end