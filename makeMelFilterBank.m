function bBank = makeMelFilterBank(Fs, n , maxMelFilterNum, useMelFilterNum)
 %���g���X�P�[�����ƁA�����X�P�[�������`����
 freqScale = (1:10:Fs/2);  % 1Hz����10Hz�����ɁA�i�C�L�X�g���g���܂�
 melScale = hz2mel(freqScale);

 %�t�B���^�o���N�̕������߂�
 % �����X�P�[����œ��Ԋu�A�����������ׂ͗Əd�����Ă���̂�(������/2+0.5)�Ŋ���
 % �Ō�ɑ���0.5�͉E�[�̎O�p���̉E�����̒���
 melWidth = max(melScale) / ( maxMelFilterNum / 2 + 0.5 );

 %�o���h�p�X�t�B���^�̕������߂�
 bandpassFreq = [];
 countFilterNum = 0;
 for count = min(melScale) : melWidth/2 : max(melScale)
     countFilterNum = countFilterNum + 1;
     if countFilterNum <= useMelFilterNum
         startMel = count;                 % ���̃t�B���^�̊J�n�����l
         endMel = count + melWidth;        % ���̃t�B���^�̏I�������l
         % �x�N�g��melScale�̒��ŁAstartMel�ɍł��߂��l�̔ԍ��𓾂�
         [startNum, ~] = getNearNum(melScale, startMel);
         % �x�N�g��melScale�̒��ŁAendMel�ɍł��߂��l�̔ԍ��𓾂�
         [endNum, ~] = getNearNum(melScale, endMel);
         % ���g���X�P�[���ɕϊ�
         bandpassFreq = [bandpassFreq ; freqScale(startNum) freqScale(endNum)];
     end
 end

 %�e�t�B���^�o���N�̃C���p���X�����ƃQ�C�����������߂�
 mBank = [];
 bBank = [];
%  hBank = [];
%  wBank = [];
 for count = 1 : 1 : length(bandpassFreq)
     % �O�p���̃Q�C�����������
     startFreq = bandpassFreq(count,1);
     endFreq = bandpassFreq(count,2);
     % 10Hz�����ɁA����(endFreq - startFreq)Hz�̎O�p�������
     triWin = triang((endFreq - startFreq)/10)';
     % �Q�C���̒l��������
     m = zeros(1,length(freqScale));
     % startFreqHz����endFreqHz�̋�Ԃ̃Q�C���� triWin �ɒu������
     m(ceil(startFreq/10):ceil(endFreq/10-1)) = triWin;
     mBank = [mBank ; m];

     % regularization
     f = freqScale - min(freqScale);    % �ŏ���0��
     f = f / max(f);                    % �ő��1��
     % �C���p���X����
     b = fir2(n,f,m);
     bBank = [bBank ; b];
     % �Q�C�����������߂�
%      [h,w] = freqz(b,1,512);
%      hBank = [hBank h];
%      wBank = [wBank w];
 end
 
end

function mel = hz2mel( f )
mel = 1127.01048 * log(f/700 + 1);
end

function hz = mel2hz( m )
hz = 700*(exp(m/1127.01048)-1);
end

function [minIndex, minData] = getNearNum( vec, target )
[minData, minIndex] = min(abs(vec - target));
end