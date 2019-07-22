function trackedRange=CreateTrackedRange(allScores,aninum,timebins)

trackedRange=[];
rows=length(timebins);
    % 0 15
    % 15 30
    % 30 45
    % ...
for j=1:aninum
    trackedRange(1,j)=allScores.allScores.tStartSeconds(j);
    trackedRange(2,j)=allScores.allScores.tEndSeconds(j);
end
% Determining time1,time2 range
for j=1:aninum
    % 1. lower range
    for k=1:rows
        if trackedRange(1,j)<timebins(k,2)
            trackedRange(1,j)=timebins(k,1);
            break
        end
    end
    
    for k=rows:-1:1
        % 2. higher range
        if trackedRange(2,j)>timebins(k,1)
            trackedRange(2,j)=timebins(k,2);
            break
        end
    end
end

end