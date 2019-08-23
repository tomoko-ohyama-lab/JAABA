function CreateBinStatFile_CC(allScores,crabspeed,genoInfo,aninum,timebins)
%%
output=[];
% Defining the tracked time range
trackedRange=CreateTrackedRange(allScores,aninum,timebins);

line=1;
for j=1:aninum
    %% Yes Roll
    if ~isempty(allScores.allScores.t0sSeconds{j})
        % select crabspeed
        temp=(crabspeed(:,2)==j);
        index=find(temp);
        selectedCrabspeed=crabspeed(min(index):max(index),3:4);
        lowRange=trackedRange(1,j);
        highRange=trackedRange(2,j);
        for k=lowRange:15:(highRange-15)
            % before the first roll
            if (allScores.allScores.t0sSeconds{j}(1)>k+15)
                output{line,1}=j;
                %% time1
                output{line,2}=k;
                %% time2
                output{line,3}=k+15;
                %% tsize
                if k==lowRange
                    output{line,8}=(k+15-allScores.allScores.tStartSeconds(j));
                elseif (k==highRange-15)
                    output{line,8}=(allScores.allScores.tEndSeconds(j)-k);
                else
                    output{line,8}=15;
                end
                line=line+1;
            %after all rolls
            elseif (allScores.allScores.t1sSeconds{j}(length(allScores.allScores.t1sSeconds{j}))<k)
                output{line,1}=j;
                %% time1
                output{line,2}=k;
                %% time2
                output{line,3}=k+15;
                %% tsize
                if k==lowRange
                    output{line,8}=(k+15-allScores.allScores.tStartSeconds(j));
                elseif (k==highRange-15)
                    output{line,8}=(allScores.allScores.tEndSeconds(j)-k);
                    if output{line,8}>15
                        output{line,8}=15;
                    end
                else
                    output{line,8}=15;
                end
                line=line+1;
            else
                for l=1:length(allScores.allScores.t0sSeconds{j})
                    %% when roll duration falls WITHIN 15 seconds range
                    if (allScores.allScores.t0sSeconds{j}(l)>k)&&(allScores.allScores.t1sSeconds{j}(l)<k+15)
                        %% animal
                        output{line,1}=j;
                        %% time1
                        output{line,2}=k;
                        %% time2
                        output{line,3}=k+15;
                        %% tsize
                        if k==lowRange
                            output{line,8}=(k+15-allScores.allScores.tStartSeconds(j));
                        elseif (k==highRange-15)
                            output{line,8}=(allScores.allScores.tEndSeconds(j)-k);
                        else
                            output{line,8}=15;
                        end
                        %% rbeg
                        output{line,7}=allScores.allScores.t0sSeconds{j}(l);
                        %% rdur
                        output{line,5}=(allScores.allScores.t1sSeconds{j}(l)-allScores.allScores.t0sSeconds{j}(l));
                        [lval,lowidx]=min(abs(selectedCrabspeed(:,1)-allScores.allScores.t0sSeconds{j}(l)));
                        [hval,highidx]=min(abs(selectedCrabspeed(:,1)-allScores.allScores.t1sSeconds{j}(l)));
                        temp=selectedCrabspeed(lowidx:highidx,:);
                        [pval,pidx]=max(abs(temp(:,2)));
                        %% rampl
                        output{line,4}=pval;
                        %% rpos
                        output{line,6}=temp(pidx,1);
                        line=line+1;
                        %% when roll duration is OVER 15 seconds range
                    elseif (allScores.allScores.t0sSeconds{j}(l)>k)&&(allScores.allScores.t1sSeconds{j}(l)<k+30)
                        % check whether rdur>15
                        if (allScores.allScores.t1sSeconds{j}(l)-allScores.allScores.t0sSeconds{j}(l))<15
                            
                        else
                            %% allScores.allScores.t0sSeconds{j}(l)~k+15
                            %% animal
                            output{line,1}=j;
                            %% time1
                            output{line,2}=k;
                            %% time2
                            output{line,3}=k+15;
                            %% tsize
                            if k==lowRange
                                output{line,8}=((k+15)-allScores.allScores.tStartSeconds(j));
                            elseif (k==highRange-15)
                                output{line,8}=(allScores.allScores.tEndSeconds(j)-k);
                            else
                                output{line,8}=15;
                            end
                            %% rbeg
                            output{line,7}=allScores.allScores.t0sSeconds{j}(l);
                            %% rdur
                            output{line,5}=(k+15-allScores.allScores.t0sSeconds{j}(l));
                            [lval,lowidx]=min(abs(selectedCrabspeed(:,1)-allScores.allScores.t0sSeconds{j}(l)));
                            [hval,highidx]=min(abs(selectedCrabspeed(:,1)-(k+15)));
                            temp=selectedCrabspeed(lowidx:highidx,:);
                            [pval,pidx]=max(abs(temp(:,2)));
                            %% rampl
                            output{line,4}=pval;
                            %% rpos
                            output{line,6}=temp(pidx,1);
                            line=line+1;
                            
                            %% k+15~allScores.allScores.t1sSeconds{j}(l)
                            %% animal
                            output{line,1}=j;
                            %% time1
                            output{line,2}=k+15;
                            %% time2
                            output{line,3}=k+30;
                            %% tsize
                            if (k+15)==lowRange
                                output{line,8}=(k+15-allScores.allScores.tStartSeconds(j));
                            elseif ((k+15)==highRange-15)
                                output{line,8}=(allScores.allScores.tEndSeconds(j)-(k+15));
                            else
                                output{line,8}=15;
                            end
                            %% rbeg
                            output{line,7}=k+15;
                            %% rdur
                            output{line,5}=(allScores.allScores.t1sSeconds{j}(l)-(k+15));
                            [lval,lowidx]=min(abs(selectedCrabspeed(:,1)-(k+15)));
                            [hval,highidx]=min(abs(selectedCrabspeed(:,1)-allScores.allScores.t1sSeconds{j}(l)));
                            temp=selectedCrabspeed(lowidx:highidx,:);
                            [pval,pidx]=max(abs(temp(:,2)));
                            %% rampl
                            output{line,4}=pval;
                            %% rpos
                            output{line,6}=temp(pidx,1);
                            line=line+1;
                        end
                    end
                end
            end
        end
    else
        %% No Roll
        lowRange=trackedRange(1,j);
        highRange=trackedRange(2,j);
        for k=lowRange:15:(highRange-15)
            %% animal
            output{line,1}=j;
            %% time1
            output{line,2}=k;
            %% time2
            output{line,3}=k+15;
            %% tsize
            if k==lowRange
                output{line,8}=(k+15-allScores.allScores.tStartSeconds(j));
            elseif (k==highRange-15)
                output{line,8}=(allScores.allScores.tEndSeconds(j)-k);
            else
                output{line,8}=15;
            end
            line=line+1;
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
dir_FEstructureJAABA_CC(genoInfo)
FEname=strcat(driver,'@',effector,'@',tracker,'@',protocol,'@100.crabspeed_area-animal_stats_rolls.txt');
fileID=fopen(FEname,'w');
fprintf(fileID,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n','time_stamp','animal','time1','time2','rampl','rdur','rpos','rbeg','tsize');
for j=1:length(strarray)
    fprintf(fileID,'%s\r\n',strarray{j});
end
fclose(fileID);
end