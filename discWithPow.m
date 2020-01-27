function [spmu, d_spmu] = discWithPow(x)
% sampleは8000Hz

fs = 1000;
Rate = 8000/fs;
x = downsample( x, Rate ); %500Hz以下のエネルギーでも十分
M = length( x );
N = 5*fs; %1000Hzのうち1フレームにNのサンプルを入れる
T = floor(M/N);
pow = zeros(T,1);

for i = 1:T
 pow(i) = mean( x( (i-1)*N+1:i*N ).^2 );
end

figure
subplot(4,1,1)
plot( (0:length(x)-1)/fs, x )
subplot(4,1,2)
plot( (0:T-1)/(fs/N), pow )
threshold = input('enter threshold: ');

spmu_org = smooth(threshold-pow, 3) >= 0;
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
