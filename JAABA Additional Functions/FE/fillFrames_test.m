function frames=fillFrames_test(frames,overlap,selectedCrabspeed,track_start,track_stop,beh_start,beh_stop,bins)
beh_start=beh_start{1};
beh_stop=beh_stop{1};
%% If behavior is not within the bins, regard it as NO BEHAVIOR
if all((beh_stop(:)<bins(1)))||all(beh_start(:)>bins(end))
    beh_start=[];
    beh_stop=[];
end
%%
row=size(frames);
frames(:,4:8)=NaN;
%% get tsize
for i=1:row(1)
    time1=frames(i,2);
    time2=frames(i,3);
    %column8=tsize
    if time1>=track_start && time2<=track_stop
        frames(i,8)=time2-time1;
    elseif time1<track_start && time2<=track_stop
        frames(i,8)=time2-track_start;
    elseif time1>=track_start && time2>track_stop
        frames(i,8)=track_stop-time1;
    elseif time1<track_start && time2>track_stop
        frames(i,8)=track_stop-track_start;        
    end
end
frames(1:row(1),4:7)=NaN;
clear row
%% YES BEHAVIOR
if ~isempty(beh_start)&&~isempty(beh_stop)
if ~isempty(selectedCrabspeed)
line=1;
row=size(overlap);
for i=1:row(1)
    %column4=rampl
    %column5=rdur
    %column6=rpos
    %column7=rbeg
    rbeg=beh_start(i);
    rdur=beh_stop(i)-beh_start(i);
    [lval,lowidx]=min(abs(selectedCrabspeed(:,1)-beh_start(i)));
    [hval,highidx]=min(abs(selectedCrabspeed(:,1)-beh_stop(i)));
    temp=selectedCrabspeed(lowidx:highidx,:);
    [pval,pidx]=max(abs(temp(:,2)));
    rampl=pval;
    rpos=temp(pidx,1);
    clear temp
    %%
    if overlap(i,1)==frames(line,2)
        if overlap(i,2)~=0
            for j=0:overlap(i,2)
                frames(line,4)=rampl;
                frames(line,5)=rdur;
                frames(line,6)=rpos;
                frames(line,7)=rbeg;
                line=line+1;
            end
            repeat=0;
        else
            frames(line,4)=rampl;
            frames(line,5)=rdur;
            frames(line,6)=rpos;
            frames(line,7)=rbeg;
            line=line+1;
        end
    elseif (overlap(i,1)==frames(line+1,2))
        line=line+1;
        if overlap(i,2)~=0
            for j=0:overlap(i,2)
                frames(line,4)=rampl;
                frames(line,5)=rdur;
                frames(line,6)=rpos;
                frames(line,7)=rbeg;
                line=line+1;
            end
            repeat=0;
        else
            frames(line,4)=rampl;
            frames(line,5)=rdur;
            frames(line,6)=rpos;
            frames(line,7)=rbeg;
            line=line+1;
        end
    elseif (overlap(i,1)==frames(line+1,3))
        line=line+2;
        if overlap(i,2)~=0
            for j=0:overlap(i,2)
                frames(line,4)=rampl;
                frames(line,5)=rdur;
                frames(line,6)=rpos;
                frames(line,7)=rbeg;
                line=line+1;
            end
            repeat=0;
        else
            frames(line,4)=rampl;
            frames(line,5)=rdur;
            frames(line,6)=rpos;
            frames(line,7)=rbeg;
            line=line+1;
        end
    end
end
end
clearvars row line
end