%-----------------------------------------------------------------------
% Job saved on 27-Feb-2020 20:55:45 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7487)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
%%
function matlabbatch=spm_realign_estimate(Dir_app, filename_app, Ntime)
dataname=cell(Ntime,1);
for time=1:Ntime
    dataname{time,1}=[Dir_app filename_app ',' num2str(time)];
end
matlabbatch{1}.spm.spatial.realign.estimate.data{1}=dataname;
%%
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.quality = 1;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.sep = 4;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.fwhm = 4;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.rtm = 0;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.interp = 7;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.weight = '';
