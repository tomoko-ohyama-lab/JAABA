function FeatureExtraction_JAABA_CC(genotype)
%% SET MANAULLY
%genotype='SS00740_GAL4@UAS_Chrimson@t94@r_LED10_45s2x30s30s#n#n#n@100';
feature='roll';
bins = [30,45,60,75,90,105,120,135,150,165];
pool={}; % pool=raw pool stat data
%%
[driver,effector,tracker,protocol,times]=read_name(genotype);
addpath('/scratch/shua/JAABA/JAABA-master/FE')
%% count how many timestamps
genotype_location=fullfile('/scratch/shua/JAABA/Processed',genotype);
FE=cd(genotype_location);
temp=dir(pwd);
timestamps=cell(1,length(temp)-2);
for i=3:length(temp) 
    timestamps(i-2)=cellstr(temp(i).name);
end
clear temp
%% Make directories needed to save files
dir_FEstructureJAABA_CC(driver,effector,tracker,protocol,timestamps)
FEname=strcat(driver,'@',effector,'@',tracker,'@',protocol,'@100.crabspeed_area-animal_stats_rolls_JAABA.txt');
%% Loop goes over every timestamp in one genotype
for i=1:length(timestamps)
    output=[]; % output=raw FE data
    timestamp=timestamps{i};
    cd(timestamp)
    allScores=load('scores_updated.mat');
    aninum=length(allScores.allScores.allScores.tStart);
    crabspeed=allScores.allScores.allScores.crabspeed;
    frames=[];
    ind=[];
    %% loop goes over every animal in one timestamp
    for j=1:aninum
        track_start=allScores.allScores.allScores.tStartSeconds(j);%double
        track_stop=allScores.allScores.allScores.tEndSeconds(j);%double
        beh_start=allScores.allScores.allScores.t0sSeconds(j);%1x1cell
        beh_stop=allScores.allScores.allScores.t1sSeconds(j);%1x1cell
        [frames,overlap]=getFrames(bins,track_start,track_stop,beh_start,beh_stop);
        if all(frames(:) == 0)
            % do nothing
        else
            % select crabspeed
            temp=(crabspeed(:,2)==j);
            if all(temp==0)
            else
                index=find(temp);
                selectedCrabspeed=crabspeed(min(index):max(index),3:4);
                clear temp
                clear index
                % fill in
                row=size(frames);
                frames(1:row(1),2:3)=frames(1:row(1),1:2); %column2,3=time1,time2
                frames(1:row(1),1)=j; %column1=animal
                clear row
                frames=fillFrames_test(frames,overlap,selectedCrabspeed,track_start,track_stop,beh_start,beh_stop,bins);
                output=vertcat(output,frames);
            end
        end
    end
    %% Convert each row to string
    strarray=[];
    for j=1:length(output)
        strarray{j}=sprintf('\t%5.0i\t%3.2f\t%3.2f\t%2.3f\t%2.3f\t%3.3f\t%3.3f\t%2.3f',output(j,1:end));
        strarray{j}=strcat(timestamp,strarray{j});
    end
    %% Save the stat.txt
    filename=strcat('/scratch/shua/feature_extraction/',tracker,'/',driver,'@',effector,'/',protocol,'@100/',timestamp,'\',FEname);
    fileID=fopen(filename,'w');
    fprintf(fileID,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n','time_stamp','animal','time1','time2','rampl','rdur','rpos','rbeg','tsize');
    for j=1:length(strarray)
        fprintf(fileID,'%s\r\n',strarray{j});
    end
    fclose(fileID);
    clear temp
    %% make pool file
    temp={};
    row=size(output);
    temp(1:row(1),1)={timestamps{i}};
    temp(:,2:9)=num2cell(output(:,1:8));
    pool=vertcat(pool,temp);
    clear temp
    %%
    fprintf('FE_JAABA Successfully Produced: %s\n',timestamps{i});
    cd(genotype_location);
end
%% POOL: Convert each row to string
strarray=[];
for j=1:length(pool)
    timestamp=pool{j,1};
    strarray{j}=sprintf('\t%5.0i\t%3.2f\t%3.2f\t%2.3f\t%2.3f\t%3.3f\t%3.3f\t%2.3f',pool{j,2:end});
    strarray{j}=strcat(timestamp,strarray{j});
end
%% Save pool file
filename=strcat('/scratch/shua/feature_extraction/',tracker,'/',driver,'@',effector,'/',protocol,'@100/',FEname);
fileID=fopen(filename,'w');
fprintf(fileID,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n','time_stamp','animal','time1','time2','rampl','rdur','rpos','rbeg','tsize');
for j=1:length(pool)
    fprintf(fileID,'%s\r\n',strarray{j});
end
fclose(fileID);
%%
disp('All FE_JAABA Successfully Produced!')
cd(FE)
end