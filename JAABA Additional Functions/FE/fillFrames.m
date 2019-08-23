function frames=fillFrames(frames,overlap,selectedCrabspeed,track_start,track_stop,beh_start,beh_stop,bins)
beh_start=beh_start{1};
beh_stop=beh_stop{1};

% while line~=row(1)
%     if overlap(line,2)~=0
%         for i=1:overlap(line,2)
%             overlap_processed(length(overlap_processed)+1,:)=0;
%             overlap_processed(line+2:length(overlap_processed),:)=overlap_processed(line+1:length(overlap_processed)-1,:);
%             temp=find(bins==overlap(line,1),1);
%             overlap_processed(line+1,1)=bins(temp+1);
%             overlap_processed(line+1,2)=overlap_processed(line,2);
%             line=line+1;
%         end
%     end
%     line=line+1;
% end

row=size(frames);
frames(:,4:8)=NaN;
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
clear row
% 
% while line~=(length(frames)+1) 
%     %column4=rampl
%     %column5=rdur
%     %column6=rpos
%     %column7=rbeg
%     if frames(line,2)==overlap(beh,1)
%         rbeg=beh_start(beh);
%         rdur=beh_stop(beh)-beh_start(beh);
%         [lval,lowidx]=min(abs(selectedCrabspeed(:,1)-beh_start(beh)));
%         [hval,highidx]=min(abs(selectedCrabspeed(:,1)-beh_stop(beh)));
%         temp=selectedCrabspeed(lowidx:highidx,:);
%         [pval,pidx]=max(abs(temp(:,2)));
%         rampl=pval;
%         rpos=temp(pidx,1);
%         clear temp
%         
%         if overlap(beh,2)~=0
%             t=overlap(beh,2);
%             while t~=-1
%                 frames(line,4)=rampl;
%                 frames(line,5)=rdur;
%                 frames(line,6)=rpos;
%                 frames(line,7)=rbeg;
%                 t=t-1;
%                 line=line+1;
%             end
%             beh=beh+1;
%             clear t
%         else
%             frames(line,4)=rampl;
%             frames(line,5)=rdur;
%             frames(line,6)=rpos;
%             frames(line,7)=rbeg;
%             line=line+1;
%         end
%     end 
% end
end