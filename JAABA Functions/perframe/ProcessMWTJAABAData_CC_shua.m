function ProcessMWTJAABAData_CC_shua(genotype,feature,version,timebins)
%% SET MANAULLY
    % genotype='attp2@UAS_Chrimson_attp18_72F11_fed@t93@r_LED05_45s2x30s30s#n#n#n@100';
    % feature='roll';
    % version=2;
% version of feature_extraction file
% (.crabspeed_area-animal_stats_rolls.txt)
% 1:(time_stamp,animal,time1,time2,rampl,rdur,rpos,rbeg,tsize)
% 2:(time_stamp,animal,start,end,rampl,rdur,rpos)

% timebins=[0,15;15,30;30,45;45,60;60,75;75,90;90,105;105,120;120,135;135,150;150,165]; 
    % column 1: start time
    % column 2: end time
    % length(timebins)=#rows
    % size(timebins)(1)=#rows, (2)=#columns
%%
addpath(genpath('/scratch/shua/JAABA/JAABA-master/perframe'));
addpath(genpath('/scratch/shua/JAABA/JAABA-master/misc'));
addpath(genpath('/scratch/shua/JAABA/JAABA-master/spaceTime'));
addpath(genpath('/scratch/shua/JAABA/JAABA-master/figurecode'));
addpath(genpath('/scratch/shua/JAABA/JAABA-master/filehandling'));
addpath(genpath('/scratch/shua/JAABA/JAABA-master/FE'));
%%
cd /scratch/shua/JAABA/Processed
if ~exist(genotype,'dir')
    mkdir(genotype)
end
chorelocation=fullfile('/scratch/shua/JAABA/Processed/chore',genotype);
savelocation=fullfile('/scratch/shua/JAABA/Processed',genotype);
classifier='/scratch/shua/JAABA/Classifiers/roll.jab';
%% count how many timestamps
temp=dir(fullfile(chorelocation,'input'));
timestamps=cell(1,length(temp)-2);
for i=3:length(temp) 
    timestamps(i-2)=cellstr(temp(i).name);
end
clear temp
perframe=cd(savelocation);
%% loop goes over every timestamp in one genotype
for i=1:length(timestamps)
    blobslocation=fullfile(chorelocation,'input',timestamps{i});
    datlocation=fullfile(chorelocation,'result',timestamps{i});
    if ~exist(timestamps{i},'dir')
        mkdir(timestamps{i})
    end
    expdir=fullfile(savelocation,timestamps{i});
    %% blobs list
    blobslisting=dir(blobslocation);
    index=1;
    blobs={};
    for j=1:length(blobslisting)
        if strfind(blobslisting(j).name,'blobs')
            blobs(index)=cellstr(fullfile(blobslocation,blobslisting(j).name));
            index=index+1;
        end
    end
    %% dat list
    datlisting=dir(datlocation);
    index=1;
    dat={};
    for j=1:length(datlisting)
        if strfind(datlisting(j).name,'dat')
            dat(index)=cellstr(fullfile(datlocation,datlisting(j).name));
            index=index+1;
        end
    end
    ConvertMWT2JAABA_shua(...
        'inmoviefile','',...
        'blobsfile',{blobs},...
        'spinefile','',...
        'datfiles',{dat},...
        'expdir',expdir,...
        'moviefilestr','movie.ufmf',...
        'trxfilestr','trx.mat',...
        'perframedirstr','perframe',...
        'overridearena',0,...
        'dosoftlink',1,...
        'pxpermm',11.3636,...
        'arenatype','None',...
        'arenacenterx',0,...
        'arenacentery',0,...
        'arenaradius',123,...
        'arenawidth',123,...
        'arenaheight',123);
    % You are at savelocation (.../Processed/genotype)
    JAABADetect(fullfile(savelocation,timestamps{i}),'jabfiles',classifier);
    fprintf('DATA Successfully Processed: %s\n',timestamps{i});
    PostProcess_CreateStatFile_CC(genotype,feature,version,chorelocation,timestamps{i},timebins);
    cd(savelocation)
end
disp('All successfully processed!')
cd(perframe)

myCluster = parcluster('local');
delete(myCluster.Jobs)

end