function zffs = ZPZDZFFS(sig, fr)
%% https://ieeexplore.ieee.org/document/8770068 の実装
% sigは列ベクトル
% Nはフレーム幅
M = length(sig); %sigのサイズを取得
N = floor(15 * fr / 1000); %フレーム幅は30ms
r = 0.98;

%% 畳み込みを利用した微分フィルタ
h = [1; -1];
x = conv(h, sig);
x = x(1:M); % はみだす分（尻尾）を削る

%% resonator twice
y = real(ifft( fft(x).*transfar(M,r) ));

%% detrender cascade twice
h = ones(N,1) / N;
yy = y - conv(y, h, 'same');
zffs = yy - conv(yy, h, 'same');


%はじっこが悪さするので
%前のはじを1/4しておく（ようはゼロクロスの位置がわかりゃいい）
zffs(1:1+N) = zffs(1:1+N)/16;
%後ろも
zffs(M-N:M) = zffs(M-N:M)/16;
zffs = zffs / max(abs( zffs ));
end

function H = transfar(M, r)
dw = 2*pi/M;
w = 0:dw:2*pi-dw;
H = 1./((1-2*r*cos(w)+r^2).^2);
H = transpose(H);
end