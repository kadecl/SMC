function ret = emphasing(sig, fr, spmu, ratio)

%figure
%plot((0:length(sig)-1)/fr, mag2db(abs(sig)))
%threshold = input("enter threshold(dB): ");
%close
threshold = -35;

dRC = compressor(threshold, 20);
N = length(sig);

diff_spmu = conv([0; spmu], [1,-1], 'same');%0初めに統一してから微分
diff_spmu = diff_spmu(1:end-1);
index_inc = find(diff_spmu == 1);%何秒めにスタートがあるか
index_dec = find(diff_spmu == -1);

num_segment = length(index_inc);
for i=1:num_segment
    start = max(1, floor((index_inc(i)-1)*ratio*fr+1));
    finish = min( N, floor((index_dec(i))*ratio*fr ) );
    sig( start:finish ) = dRC(sig( start:finish ));
    sig( start:finish ) = sig( start:finish )/max(abs(sig( start:finish )));
end
ret = sig;