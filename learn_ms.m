TrainDeta = [];

folder = 'oobeya';
directory = ['./deta/', folder];
musicdir = strcat( directory, '/music/');
speechdir = strcat( directory, '/speech/');
sufix = '*.wav';

filelist = dir( strcat(musicdir, sufix) );
w = waitbar(0,'loading...');
for filenum = 1:length(filelist)
    filename = strcat(musicdir,filelist(filenum).name); 
    tempD = calcFeatures(filename, 0);
    TrainDeta = [TrainDeta; tempD];
    waitbar(filenum/length(filelist),w,'analysing music data');
end
close(w);

filelist = dir( strcat(speechdir, sufix) );
w = waitbar(0,'loading...');
for filenum = 1:length(filelist)
    filename = strcat(speechdir,filelist(filenum).name); 
    tempD = calcFeatures(filename, 1);
    TrainDeta = [TrainDeta; tempD];
    waitbar(filenum/length(filelist),w,'Loading speech data');
end
close(w);

numfeatures = 3;
TrainDeta(:,2:numfeatures+1) = TrainDeta(:,2:numfeatures+1) ./ max(TrainDeta(:,2:numfeatures+1));
save([directory,'/D_3_norm.mat'],'TrainDeta');
rng(1); % For reproducibility

TrainTable = array2table(TrainDeta(:,1:numfeatures+1),'VariableNames',...
   {'spmu','psr','lme','roll off'});
SVM = fitcsvm(TrainTable,'spmu','KernelFunction','rbf');
save([directory,'/SVM_3_norm.mat'],'SVM');
%CVsvm = crossval(SVM,'Holdout',0.15)

%libSVM = svmtrain(D(:,1), [(1:150)', D(2:3,:)], '-t 2');
%save([directory,'/libSVM.mat'],'libSVM');