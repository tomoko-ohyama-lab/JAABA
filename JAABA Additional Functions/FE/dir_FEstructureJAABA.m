function dir_FEstructureJAABA(driver,effector,tracker,protocol,timestamps)
org=cd ('C:\Users\Ohyama_Dell\Documents\feature_extraction');
% current location is .../JAABA/feature_extraction
if ~exist(tracker,'dir')
    mkdir(tracker)
end
cd(tracker)
if ~exist(strcat(driver,'@',effector),'dir')
    mkdir(strcat(driver,'@',effector))
end
cd(strcat(driver,'@',effector))
if ~exist(strcat(protocol,'@100'),'dir')
    mkdir(strcat(protocol,'@100'))
end
cd(strcat(protocol,'@100'))
for i=1:length(timestamps)
    if ~exist(timestamps{i},'dir')
        mkdir(timestamps{i})
    end
end
cd(org)
end