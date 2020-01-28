function zcr = ZCR(sig, fr)
%������N�Ƃ���t���[������ZeroCrossingRate�����߂�
%���ӂƂ͂΂�shiftsize = 1[ms]�Ƃ���
M = length(sig);
N = floor(1*fr);
%shiftsize = floor(1*fr/1000);
T = floor(M/N);
zcr = zeros(T,1);
for t=1:T
    x = sig( (t-1)*N+1:t*N );
    zcr(t) = var( diff(x>0) ); %diff(x>0)��0���̃[��������1�ŕ\������0������-1�ŕ\��
end