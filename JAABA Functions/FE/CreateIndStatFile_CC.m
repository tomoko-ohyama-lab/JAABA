function CreateIndStatFile_CC(allScores,crabspeed,genoInfo,aninum)
%%
output=[];
line=1;
for j=1:aninum
    if ~isempty(allScores.allScores.t0sSeconds{j})
        % select crabspeed according to its index
        temp=(crabspeed(:,2)==j);
        index=find(temp);
        selectedCrabspeed=crabspeed(min(index):max(index),3:4);
        % assign value in output (1:aninum,1:7)
        for k=1:length(allScores.allScores.t0sSeconds{j})
            %             output{line,1}=timestamp;
            output{line,1}=j; %animal
            output{line,2}=allScores.allScores.t0sSeconds{j}(k); %rstart
            output{line,3}=allScores.allScores.t1sSeconds{j}(k); %rend
            output{line,4}=output{line,3}-output{line,2}; %rdur
            [lval,lowidx]=min(abs(selectedCrabspeed(:,1)-allScores.allScores.t0sSeconds{j}(k)));
            [hval,highidx]=min(abs(selectedCrabspeed(:,1)-allScores.allScores.t1sSeconds{j}(k)));
            temp=selectedCrabspeed(lowidx:highidx,:);
            [rampl,rpos]=max(abs(temp(:,2)));
            output{line,5}=rampl; %rampl
            output{line,6}=temp(rpos,1); %rpos
            output{line,7}=allScores.allScores.tStartSeconds(j); %tstart
            output{line,8}=allScores.allScores.tEndSeconds(j); %tend
            output{line,9}=output{line,8}-output{line,7}; %tsize
            line=line+1;
        end
    else
        output{line,1}=j; %animal
        output(line,2)={NaN}; %rstart
        output(line,3)={NaN}; %rend
        output(line,4)={NaN}; %rdur
        output(line,5)={NaN}; %rampl
        output(line,6)={NaN}; %rpos
        output{line,7}=allScores.allScores.tStartSeconds(j); %tstart
        output{line,8}=allScores.allScores.tEndSeconds(j); %tend
        output{line,9}=output{line,8}-output{line,7}; %tsize
        line=line+1;
    end
end

% convert each row to string
% genoInfo=[driver,effector,tracker,protocol,current_timestamp];
driver=genoInfo{1};
effector=genoInfo{2};
tracker=genoInfo{3};
protocol=genoInfo{4};
timestamp=genoInfo{5};
strarray=[];
for j=1:length(output)
    strarray{j}=sprintf('\t%5.0i\t%3.2f\t%3.2f\t%3.2f\t%2.3f\t%3.2f\t%3.2f\t%3.2f\t%3.2f',cell2mat(output(j,1:end)));
    strarray{j}=strcat(timestamp,strarray{j});
end

% save the stat.txt
dir_FEstructureJAABA_CC(genoInfo);
FEname=strcat(driver,'@',effector,'@',tracker,'@',protocol,'@100.crabspeed_area-animal_stats_rolls.txt');
fileID=fopen(FEname,'w');
fprintf(fileID,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n','time_stamp','animal','rstart','rend','rdur','rampl','rpos','tstart','tend','tsize');
for j=1:length(strarray)
    fprintf(fileID,'%s\r\n',strarray{j});
end
fclose(fileID);
end