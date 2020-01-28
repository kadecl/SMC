D0 = [];
D1 = [];

folder = 'oobeya';
directory = ['./deta/', folder];
musicdir = strcat( directory, '/music/');
speechdir = strcat( directory, '/speech/');
sufix = '*.wav';
numfeatures = 6;

filelist = dir( strcat(musicdir, sufix) );
w = waitbar(0,'loading...');
for filenum = 1:length(filelist)
    filename = strcat(musicdir,filelist(filenum).name); 
    tempD = calcFeatures(filename, 0, numfeatures);
    D0 = [D0; tempD];
    waitbar(filenum/length(filelist),w,'analysing music data');
end
close(w);

filelist = dir( strcat(speechdir, sufix) );
w = waitbar(0,'loading...');
for filenum = 1:length(filelist)
    filename = strcat(speechdir,filelist(filenum).name); 
    tempD = calcFeatures(filename, 1, numfeatures);
    D1 = [D1; tempD];
    waitbar(filenum/length(filelist),w,'Loading speech data');
end
close(w);
%D(:,2) = D(:,2) / max(D(:,2));
%D(:,3) = D(:,3) / max(D(:,3)); 
%D(:,2:numfeatures) = D(:,2:numfeatures) ./ max(D(:,2:numfeatures));
%save([directory,'/D_sec.mat'],'D');
%T = array2table(D,'VariableNames',{'spmu','psr','lme'});
%rng(1); % For reproducibility
%SVM = fitcsvm(T,'spmu');
% save([directory,'/libSVM.mat'],'SVM');
%CVsvm = crossval(SVM,'Holdout',0.15)

%libSVM = svmtrain(D(:,1), [(1:150)', D(2:3,:)], '-t 2');
%save([directory,'/libSVM.mat'],'libSVM');