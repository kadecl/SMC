filename = './music_speech/speech_wav_heap/charles.wav';
%filename = './dataset/a_long.m4a';
[sig, fr] = audioread( filename );

[r,c] = size(sig);
if(r<c)
    sig = transpose(sig);
end
[r,c] = size(sig);
if(c>1)
    sig = mean(sig,2);
end

%downsample
newfr = 8000;
Ratio = floor(fr / newfr);
sig = downsample(sig, Ratio);
fr = newfr;

M = length(sig);
N = 30*fr/1000;
shiftsize = 30*fr/1000;
iter = floor((M-N)/shiftsize);
zffs = ZPZDZFFS(sig,fr);

st = floor( M*26/30 );
en = floor( M*28/30 );
sample = sig(st:en);
zffs = zffs(st:en);

searchRangeHalf = 2*fr/(1000); %ゼロ交差からepochを探すときの範囲の半分
halfPitchPeriod = floor(0.005*fr/2); %片側サイドローブのサンプル数
for j = 1:6
    loc = (j-1)*shiftsize;
    x = sample(loc+1: loc+N);
    e = filter( lpc(x, 10), 1, x );
    he = abs( hilbert(e));
%     
%     figure
%     subplot(2,1,1)
%     plot(x)
%     subplot(2,1,2)
%     plot(he);
%     hold on
%     plot(zffs(loc+1:loc+N))
%     ylim([0 0.2])

        ZeroCrossLoc = zci(zffs(loc+1:loc+N));
    
    num_zc = length(ZeroCrossLoc);
    psrs = zeros(num_zc,1);
    if num_zc ~= 0
        for i=1:num_zc
            zeroloc = ZeroCrossLoc(i); %i番目のゼロクロス
            search_start = max(1,zeroloc-searchRangeHalf);
            search_end = min(N,zeroloc+searchRangeHalf);
            [peaks,peaksindexes] = findpeaks(he(search_start:search_end));           
            if(~isempty(peaks))
                [peaks_k,k] = max(peaks); %ピークのうち最大のものとそのインデックス
                epochlocation = peaksindexes(k) + search_start -1; %i番目のゼロクロスに対するピークのフレーム内インデックス
                if epochlocation > (5+halfPitchPeriod) && ...
                        epochlocation < (N-4-halfPitchPeriod) && peaks_k > 0.0001
                    sidelobe = [he(epochlocation-5-halfPitchPeriod : epochlocation-5);...
                        he(epochlocation+5 : epochlocation+5+halfPitchPeriod)];                     
                    psrs(i) = peaks_k/(var(sidelobe));
            %             epochs(epochlocation) = peaks_j;%イラン
            %             sidelobe_var(epochlocation) = var(sidelobe); %イラン
                        frame = [he(epochlocation-halfPitchPeriod : epochlocation);...
                           he(epochlocation);he(epochlocation+5 : epochlocation+5+halfPitchPeriod)];
                        figure; plot(frame); title(num2str(j))%ピークとサイドローブがどうなってるかを確認
                end
            end
        end
    end
end