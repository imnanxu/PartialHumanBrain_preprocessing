%-----------------------------------------------------------------------
% Job saved on 19-Feb-2020 16:30:55 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7487)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
function matlabbatch=spm_func2atlas_normalization(Dir_def, filename_def, Dir_app, filename_app, Ntime, vox)
matlabbatch{1}.spm.spatial.normalise.write.subj.def = {[Dir_def 'y_' filename_def]};
%%
for time=1:Ntime
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample{time,1}=[Dir_app filename_app ',' num2str(time)];
end
%%
matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-90 -126  -72
                                                          90   90  108];
matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [vox vox vox];
matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 7;
matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';
