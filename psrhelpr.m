function psr = psrhelpr(sig, zffs, fr, threshold)
M = length(sig);
N = 30*fr/1000;
shiftsize = 1*fr/1000;
iter = floor((M-N)/shiftsize) +1;
psr = zeros(iter,1);

searchRangeHalf = 3*fr/(1000*2); %�[����������epoch��T���Ƃ��͈̔͂̔���
halfPitchPeriod = floor(0.005*fr/2); %�Б��T�C�h���[�u�̃T���v����

for j = 1:iter
    loc = (j-1)*shiftsize;
    x = sig(loc+1: loc+N);
    e = filter( lpc(x, 10), 1, x );
    he = abs( hilbert(e));
    ZeroCrossLoc = zci(zffs(loc+1:loc+N));
    
    num_zc = length(ZeroCrossLoc);
    psrs = zeros(num_zc,1);
    if num_zc ~= 0
        for i=1:num_zc
            zeroloc = ZeroCrossLoc(i); %i�Ԗڂ̃[���N���X
            search_start = max(1,zeroloc-searchRangeHalf);
            search_end = min(N,zeroloc+searchRangeHalf);
            [peaks,peaksindexes] = findpeaks(he(search_start:search_end));

            
            if(~isempty(peaks))
                [peaks_k,k] = max(peaks); %�s�[�N�̂����ő�̂��̂Ƃ��̃C���f�b�N�X
                epochlocation = peaksindexes(k) + search_start -1; %i�Ԗڂ̃[���N���X�ɑ΂���s�[�N�̃t���[�����C���f�b�N�X
                if epochlocation > (5+halfPitchPeriod) && ...
                        epochlocation < (N-4-halfPitchPeriod) && peaks_k > threshold
                    sidelobe = [he(epochlocation-5-halfPitchPeriod : epochlocation-5);...
                        he(epochlocation+5 : epochlocation+5+halfPitchPeriod)];                     
                    psrs(i) = peaks_k/(var(sidelobe));
            %             epochs(epochlocation) = peaks_j;%�C����
            %             sidelobe_var(epochlocation) = var(sidelobe); %�C����
            %             frame = [he(epochlocation-5-halfPitchPeriod : epochlocation-5);...
            %                he(epochlocation);he(epochlocation+5 : epochlocation+5+halfPitchPeriod)];
            %             figure; plot(frame); %�s�[�N�ƃT�C�h���[�u���ǂ��Ȃ��Ă邩���m�F
                end
            end
        end
        psr(j) = mean(psrs);
    end
end 
psr = [psr;psr(end)*ones(29,1)];
psr = smooth(psr,floor(1000*1));
end