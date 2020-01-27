function lme = logMelEnergy2(sig, fr)
% ���͐M�����Ńp���[�̂΂��������Ƃ��̉e�����󂯂Ă��܂�����
% �t���[�����Ƃɐ��K�����s�����ǂ��s�����B
% ����ɂ����͐M���̃p���[���ɉe�����󂯂�
% �t���[�����̐M���̃p���[���ǂꂾ�����ɏW�����Ă��邩��
% ���y�����Ɖ��������Ŕ�r�\
% �܂��A�g�p����t�B���^�̐���8�ɍi�邱�ƂŒ��̃p���[�݂̂����o��

numUseFilt = 18;
MelFilterBank = makeMelFilterBank(fr, 150, 22, numUseFilt); 
%�t�B���^�o���N�쐬. �����t�B���^�o���N�̍\����������
M = length(sig);
N = floor(30*fr/1000);
shiftsize = floor(1*fr/1000);
iter = floor( (M - N)/shiftsize) +1;
lme = zeros(iter,1);
filteredSig = zeros(M,numUseFilt);
for i=1:numUseFilt
    filteredSig(:, i) = conv( sig, MelFilterBank(i,:), 'same');
end
%�����܂�OK

%�t���[�����Ƃ�lme���Z�o
for i=1:iter
    init = (i-1) * shiftsize;
    subsig = filteredSig( init+1:init+N , :);
    lme(i) = melFilteredLogMelEnergy(subsig);
end
lme = movvar(lme, 1000);
lme = [lme; lme(end)*ones(29,1)];

% regularization
% lme = ( lme - min(lme) );
% lme = lme / max(lme);
end

function ret = melFilteredLogMelEnergy(filteredSig)
    S2 = abs( fft(filteredSig) ).^2;
    logSumS = log( max(sum(S2, 1), eps) ); 
    %���S�Ȗ�����Ԃ������-inf�ɂȂ��Ă��܂����K�����ɖ�肪����
    ret = sum( logSumS );
end