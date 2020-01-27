%ロード
filename = './deta/oobeya/unknown/20190929_spmu3.wav';
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

%音量で区別
[spmu, d_spmu_vol] = discWithEnv(sample);
index_inc = find(d_spmu_vol == 1);
index_dec = find(d_spmu_vol == -1);

%特徴量による区別
num_segment = length(index_inc);
for i=1:num_segment
    s = sample( (index_inc(i)-1)*8+1 : index_dec(i)*8 );
    label = predictspmu( s, fr, SVM );
    spmu(index_inc(i):index_dec(i)) = label;
end

figure
subplot(2,1,1)
plot(sample)
subplot(2,1,2)
plot(spmu)

%音声区間について正規化、コンプがけ
    