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
    tempD = calcFeatures(filename, 1);
    D1 = [D1; tempD];
    waitbar(filenum/length(filelist),w,'Loading speech data');
end
close(w);

D0(:,2:end) = D0(:,2:end) ./ max(D0(:,2:end));
D1(:,2:end) = D1(:,2:end) ./ max(D1(:,2:end));
stry = ["Y", "PSR of HE of LPR (mean)", "Log Mel Energy (variance)",...
      "Spectral Rolloff Point (variance)", "Spectral Centroid (variance)",...
      "spectral flux", "zcr"];
figure
for i = 1:6
subplot(6,1,i)
h0 = histogram(D0(:,i+1));
h0.Normalization = 'probability';
h0.BinWidth = 0.02;
hold on
h1 = histogram(D1(:,i+1));
h1.Normalization = 'probability';
h1.BinWidth = 0.02;
title(stry(i+1))
end

% figure
% i=1; subplot(3,1,i)
% h0 = histogram(D0(:,i+1));
% h0.Normalization = 'probability';
% h0.BinWidth = 0.02;
% hold on
% h1 = histogram(D1(:,i+1));
% h1.Normalization = 'probability';
% h1.BinWidth = 0.02;
% title(stry(i+1)); legend('music','speech')
% i=2; subplot(3,1,i)
% h0 = histogram(D0(:,i+1));
% h0.Normalization = 'probability';
% h0.BinWidth = 0.02;
% hold on
% h1 = histogram(D1(:,i+1));
% h1.Normalization = 'probability';
% h1.BinWidth = 0.02;
% title(stry(i+1));
% i=3; subplot(3,1,i)
% h0 = histogram(D0(:,i+2));
% h0.Normalization = 'probability';
% h0.BinWidth = 0.02;
% hold on
% h1 = histogram(D1(:,i+2));
% h1.Normalization = 'probability';
% h1.BinWidth = 0.02;
% title(stry(i+1));