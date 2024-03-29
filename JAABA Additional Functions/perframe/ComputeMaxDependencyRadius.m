function MAXDEPENDENCYRADIUS = ComputeMaxDependencyRadius(varargin)

MAXDEPENDENCYRADIUS = 0;
for i = 1:numel(varargin),
  paramscurr = varargin{i};
  if isempty(paramscurr), continue, end;
  j = find(strcmp('windows',paramscurr(1:2:end-1)),1);
  if isempty(j),
    j = find(strcmp('max_window_radius',paramscurr(1:2:end-1)),1);
    if ~isempty(j),
      tmprad = max(paramscurr{2*j});
      tmp = 2*tmprad+1;
    else
      tmprad = max(default_window_radii);
      tmp = 2*max(default_window_radii)+1;
    end
    j = find(strcmp('window_offsets',paramscurr(1:2:end-1)),1);
    if ~isempty(j),
      tmp = tmp + max(1,tmprad)*max(abs(paramscurr{2*j}));
    else
      tmp = tmp + max(1,tmprad)*max(abs(default_window_offsets));
    end
  else
    windowscurr = paramscurr{2*j};
    tmp = max(2*windowscurr(:,1)+1+abs(windowscurr(:,2)));
  end
  if ~isempty(tmp),
    %fprintf('i = %d: %d\n',i,tmp);
    MAXDEPENDENCYRADIUS = max(MAXDEPENDENCYRADIUS,tmp);
  end
end    