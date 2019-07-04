function PrepareMWTJAABAData_shua
%% SET MANAULLY
chorelocation='C:\Users\Ohyama_Dell\Documents\JAABA\Processed\choreography_data\basin4xUAS_chrimson';
savelocation='C:\Users\Ohyama_Dell\Documents\JAABA\Processed\basin4xUAS_chrimson';
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

    %%
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
    fprintf('trx.mat successfully created: %s\n',timestamps{i})
end
cd(perframe)
end