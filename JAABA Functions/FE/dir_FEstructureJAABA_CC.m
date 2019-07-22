function dir_FEstructureJAABA_CC(genoInfo)
% genoInfo=[driver,effector,tracker,protocol,current_timestamp];
driver=genoInfo{1};
effector=genoInfo{2};
tracker=genoInfo{3};
protocol=genoInfo{4};
current_timestamp=genoInfo{5};
cd ('/scratch/shua/feature_extraction_JAABA')
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
if ~exist(current_timestamp,'dir')
    mkdir(current_timestamp)
end
cd(current_timestamp)
end