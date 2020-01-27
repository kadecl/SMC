function zffs = ZPZDZFFS(sig, fr)
%% https://ieeexplore.ieee.org/document/8770068 �̎���
% sig�͗�x�N�g��
% N�̓t���[����
M = length(sig); %sig�̃T�C�Y���擾
N = floor(15 * fr / 1000); %�t���[������30ms
r = 0.98;

%% ��ݍ��݂𗘗p���������t�B���^
h = [1; -1];
x = conv(h, sig);
x = x(1:M); % �݂͂������i�K���j�����

%% resonator twice
y = real(ifft( fft(x).*transfar(M,r) ));

%% detrender cascade twice
h = ones(N,1) / N;
yy = y - conv(y, h, 'same');
zffs = yy - conv(yy, h, 'same');


%�͂���������������̂�
%�O�̂͂���1/4���Ă����i�悤�̓[���N���X�̈ʒu���킩��Ⴂ���j
zffs(1:1+N) = zffs(1:1+N)/16;
%����
zffs(M-N:M) = zffs(M-N:M)/16;
zffs = zffs / max(abs( zffs ));
end

function H = transfar(M, r)
dw = 2*pi/M;
w = 0:dw:2*pi-dw;
H = 1./((1-2*r*cos(w)+r^2).^2);
H = transpose(H);
end