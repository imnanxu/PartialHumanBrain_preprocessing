%-----------------------------------------------------------------------
% Job saved on 19-Feb-2020 14:40:45 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
function matlabbatch=spm_anat_segmentation(Dir_anat, filename_anat, Dir_tmp, filename_tmp)
%/home/nxu25/Documents/spm12/tpm/TPM.nii
matlabbatch{1}.spm.spatial.preproc.channel.vols = {[Dir_anat filename_anat ',1']};
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 40;
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {[Dir_tmp filename_tmp ',1']};
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 1];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {[Dir_tmp filename_tmp ',2']};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 1];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {[Dir_tmp filename_tmp ',3']};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {[Dir_tmp filename_tmp ',4']};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 1];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {[Dir_tmp filename_tmp ',5']};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 1];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {[Dir_tmp filename_tmp ',6']};
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 1];
matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{1}.spm.spatial.preproc.warp.samp = 1;
matlabbatch{1}.spm.spatial.preproc.warp.write = [1 1];
