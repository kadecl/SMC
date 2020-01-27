function zcr = ZCR(sig, fr)
%������N�Ƃ���t���[������ZeroCrossingRate�����߂�
%���ӂƂ͂΂�shiftsize = 1[ms]�Ƃ���
M = length(sig);
N = floor(1*fr/1000);
shiftsize = floor(1*fr/1000);

iter = floor( (M)/shiftsize );
zcr = zeros(iter,1);
for i=1:iter
    loc = (i-1)*shiftsize;
    x = sig(loc+1:loc+shiftsize );
    zcr(i) = sum(abs(diff(x>0)))/N; %diff(x>0)��0���̃[��������1�ŕ\������0������-1�ŕ\��
end