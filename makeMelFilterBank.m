function bBank = makeMelFilterBank(Fs, n , maxMelFilterNum, useMelFilterNum)
 %周波数スケール軸と、メルスケール軸を定義する
 freqScale = (1:10:Fs/2);  % 1Hzから10Hzおきに、ナイキスト周波数まで
 melScale = hz2mel(freqScale);

 %フィルタバンクの幅を求める
 % メルスケール上で等間隔、ただし半分は隣と重複しているので(分割数/2+0.5)で割る
 % 最後に足す0.5は右端の三角窓の右半分の長さ
 melWidth = max(melScale) / ( maxMelFilterNum / 2 + 0.5 );

 %バンドパスフィルタの幅を決める
 bandpassFreq = [];
 countFilterNum = 0;
 for count = min(melScale) : melWidth/2 : max(melScale)
     countFilterNum = countFilterNum + 1;
     if countFilterNum <= useMelFilterNum
         startMel = count;                 % このフィルタの開始メル値
         endMel = count + melWidth;        % このフィルタの終了メル値
         % ベクトルmelScaleの中で、startMelに最も近い値の番号を得る
         [startNum, ~] = getNearNum(melScale, startMel);
         % ベクトルmelScaleの中で、endMelに最も近い値の番号を得る
         [endNum, ~] = getNearNum(melScale, endMel);
         % 周波数スケールに変換
         bandpassFreq = [bandpassFreq ; freqScale(startNum) freqScale(endNum)];
     end
 end

 %各フィルタバンクのインパルス応答とゲイン特性を求める
 mBank = [];
 bBank = [];
%  hBank = [];
%  wBank = [];
 for count = 1 : 1 : length(bandpassFreq)
     % 三角窓のゲイン特性を作る
     startFreq = bandpassFreq(count,1);
     endFreq = bandpassFreq(count,2);
     % 10Hzおきに、長さ(endFreq - startFreq)Hzの三角窓を作る
     triWin = triang((endFreq - startFreq)/10)';
     % ゲインの値を初期化
     m = zeros(1,length(freqScale));
     % startFreqHzからendFreqHzの区間のゲインを triWin に置き換え
     m(ceil(startFreq/10):ceil(endFreq/10-1)) = triWin;
     mBank = [mBank ; m];

     % regularization
     f = freqScale - min(freqScale);    % 最小を0に
     f = f / max(f);                    % 最大を1に
     % インパルス応答
     b = fir2(n,f,m);
     bBank = [bBank ; b];
     % ゲイン特性を求める
%      [h,w] = freqz(b,1,512);
%      hBank = [hBank h];
%      wBank = [wBank w];
 end
 
end

function mel = hz2mel( f )
mel = 1127.01048 * log(f/700 + 1);
end

function hz = mel2hz( m )
hz = 700*(exp(m/1127.01048)-1);
end

function [minIndex, minData] = getNearNum( vec, target )
[minData, minIndex] = min(abs(vec - target));
end