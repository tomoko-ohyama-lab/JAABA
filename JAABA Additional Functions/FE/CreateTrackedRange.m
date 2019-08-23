function trackedRange=CreateTrackedRange(allScores,aninum,timebins)
tracked=[];
trackedRange=[];
rows=length(timebins);
    % 0 15
    % 15 30
    % 30 45
    % ...
for j=1:aninum
    tracked(j,1)=allScores.allScores.tStartSeconds(j);
    tracked(j,2)=allScores.allScores.tEndSeconds(j);
end
% Determining time1,time2 range
for j=1:aninum
    if (tracked(j,1)<timebins(1,1) && tracked(j,2)<timebins(1,1))
        trackedRange{j}(1)=tracked(j,1);
        trackedRange{j}(2)=tracked(j,2);
        % when trackedRange does not belong to the timebins, do nothing
    elseif (tracked(j,1)>timebins(rows,2) && tracked(j,2)>timebins(rows,2))
        trackedRange(j,1)=tracked(j,1);
        trackedRange(j,2)=tracked(j,2);
    else
        % 1. lower range
        for k=1:rows
            if tracked(j,1)<timebins(k,2)
                tracked(j,1)=timebins(k,1);
                break
            end
        end
        % 2. higher range
        for k=rows:-1:1
            if tracked(j,2)>timebins(k,1)
                tracked(j,2)=timebins(k,2);
                break
            end
        end
        % 3. Specifying the corresponding time range
        for k=1:rows
        if (timebins(k,1)>=tracked(j,1))&&(timebins(k,2)<=tracked(j,2))
            trackedRange(j,k)=timebins(k,1);
            if timebins(k,2)==tracked(j,2)
               trackedRange(j,k+1)=timebins(k,2); 
            end
        end
        end
    end
end

end