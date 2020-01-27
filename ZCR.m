function zcr = ZCR(sig, fr)
%窓幅をNとするフレーム内のZeroCrossingRateを求める
%しふとはばはshiftsize = 1[ms]とした
M = length(sig);
N = floor(1*fr/1000);
shiftsize = floor(1*fr/1000);

iter = floor( (M)/shiftsize );
zcr = zeros(iter,1);
for i=1:iter
    loc = (i-1)*shiftsize;
    x = sig(loc+1:loc+shiftsize );
    zcr(i) = sum(abs(diff(x>0)))/N; %diff(x>0)で0正のゼロ交差を1で表し負の0交差を-1で表す
end