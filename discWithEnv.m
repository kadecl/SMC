function [spmu, d_spmu] = discWithEnv(x)

x = downsample(x,8);
[env, ~] = envelope(x, 500, 'rms');

fs = 1000;
M = length( env );
N = 1*fs; %1000Hz�̂���1�t���[����N�̃T���v��������
T = floor(M/N);
frames = zeros(T,1);

for i=1:T
    in = (i-1)*N+1;
    out = min(i*N, M);
    frames(i) = mean( env( in:out ));
end

figure
subplot(3,1,1)
plot( frames )
threshold = input('enter threshold: ');

spmu = threshold-frames >= 0;
spmu(1) = 0; %0�n�܂�A0�����ɓ���
spmu(end) = 0;

subplot(3,1,2)
plot( spmu )

subplot(3,1,3)
d_spmu = conv(spmu, [1,-1], 'same');
plot( d_spmu);