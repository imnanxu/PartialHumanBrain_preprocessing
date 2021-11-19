%-----------------------------------------------------------------------
% Job saved on 02-Apr-2020 11:06:38 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
%%
function matlabbatch=spm_spatialsmoothing(Dir_app, filename_app, Ntime, sm)
dataname=cell(Ntime,1);
for time=1:Ntime
    dataname{time,1}=[Dir_app filename_app ',' num2str(time)];
end
matlabbatch{1}.spm.spatial.smooth.data = dataname;
%%
matlabbatch{1}.spm.spatial.smooth.fwhm = [sm sm sm];
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';
