function output=writeStatFile_roll(value,output,line,animal,time1,time2,rStart,rEnd,tStart,tEnd,selectedCrabspeed)
% tsize
tsize=-1;
if time1>tStart && time2<tEnd
    tsize=time2-time1;
elseif (time1<tStart && time2<tEnd)
    tsize=time2-tStart;
elseif (time1>tStart && time2>tEnd)
    tsize=tEnd-time1;
else
    tsize=tEnd-tStart;
end
switch value
    case 1
        if tsize<0
        else
            % animal
            output{line,1}=animal;
            % time1
            output{line,2}=time1;
            % time2
            output{line,3}=time2;
            % tsize
            output{line,8}=tsize;
            % rbeg
            output{line,7}=rStart;
            % rdur
            output{line,5}=rEnd-rStart;
            [lval,lowidx]=min(abs(selectedCrabspeed(:,1)-rStart));
            [hval,highidx]=min(abs(selectedCrabspeed(:,1)-rEnd));
            temp=selectedCrabspeed(lowidx:highidx,:);
            [pval,pidx]=max(abs(temp(:,2)));
            % rampl
            output{line,4}=pval;
            % rpos
            output{line,6}=temp(pidx,1);
        end
    case 0
        % animal
        output{line,1}=animal;
        % time1
        output{line,2}=time1;
        % time2
        output{line,3}=time2;
        % tsize
        output{line,8}=tsize;
end
end