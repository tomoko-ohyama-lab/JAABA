function [success,msg] = Convert2JAABAWrapper(InputDataType,varargin)

[inmoviefile,...
  expdir,moviefilestr,trxfilestr,perframedirstr,...
  arenatype,arenacenterx,arenacentery,...
  arenaradius,arenawidth,arenaheight,roi2,...
  pxpermm,fps,overridefps,overridearena,...
  dosoftlink,dofliplr,doflipud,dotransposeimage,...
  frameinterval,...
  leftovers] = myparse_nocheck(varargin,...
  'inmoviefile','',...
  'expdir','','moviefilestr','movie.ufmf','trxfilestr','trx.mat','perframedirstr','perframe',...
  'arenatype','None','arenacenterx',0,'arenacentery',0,...
  'arenaradius',123,'arenawidth',123,'arenaheight',123,'roi2',[],...
  'pxpermm',1,'fps',30,...
  'overridefps',false,...
  'overridearena',false,...
  'dosoftlink',false,...
  'fliplr',false,...
  'flipud',false,...
  'dotransposeimage',false,...
  'frameinterval',[]);

recyclestate = recycle('on');

switch InputDataType,
  case {'Ctrax','CtraxPlusWings','SimpleTwoFlies'},
    [success,msg] = ConvertCtrax2JAABA(...
      'inmoviefile',inmoviefile,...
      leftovers{:},...
      'expdir',expdir,...
      'moviefilestr',moviefilestr,...
      'trxfilestr',trxfilestr,...
      'perframedirstr',perframedirstr,...
      'overridefps',overridefps,...
      'overridearena',overridearena,...
      'dosoftlink',dosoftlink,...
      'fps',fps,...
      'pxpermm',pxpermm,...
      'arenatype',arenatype,...
      'arenacenterx',arenacenterx,...
      'arenacentery',arenacentery,...
      'arenaradius',arenaradius,...
      'arenawidth',arenawidth,...
      'arenaheight',arenaheight,...
      'roi2',roi2,...
      'flipud',doflipud,...
      'fliplr',dofliplr,...
      'dotransposeimage',dotransposeimage,...
      'frameinterval',frameinterval);
  case 'LarvaeRiveraAlba',
    [success,msg] = ConvertLarvaeRiveraAlba2JAABA(...
      'inmoviefile',inmoviefile,...
      leftovers{:},...
      'expdir',expdir,...
      'moviefilestr',moviefilestr,...
      'trxfilestr',trxfilestr,...
      'perframedirstr',perframedirstr,...
      'dosoftlink',dosoftlink);
  case 'Motr',
    [success,msg] = ConvertMotr2JAABA(...
      'inmoviefile',inmoviefile,...
      leftovers{:},...
      'expdir',expdir,...
      'moviefilestr',moviefilestr,...
      'trxfilestr',trxfilestr,...
      'perframedirstr',perframedirstr,...
      'dosoftlink',dosoftlink,...
      'pxpermm',pxpermm,...
      'arenatype',arenatype,...
      'arenacenterx',arenacenterx,...
      'arenacentery',arenacentery,...
      'arenaradius',arenaradius,...
      'arenawidth',arenawidth,...
      'arenaheight',arenaheight,...
      'flipud',doflipud,...
      'fliplr',dofliplr,...
      'dotransposeimage',dotransposeimage,...
      'frameinterval',frameinterval);
    % TODO: sex and frameinterval
  case 'Qtrax',
    [success,msg] = ConvertQtrax2JAABA(...
      'inmoviefile',inmoviefile,...
      leftovers{:},...
      'expdir',expdir,...
      'moviefilestr',moviefilestr,...
      'trxfilestr',trxfilestr,...
      'perframedirstr',perframedirstr,...
      'dosoftlink',dosoftlink,...
      'arenatype',arenatype,...
      'arenacenterx',arenacenterx,...
      'arenacentery',arenacentery,...
      'arenaradius',arenaradius,...
      'arenawidth',arenawidth,...
      'arenaheight',arenaheight);
    % TODO: dosavecadabrafeats
  case 'MAGATAnalyzer',
    [success,msg] = ConvertMAGATAnalyzer2JAABA(...
      'inmoviefile',inmoviefile,...
      leftovers{:},...
      'expdir',expdir,...
      'moviefilestr',moviefilestr,...
      'trxfilestr',trxfilestr,...
      'perframedirstr',perframedirstr,...
      'dosoftlink',dosoftlink,...
      'arenatype',arenatype,...
      'arenacenterx',arenacenterx,...
      'arenacentery',arenacentery,...
      'arenaradius',arenaradius,...
      'arenawidth',arenawidth,...
      'arenaheight',arenaheight);
  case 'MWT',
    [success,msg] = ConvertMWT2JAABA(...
      'inmoviefile',inmoviefile,...
      leftovers{:},...
      'expdir',expdir,...
      'moviefilestr',moviefilestr,...
      'trxfilestr',trxfilestr,...
      'perframedirstr',perframedirstr,...
      'overridearena',overridearena,...
      'dosoftlink',dosoftlink,...
      'pxpermm',pxpermm,...
      'arenatype',arenatype,...
      'arenacenterx',arenacenterx,...
      'arenacentery',arenacentery,...
      'arenaradius',arenaradius,...
      'arenawidth',arenawidth,...
      'arenaheight',arenaheight);
  case 'LarvaeReid',
    [success,msg] = ConvertLarvaeReid2JAABA(...
      'inmoviefile',inmoviefile,...
      leftovers{:},...
      'expdir',expdir,...
      'moviefilestr',moviefilestr,...
      'trxfilestr',trxfilestr,...
      'perframedirstr',perframedirstr,...
      'overridearena',overridearena,...
      'dosoftlink',dosoftlink,...
      'pxpermm',pxpermm,...
      'arenatype',arenatype,...
      'arenacenterx',arenacenterx,...
      'arenacentery',arenacentery,...
      'arenaradius',arenaradius,...
      'arenawidth',arenawidth,...
      'arenaheight',arenaheight);
  case 'LarvaeLouis',
    [success,msg] = ConvertLarvaeLouis2JAABA(...
      'inmoviefile',inmoviefile,...
      leftovers{:},...
      'expdir',expdir,...
      'moviefilestr',moviefilestr,...
      'trxfilestr',trxfilestr,...
      'perframedirstr',perframedirstr,...
      'overridearena',overridearena,...
      'dosoftlink',dosoftlink,...
      'pxpermm',pxpermm,...
      'arenatype',arenatype,...
      'arenacenterx',arenacenterx,...
      'arenacentery',arenacentery,...
      'arenaradius',arenaradius,...
      'arenawidth',arenawidth,...
      'arenaheight',arenaheight);
  case 'JCtrax',
    [success,msg] = ConvertJCtrax2JAABA(...
      'inmoviefile',inmoviefile,...
      leftovers{:},...
      'expdir',expdir,...
      'moviefilestr',moviefilestr,...
      'trxfilestr',trxfilestr,...
      'perframedirstr',perframedirstr,...
      'dosoftlink',dosoftlink);

  otherwise
    success = false;
    msg = sprintf('Unknown data type %s',InputDataType);
end

recycle(recyclestate);
