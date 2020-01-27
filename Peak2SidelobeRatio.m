function psr = Peak2SidelobeRatio(he, zffs, fr, threshold)
M = length(he);
ZeroCrossLoc = zci(zffs);
searchRangeHalf = 3*fr/(1000*2); %ゼロ交差からepochを探すときの範囲の半分
halfPitchPeriod = floor(0.005*fr/2); %片側サイドローブのサンプル数

%finding peaks
peak_sidelobe = zeros(M,1);
% epochs = zeros(M,1); %イラン
% sidelobe_var = zeros(M,1); %イラン

%各ゼロ交差位置に対してpeak to sidelobe ratioを求めておく
for i=1:length(ZeroCrossLoc)
    loc = ZeroCrossLoc(i);
    init = max(1,loc-searchRangeHalf);
    fini = min(M,loc+searchRangeHalf);
    [peaks,peakindexes] = findpeaks(he(init:fini));
    if(~isempty(peaks))
        [peaks_j,j] = max(peaks); %ピークのうち最大のものとそのインデックス
        epochlocation = peakindexes(j) + init -1;
        if peaks_j < threshold %無音区間での0割を防ぐ
            peak_sidelobe(epochlocation) = 0;
%             epochs(epochlocation) = 0; %イラン
%             sidelobe_var(epochlocation) = 0; %イラン
        elseif epochlocation >= (5+halfPitchPeriod) && epochlocation < (M-4-halfPitchPeriod)
            sidelobe = [he(epochlocation-5-halfPitchPeriod : epochlocation-5);...
                he(epochlocation+5 : epochlocation+5+halfPitchPeriod)];       
            peak_sidelobe(epochlocation) = peaks_j/(var(sidelobe));
%             epochs(epochlocation) = peaks_j;%イラン
%             sidelobe_var(epochlocation) = var(sidelobe); %イラン
%             frame = [he(epochlocation-5-halfPitchPeriod : epochlocation-5);...
%                he(epochlocation);he(epochlocation+5 : epochlocation+5+halfPitchPeriod)];
%             figure; plot(frame); %ピークとサイドローブがどうなってるかを確認
        end
    end
end
%各フレーム内に入ってるheのpsrの平均をとる
N = floor(30*fr/1000);
shiftsize = floor(1*fr/1000);
iter = floor((M-N)/shiftsize);
psr = zeros(iter,1);
for i=1:iter
    frame = peak_sidelobe(shiftsize*(i-1)+1:shiftsize*(i-1)+N);
    psr(i) = mean(frame);
end
%psr = psr / max(psr);

% figure
% subplot(3,1,1)
% plot( (0:length(he)-1)/fr, he);
% hold on
% plot( (0:length(zffs)-1)/fr, zffs);
% xlabel('time(s)')
% subplot(3,1,2)
% plot( (0:length(epochs)-1)/fr, epochs)
% hold on
% plot( (0:length(sidelobe_var)-1)/fr, sidelobe_var)
% subplot(3,1,3)
% plot( (0:length(psr)-1)/1000, psr)