function CreateBinStatFile_modifiableBin(allScores,crabspeed,genoInfo,aninum,timebins)
%% Assuming bins are always uniform
output={};
% Defining the tracked time range
trackedRange=CreateTrackedRange(allScores,aninum,timebins);
rows=length(timebins);
% 0 15
% 15 30
% 30 45
% ...
line=1;
for j=1:aninum
    tStart=allScores.allScores.tStartSeconds(j);
    tEnd=allScores.allScores.tEndSeconds(j);
    %% if trackedRange does not belong to the timebins, NA
    if trackedRange(1,j)~=floor(trackedRange(1,j))
%         if trackedRange(2,j)<timebins(1,1)
%             tsize=trackedRange(2,j)-trackedRange(1,j);
%             output=writeStatFile_NA(output,line,j,timebins(1,1),timebins(1,2),tsize);
%             line=line+1;
%         else
%             tsize=trackedRange(2,j)-trackedRange(1,j);
%             output=writeStatFile_NA(output,line,j,timebins(rows,1),timebins(rows,2),tsize);
%             line=line+1;
%         end
    %% YES ROLL
    elseif (~isempty(allScores.allScores.t0sSeconds{j}))
        % select crabspeed
        temp=(crabspeed(:,2)==j);
        index=find(temp);
        selectedCrabspeed=crabspeed(min(index):max(index),3:4);
        for k=1:rows % k=timebins ROW
            if (tStart<timebins(k,1) && tEnd<timebins(k,1))
            elseif (tStart>timebins(k,2))
            else
                
                for l=1:length(allScores.allScores.t0sSeconds{j}) % l=roll ARRAY
                    if allScores.allScores.t0sSeconds{j}(l)<timebins(k,1)
                    elseif allScores.allScores.t0sSeconds{j}(l)>timebins(k,2)
                        % rolling lies within one time range
                    elseif (allScores.allScores.t0sSeconds{j}(l)>=timebins(k,1)&&allScores.allScores.t1sSeconds{j}(l)<=timebins(k,2))
                        output=writeStatFile_roll(output,line,j,timebins(k,1),timebins(k,2),allScores.allScores.t0sSeconds{j}(l),allScores.allScores.t1sSeconds{j}(l),tStart,tEnd,selectedCrabspeed);
                        % for mis-match in crabspeed
                        if output{line,7}>output{line,6}
                        else
                            line=line+1;
                        end
                        % rolling lies within two time range
                    elseif ((allScores.allScores.t0sSeconds{j}(l)>=timebins(k,1)&&allScores.allScores.t1sSeconds{j}(l)>timebins(k,2)))
                        output=writeStatFile_roll(output,line,j,timebins(k,1),timebins(k,2),allScores.allScores.t0sSeconds{j}(l),timebins(k,2),tStart,tEnd,selectedCrabspeed);
                        line=line+1;
                        output=writeStatFile_roll(output,line,j,timebins(k+1,1),timebins(k+1,2),timebins(k+1,1),allScores.allScores.t1sSeconds{j}(l),tStart,tEnd,selectedCrabspeed);
                        line=line+1;
                    end
                end
            end
        end
    %% NO ROLL
    elseif (isempty(allScores.allScores.t0sSeconds{j}))
        stop=0;
        for k=1:rows % k=timebins ROW
            % stop=1 means stop writing
            if stop==1
            % tstart>time2, no writing
            elseif (tStart>timebins(k,2))
            % tSize=time2-time1
            elseif (tStart<=timebins(k,1) && tEnd>timebins(k,2))
                tsize=timebins(k,2)-timebins(k,1);
                output=writeStatFile_NA(output,line,j,timebins(k,1),timebins(k,2),tsize);
                line=line+1;
            % tStart is after the last time2
            elseif (tStart<=timebins(k,1) && tEnd<=timebins(k,2))
                tsize=tEnd-timebins(k,1);
                output=writeStatFile_NA(output,line,j,timebins(k,1),timebins(k,2),tsize);
                line=line+1;
                stop=1;
            elseif (tStart>=timebins(k,1) && tEnd<=timebins(k,2))
                tsize=tEnd-tStart;
                output=writeStatFile_NA(output,line,j,timebins(k,1),timebins(k,2),tsize);
                line=line+1;
                stop=1;
            elseif (tStart>=timebins(k,1) && tEnd>timebins(k,2))
                tsize=timebins(k,2)-tStart;
                output=writeStatFile_NA(output,line,j,timebins(k,1),timebins(k,2),tsize);
                line=line+1;
            end
        end
    end
end
empties=cellfun('isempty',output);
output(empties)={NaN};

%% Convert each row to string
% genoInfo=[driver,effector,tracker,protocol,current_timestamp];
driver=genoInfo{1};
effector=genoInfo{2};
tracker=genoInfo{3};
protocol=genoInfo{4};
timestamp=genoInfo{5};
strarray=[];
for j=1:length(output)
    strarray{j}=sprintf('\t%5.0i\t%3.2f\t%3.2f\t%2.3f\t%2.3f\t%3.3f\t%3.3f\t%2.3f',cell2mat(output(j,1:end)));
    strarray{j}=strcat(timestamp,strarray{j});
end
%% Save the stat.txt
dir_FEstructureJAABA(genoInfo)
FEname=strcat(driver,'@',effector,'@',tracker,'@',protocol,'@100.crabspeed_area-animal_stats_rolls.txt');
fileID=fopen(FEname,'w');
fprintf(fileID,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n','time_stamp','animal','time1','time2','rampl','rdur','rpos','rbeg','tsize');
for j=1:length(strarray)
    fprintf(fileID,'%s\r\n',strarray{j});
end
fclose(fileID);
end