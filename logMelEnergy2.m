function lme = logMelEnergy2(sig, fr)
% 入力信号内でパワーのばらつきがあるとその影響を受けてしまうため
% フレームごとに正規化を行う改良を行った。
% これにより入力信号のパワー差に影響を受けず
% フレーム内の信号のパワーがどれだけ低域に集中しているかを
% 音楽部分と音声部分で比較可能
% また、使用するフィルタの数を8に絞ることで低域のパワーのみを取り出す

numUseFilt = 18;
MelFilterBank = makeMelFilterBank(fr, 150, 22, numUseFilt); 
%フィルタバンク作成. メルフィルタバンクの構成を見直す
M = length(sig);
N = floor(30*fr/1000);
shiftsize = floor(1*fr/1000);
iter = floor( (M - N)/shiftsize) +1;
lme = zeros(iter,1);
filteredSig = zeros(M,numUseFilt);
for i=1:numUseFilt
    filteredSig(:, i) = conv( sig, MelFilterBank(i,:), 'same');
end
%ここまでOK

%フレームごとにlmeを算出
for i=1:iter
    init = (i-1) * shiftsize;
    subsig = filteredSig( init+1:init+N , :);
    lme(i) = melFilteredLogMelEnergy(subsig);
end
lme = movvar(lme, 1000);
lme = [lme; lme(end)*ones(29,1)];

% regularization
% lme = ( lme - min(lme) );
% lme = lme / max(lme);
end

function ret = melFilteredLogMelEnergy(filteredSig)
    S2 = abs( fft(filteredSig) ).^2;
    logSumS = log( max(sum(S2, 1), eps) ); 
    %完全な無音区間があると-infになってしまい正規化時に問題がある
    ret = sum( logSumS );
end