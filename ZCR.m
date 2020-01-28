function zcr = ZCR(sig, fr)
%窓幅をNとするフレーム内のZeroCrossingRateを求める
%しふとはばはshiftsize = 1[ms]とした
M = length(sig);
N = floor(1*fr);
%shiftsize = floor(1*fr/1000);
T = floor(M/N);
zcr = zeros(T,1);
for t=1:T
    x = sig( (t-1)*N+1:t*N );
    zcr(t) = var( diff(x>0) ); %diff(x>0)で0正のゼロ交差を1で表し負の0交差を-1で表す
end