function [spmu, d_spmu] = discWithEnv(x)

x = downsample(x,8);
[env, ~] = envelope(x, 500, 'rms');

fs = 1000;
M = length( env );
N = 1*fs; %1000Hzのうち1フレームにNのサンプルを入れる
T = floor(M/N);
frames = zeros(T,1);

for i=1:T
    in = (i-1)*N+1;
    out = min(i*N, M);
    frames(i) = mean( env( in:out ));
end

figure
subplot(4,1,1)
plot( (0:length(env)-1)/fs, env )
subplot(4,1,2)
plot( (0:length(frames)-1)/(fs/N), frames )
threshold = input('enter threshold: ');

spmu_org = threshold-frames >= 0;
spmu = zeros(M,1);
for t=1:T
    spmu( N*(t-1)+1 : N*t ) = spmu_org( t );
end
spmu(1) = 0; %0始まり、0おわりに統一
spmu(end) = 0;

subplot(4,1,3)
plot( (0:length(spmu)-1)/fs, spmu )

subplot(4,1,4)
d_spmu = conv(spmu, [1,-1], 'same');
plot( (0:length(spmu)-1)/fs, d_spmu);