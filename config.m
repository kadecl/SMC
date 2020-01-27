%ロード
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
sample = downsample(sample, Ratio);
fr = newfr;

%% 正規化
%sample = sample/max(abs(sample));

%% スペクトログラム
% figure
% spectrogram(sample,128,120,128,fr,'yaxis');