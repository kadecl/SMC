%ロード
%filename = './deta/oobeya/unknown/20190929_spmu3.wav';
filename = './dataset/speech_music2.m4a';
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
downsampledSig = downsample(sample, Ratio);
Fs = fr; %元の周波数
fr = newfr;

%音量で区別
[spmu, d_spmu_vol] = discWithEnv(downsampledSig, fr);
index_inc = find(d_spmu_vol == 1);%何秒めにスタートがあるか
index_dec = find(d_spmu_vol == -1);

%特徴量による区別
num_segment = length(index_inc);
for i=1:num_segment
    s = downsampledSig( (index_inc(i)-1)*fr+1 : index_dec(i)*fr );
    %label = predictspmu( s, fr, SVM );
    label = nonLinearMapping(s,fr);
    spmu(index_inc(i):index_dec(i)) = label;
end

%% emphasing
% r_Fsfr = (Ratio*fr)/Fs;
% sample = sample / max(abs(sample));
% ret = emphasing(sample, Fs, spmu, r_Fsfr);
% figure
% subplot(3,1,1)
% plot( (0:length(sample)-1)/Fs, sample)
% title('original signal')
% subplot(3,1,2)
% plot((0:length(spmu)-1)*r_Fsfr, spmu)
% title('result of speech / music classification')
% subplot(3,1,3)
% plot( (0:length(ret)-1)/Fs, ret)
% title('emphasized signal')
    