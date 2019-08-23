function output=writeStatFile_NA(output,line,animal,time1,time2,tsize)
% animal
output{line,1}=animal;
% time1
output{line,2}=time1;
% time2
output{line,3}=time2;
% tsize
output{line,8}=tsize;
end