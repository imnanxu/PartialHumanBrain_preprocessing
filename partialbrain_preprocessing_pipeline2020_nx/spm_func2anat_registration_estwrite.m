%-----------------------------------------------------------------------
% Job saved on 19-Feb-2020 14:49:07 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7487)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
function matlabbatch=spm_func2anat_registration_estwrite(Dir_ref, filename_ref, Dir_sr, filename_sr, Dir_app, filename_app, Ntime)

matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {[Dir_ref filename_ref ',1']};
matlabbatch{1}.spm.spatial.coreg.estwrite.source ={[Dir_sr filename_sr ',1']};
%%
for time=1:Ntime
    matlabbatch{1}.spm.spatial.coreg.estwrite.other{time,1}=[Dir_app filename_app ',' num2str(time)];
end
%%
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2 1];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 7;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';

