function [frames,overlap]=getFrames(bins,track_start,track_stop,beh_start,beh_stop)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% frames: individual animal info
% overlap: (does not record time-overlap behavior)
%   column1= time 1 where roll occurs
%   column2= 1 -> time-overlap exists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
frames=[];
overlap=[];
beh_start=beh_start{1};
beh_stop=beh_stop{1};
bins_mat = [bins(1:end-1); bins(2:end)]';
%% If behavior is not within the bins, regard it as NO BEHAVIOR
if all((beh_stop(:)<bins(1)))||all(beh_start(:)>bins(end))
    beh_start=[];
    beh_stop=[];
end
%% NO BEHAVIOR
if isempty(beh_start)
    indx1 = track_start <= bins_mat(:,2) & track_stop >= bins_mat(:,1);
    if all(indx1(:) == 0)
        % if small tsize at the beginning
        return
    end
    indx_final = indx1;
    frames = repelem(bins_mat,indx_final,1);
%elseif (beh_stop<bins(1))
%elseif (beh_start>bins(length(bins)))
else
%% YES BEHAVIOR
% indx1(logical): determines whether in the tracked time
indx1 = track_start < bins_mat(:,2) & track_stop > bins_mat(:,1);
% indx2(double): which bin each beh_start belongs to
%                reorganize into number of bins
% indx3(double): which bin each beh_end belongs to
indx2 = discretize(beh_start,bins);
indx3 = discretize(beh_stop,bins);
% if indx2=NaN && indx3=1, erase
% if indx2=last bin && indx3=NaN, don't erase
% %indx2_NaN=isnan(indx2);
% indx2_lastbin=indx2==(length(bins)-1);
% %indx3_1=indx3==1;
% indx3_NaN=isnan(indx3);
% index=(indx2_lastbin&indx3_NaN); % index of SHOULD NOT ERASE

% remove NaN from indx2,indx3 if there is any
index_nonNaN=~isnan(indx2)&~isnan(indx3);
% index=index|index_nonNaN;
indx2=indx2(index_nonNaN);
indx3=indx3(index_nonNaN);
% indx2_nonNaN=~isnan(indx2);
% indx2=indx2(temp);
% indx3=indx3(temp);
% indx3_nonNaN=~isnan(indx3);
% indx2=indx2(temp);
% indx3=indx3(temp);
overlap = indx2;
% update beh_start,beh_stop accordingly
beh_start=beh_start(index_nonNaN);
beh_stop=beh_stop(index_nonNaN);
% indx4(double): which behavior uses 2 timeframes
indx4 = indx3-indx2;

if isempty(indx4)
else
overlap(2,:) = indx4;
overlap = overlap';
for i=1:length(indx2)
    if indx4(i)~=0 % uses more than 1 timeframes
        bin=indx2(i);
        for j=1:indx4(i)
            indx2(length(indx2)+1)=bin+j;
        end
    end
end
indx2 = accumarray(indx2',1,[length(bins)-1,1]);
% indx3(double): get maximum of indx1 and indx2
indx_final = max([indx1,indx2],[],2);
% frames[rows,2]: appropriate frames to start
frames = repelem(bins_mat,indx_final,1);

% overlap column 1 change: row --> time 1 where roll occurs
row=size(overlap);
for i=1:row(1)
    row=overlap(i,1);
    overlap(i,1)=bins(row);
end
end
clearvars indx1 indx2 indx3 indx4 indx_final row
end