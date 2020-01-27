filename = './music_speech/speech_wav_heap/charles.wav';
%filename = './dataset/a_long.m4a';
[sig, fr] = audioread( filename );

[r,c] = size(sig);
if(r<c)
    sig = transpose(sig);
end
[r,c] = size(sig);
if(c>1)
    sig = mean(sig,2);
end

%downsample
newfr = 8000;
Ratio = floor(fr / newfr);
sig = downsample(sig, Ratio);
fr = newfr;

M = length(sig);
N = 30*fr/1000;
shiftsize = 30*fr/1000;
iter = floor((M-N)/shiftsize);
zffs = ZPZDZFFS(sig,fr);

st = floor( M*26/30 );
en = floor( M*28/30 );
sample = sig(st:en);
zffs = zffs(st:en);

searchRangeHalf = 2*fr/(1000); %�[����������epoch��T���Ƃ��͈̔͂̔���
halfPitchPeriod = floor(0.005*fr/2); %�Б��T�C�h���[�u�̃T���v����
for j = 1:6
    loc = (j-1)*shiftsize;
    x = sample(loc+1: loc+N);
    e = filter( lpc(x, 10), 1, x );
    he = abs( hilbert(e));
%     
%     figure
%     subplot(2,1,1)
%     plot(x)
%     subplot(2,1,2)
%     plot(he);
%     hold on
%     plot(zffs(loc+1:loc+N))
%     ylim([0 0.2])

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
                        epochlocation < (N-4-halfPitchPeriod) && peaks_k > 0.0001
                    sidelobe = [he(epochlocation-5-halfPitchPeriod : epochlocation-5);...
                        he(epochlocation+5 : epochlocation+5+halfPitchPeriod)];                     
                    psrs(i) = peaks_k/(var(sidelobe));
            %             epochs(epochlocation) = peaks_j;%�C����
            %             sidelobe_var(epochlocation) = var(sidelobe); %�C����
                        frame = [he(epochlocation-halfPitchPeriod : epochlocation);...
                           he(epochlocation);he(epochlocation+5 : epochlocation+5+halfPitchPeriod)];
                        figure; plot(frame); title(num2str(j))%�s�[�N�ƃT�C�h���[�u���ǂ��Ȃ��Ă邩���m�F
                end
            end
        end
    end
end