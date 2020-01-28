D = [];

folder = 'oobeya';
directory = ['./deta/', folder];
musicdir = strcat( directory, '/music/');
speechdir = strcat( directory, '/speech/');
sufix = '*.wav';
numfeatures = 5;

filelist = dir( strcat(musicdir, sufix) );
w = waitbar(0,'loading...');
for filenum = 1:length(filelist)
    filename = strcat(musicdir,filelist(filenum).name); 
    tempD = calcFeatures(filename, 0, numfeatures);
    D = [D; tempD];
    waitbar(filenum/length(filelist),w,'analysing music data');
end
close(w);

filelist = dir( strcat(speechdir, sufix) );
w = waitbar(0,'loading...');
for filenum = 1:length(filelist)
    filename = strcat(speechdir,filelist(filenum).name); 
    tempD = calcFeatures(filename, 1, numfeatures);
    D = [D; tempD];
    waitbar(filenum/length(filelist),w,'Loading speech data');
end
close(w);

D(:,2:numfeatures) = D(:,2:numfeatures) ./ max(D(:,2:numfeatures));
save([directory,'/D_sec_exist_norm.mat'],'D');
T = array2table(D(:,1:6),'VariableNames',{'spmu','psr','lme','centroid','flux','roll off'});
%rng(1); % For reproducibility
SVM = fitcsvm(T,'spmu');
save([directory,'/SVM_exit_norm.mat'],'SVM');
%CVsvm = crossval(SVM,'Holdout',0.15)

%libSVM = svmtrain(D(:,1), [(1:150)', D(2:3,:)], '-t 2');
%save([directory,'/libSVM.mat'],'libSVM');