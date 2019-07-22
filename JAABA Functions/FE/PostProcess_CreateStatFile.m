function PostProcess_CreateStatFile(genotype,feature,version,chorelocation,current_timestamp,timebins)
%%
%[genotype,feature,version,chorelocation,timestamps{i}]
%genotype=input(1);

scorefile=strcat('scores_',feature,'.mat');
gnlocation=cd(current_timestamp);
%% Read name for the genotype
[driver,effector,tracker,protocol,times]=read_name(genotype);
waiting=times.waiting;
circles=times.circles;
stimdur=times.stimdur;
stimint=times.stimint;
stimspec=stimdur+stimint;
genoInfo=[{driver},{effector},{tracker},{protocol},{current_timestamp}];
%% get fps
trx=load('trx');
fps=trx(1).trx.fps;
aninum=length(trx.trx);
%% process roll duration
    % 1. establish maximum roll duration
    % (less or equal to 4 non-roll duration is ignored)
    % 2. any short roll durations less or equal to 7 frames are ignored
allScores=load(scorefile);
    % finalProcessed: roll duration managed & fps2seconds completed
allScores.allScores.t0sProcessed=allScores.allScores.t0s;
allScores.allScores.t1sProcessed=allScores.allScores.t1s;
% 1.
for j=1:aninum
    if ~isempty(allScores.allScores.t0sProcessed{j})
        size=length(allScores.allScores.t0sProcessed{j});
        t0sModified={};
        t1sModified={};
        k=1;
        while k~=size
            gap=allScores.allScores.t0sProcessed{j}(k+1)-allScores.allScores.t1sProcessed{j}(k);
            if gap<=4  % GAP (modifiable)
                allScores.allScores.t1sProcessed{j}(k)=allScores.allScores.t1sProcessed{j}(k+1);
                for l=k:(size-2)
                    allScores.allScores.t1sProcessed{j}(l+1)=allScores.allScores.t1sProcessed{j}(l+2);
                    allScores.allScores.t0sProcessed{j}(l+1)=allScores.allScores.t0sProcessed{j}(l+2);
                end
                allScores.allScores.t1sProcessed{j}(size)=[];
                allScores.allScores.t0sProcessed{j}(size)=[];
                size=size-1;
            else
                k=k+1;
            end
        end
    end
end

% 2.
for j=1:aninum
    size=length(allScores.allScores.t0sProcessed{j});
    if ~isempty(allScores.allScores.t0sProcessed{j})
        k=1;
        while k<(size)
            duration=allScores.allScores.t1sProcessed{j}(k)-allScores.allScores.t0sProcessed{j}(k);
            if duration<=7  % DURATION (modifiable)
                allScores.allScores.t0sProcessed{j}(k)=allScores.allScores.t0sProcessed{j}(k+1);
                allScores.allScores.t1sProcessed{j}(k)=allScores.allScores.t1sProcessed{j}(k+1);
                for l=k:(size-2)
                    allScores.allScores.t1sProcessed{j}(l+1)=allScores.allScores.t1sProcessed{j}(l+2);
                    allScores.allScores.t0sProcessed{j}(l+1)=allScores.allScores.t0sProcessed{j}(l+2);
                end
                allScores.allScores.t1sProcessed{j}(size)=[];
                allScores.allScores.t0sProcessed{j}(size)=[];
                size=size-1;
            else
                k=k+1;
            end
            if k==size
                duration=allScores.allScores.t1sProcessed{j}(k)-allScores.allScores.t0sProcessed{j}(k);
                if duration<=7
                    allScores.allScores.t1sProcessed{j}(size)=[];
                    allScores.allScores.t0sProcessed{j}(size)=[];
                    size=size-1;
                end
            end
        end
    end
end
%% convert fps2seconds
allScores.allScores.t0sSeconds=allScores.allScores.t0sProcessed;
allScores.allScores.t1sSeconds=allScores.allScores.t1sProcessed;
allScores.allScores.tStartSeconds=allScores.allScores.tStart;
allScores.allScores.tEndSeconds=allScores.allScores.tEnd;
for j=1:aninum
    if ~isempty(allScores.allScores.t0sSeconds{j})
        size=length(allScores.allScores.t0sSeconds{j});
        for k=1:size
            allScores.allScores.t0sSeconds{j}(k)=allScores.allScores.t0sSeconds{j}(k)/fps;
            allScores.allScores.t1sSeconds{j}(k)=allScores.allScores.t1sSeconds{j}(k)/fps;
        end
    end
    allScores.allScores.tStartSeconds(j)=allScores.allScores.tStartSeconds(j)/fps;
    allScores.allScores.tEndSeconds(j)=allScores.allScores.tEndSeconds(j)/fps;
end
%% process roll duration (for graphing)
    % create 'totalProcessed' to have 0 and 1 of all larvae
    % totalProcessed(1:aninum,:) larvae info
allScores.allScores.timestamps=trx.timestamps;
framesnum=length(trx.timestamps);
allScores.allScores.totalProcessed=NaN(aninum, framesnum);
for j=1:aninum
    tStart=allScores.allScores.tStart(j);
    tEnd=allScores.allScores.tEnd(j);
    if tEnd>framesnum
        allScores.allScores.totalProcessed(j,tStart:framesnum)=0;
    else
        allScores.allScores.totalProcessed(j,tStart:tEnd)=0;
    end
    for k=1:length(allScores.allScores.t0sProcessed{j})
        t0s=allScores.allScores.t0sProcessed{j}(k);
        t1s=allScores.allScores.t1sProcessed{j}(k);
        allScores.allScores.totalProcessed(j,t0s:t1s)=1;
    end
end
save('scores_updated.mat','allScores')
%% Create ANIMAL_STAT files (individual larvae standard)
directory=fullfile(chorelocation,'result',current_timestamp);
cd(directory); % You are now at .../JAABA/Processed/chore/result/timestamp
crabspeed=load(strcat(current_timestamp,'@',genotype,'.crabspeed.dat'));

% change larvae index to 1,2,3,...,aninum
aniIndex=1;
for j=1:length(crabspeed)
    if j==length(crabspeed)
        crabspeed(j,2)=aniIndex;
    elseif (crabspeed(j,3)>crabspeed(j+1,3))
        crabspeed(j,2)=aniIndex;
        aniIndex=aniIndex+1;
    else
        crabspeed(j,2)=aniIndex;
    end
end

% create text files (animal_stats_rolls)
switch version
    case 1 %(time1,time2,tsize)
        CreateBinStatFile(allScores,crabspeed,genoInfo,aninum,timebins)
    case 2 %(start,end,rdur)
        CreateIndStatFile(allScores,crabspeed,genoInfo,aninum)
end
fprintf('STAT File Successfully Created: %s\n',current_timestamp);
end