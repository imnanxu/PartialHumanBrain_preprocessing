function filename=preproces_functional4all_spm(subjectdir, filename, fsldir, diratlas, bet, sm, fil)

% starts functional brain preprocessing
% realgin all functional scans 
% This section is using FSL's MCFLIRT tool to conduct
% motion correction and then plotting out and saving the motion
% parameters as a separate JPEG file that can be viewed later.

% Setting FSL environment and output filetype to '.nii.gz' Saving the
% directories in which all the FSL functions are stored. This part of the
% script is making the assumption that the FSL directory on your computer
% is in the default location that FSL uses when it is being installed. If
% that is not the case, you should change the path of the directory in the
% code above.


k = strfind(subjectdir,'subject');
sub = [subjectdir(k:end),' - ']; 
% clear k
% This is simply helping with the text that will be displayed as the
% function is running. 'sub' is a string with the name of the subject that
% will be printed with every update

warning('off','all');

cd(subjectdir);
%% _________________Fieldmap Correction__________________________________ %   
% Do distortion correction before the motion correction
% Wenju Pan suggested it after the motion correction previously.
% However, see this paper https://pubmed.ncbi.nlm.nih.gov/15350581-the-effects-of-geometric-distortion-correction-on-motion-realignment-in-fmri/
T = datetime('now'); time = whatsthetime(T); 
fprintf([time,sub ': ','Functional fieldmap correction ... '])
cmd = [fsldir,['fugue -i ', filename, '.nii --dwell=.00003 '...
'--loadfmap=' diratlas '/fmap/fmap_rads.nii.gz -u ' filename '_unwarp.nii.gz']];
system(cmd); fprintf('Done\n')
filename = [filename '_unwarp'];
% _______________________________________________________________________ %

%% ______________Reorienting functional scan _______________ %
% Reorienting the functional scan to standard, just in case it isn't
% already.    
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub, ': ','Functional reorientation ... '])
cmd = [fsldir, 'fslreorient2std ' filename '.nii.gz ' filename '_reorient.nii.gz'];
system(cmd); fprintf('Done\n')
filename = [filename,'_reorient'];

%% ______________Motion corrections _______________ %
T = datetime('now'); time = whatsthetime(T);
fprintf([time, sub, ': ','SPM: Functional motion correction to 1st volume ... \n'])       
% spm realign:
gunzip([filename '.nii.gz'])
Dir_app=[subjectdir '/']; filename_app=[filename '.nii'];
Vfunc=spm_vol(filename_app); Ntime=length(Vfunc);
% matlabbatch_realign=spm_realign_estimate_write(Dir_app, filename_app, Ntime);
matlabbatch_realign=spm_realign_estimate(Dir_app, filename_app, Ntime);
spm_jobman('run', matlabbatch_realign); 
% % flags.quality=1; flags.fwhm=4; flags.sep=4; flags.interp=7; flags.graphics=1;
% % spm_realign([filename '.nii'],flags);
% filename=['r' filename];
fullfunc_mc=[filename];
fprintf('Done\n')
% ___________________________________________________________ %

%% _Functional brain bias field correction on 1 volume & brain extraction_ %
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub, ': FSL-Extract the 1st volume ... \n'])
cmd = [fsldir,'fslroi ' filename '.nii ' filename '_onevol.nii.gz 0 1'];
system(cmd);
filename = [filename '_onevol'];
% bias field correction to enhance the intensity of the 1st volume--Added
% by Nan Xu 02172020
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub, ': FSL-Functional bias correction on the 1st volume ... '])
cmd = [fsldir, 'fast -B ' filename '.nii.gz'];
system(cmd); fprintf('Done\n') 
system(['mv ' filename '_restore.nii.gz ' filename '_bc.nii.gz']);
filename_bc=[filename '_bc'];
%-------------------------------------------------------------------------%
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub,'FSL-functional brain extraction (BET) ... \n'])
cmd = [fsldir,'bet ' filename_bc '.nii.gz ' ... %revised by NX 021720
    filename_bc '_bet.nii.gz -f ' num2str(bet) ' -g .05 -R']; % this doesn't impact on the white matter...
%NX tried (021720) f=0, 0.1, 0.2; g=-0.1, -0.05, 0; f=0.1, g=-0.05 is the best!
system(cmd);fprintf('Done\n')
filename_bet=[filename_bc '_bet'];
% _______________________________________________________________________ %

%% __________________Functional registration (SPM)_______________________ %
% Using SPM to register the EPI (functional) image to the MNI: works well
% for partial brains or functional brain data with several signal loss
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub ': ','Functional registration ... \n'])
fprintf([time,sub ': SPM-estimate transformation from functional to anatomical ... \n'])
Dir_ref=[subjectdir '/']; Dir_sc=[subjectdir '/']; Dir_app=[subjectdir '/']; 
filename_ref='t1_reorient_bet.nii'; filename_sc=[filename_bet '.nii']; filename_app=[fullfunc_mc '.nii'];
gunzip([filename_ref '.gz']); 
gunzip([filename_sc '.gz']);
matlabbatch_reg=spm_func2anat_registration_estwrite(Dir_ref, filename_ref, Dir_sc, filename_sc, Dir_app, filename_app, Ntime);
spm_jobman('run', matlabbatch_reg); fprintf('Done\n')

T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub ': SPM-normalize functional brain to atlas ... \n'])
Dir_def=[subjectdir '/']; filename_def='t1_reorient_bc.nii'; vox=2;
matlabbatch_nor=spm_func2atlas_normalization(Dir_def, filename_def, Dir_app, filename_app, Ntime, vox);
spm_jobman('run', matlabbatch_nor);
fprintf('Done\n')
filename='wAllScans_unwarp_reorient';

%fprintf([time,sub, ': ','FSL-applying t1->atlas warp to SPM coregistered EPI... '])     
%cmd = [fsldir,'applywarp --in=r' filename_app '.nii --ref=' diratlas ...
%    '/mni_brain.nii.gz --warp=t1_to_mni_warp.nii.gz '...
%     ' --out=fsl_r' filename_app '_to_mni.nii.gz'];
%system(cmd); fprintf('Done\n')
% _______________________________________________________________________ %

%% _______________________Spatial smoothing _____________________________ %
% Using FSL's fslmaths tool to spatially smooth the functional scans by
% however much the user specified--completely rewritten by Nan Xu 033120
% The old version spatial smooth the whole 4D data including the time
% dimension whereas the new version only smooth the x-y-z dimension for
% each volume and then concatenate all spatially smoothed volumes.
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub, ': ','Functional spatial smoothing ... '])
folder_sm='sm'; mkdir(folder_sm);
% sm=4; Dir_app=''; 
filename_app=[filename '.nii'];
matlabbatch_sm=spm_spatialsmoothing(Dir_app, filename_app, Ntime, sm);
spm_jobman('run', matlabbatch_sm);
% % test fsl sm--fsl inividual 3D vol sm=fsl 4D vol sm; fsl failure on
% % smoothing partial brains...
% movefile([filename '.nii'], ['./' folder_sm '/' filename '.nii']);
% cd(folder_sm);
% cmd = [fsldir,'fslsplit ', filename, '.nii vol -t']; system(cmd);
% allvol=[];
% for volume_c=1:Ntime
%     filename_c=['vol' num2str(volume_c-1, '%04.f')];
%     cmd = [fsldir,'fslmaths ', filename_c, '.nii.gz -s ', sm, ...
%         ' ',filename_c, '_sm.nii.gz'];
%     system(cmd);
%     allvol=[allvol ' ' filename_c '_sm'];
% end
% cmd = [fsldir,'fslmerge -tr ', filename '_sm.nii.gz' allvol, ' ' num2str(TR)];
% system(cmd); 
% cd('../')
filename = ['s' filename];
fprintf('Done\n')
% _______________________________________________________________________ %

%% ______________Temporal filtering ______________________________________ %%
% This section does temporal filtering with AFNI's 3dBandpass function, 
% using the two filtering parameters defined by the user. At this stage, 
% the variable "filename" will be scan_trim_stc_mc_warp_sm, representing 
% the name of the resulting file after smoothing (and prior steps).
% This is the input for the temporal filtering stage.
% The output is filename_trim_stc_mc_warp_sm_fil.nii.gz, with temporal filtering applied to the input data
T = datetime('now');time = whatsthetime(T);
fprintf([time,sub, ': ','AFNI-functional temporal filtering ... ']);
% 3dBandpass applies a bandpass filter over the timeseries of each voxel in the input, with the first and second elements of fil as the lower and higher freq. bounds respectively.
% The output of this command will be scan_temp_tf+tlrc.BRIK and scan_temp_tf+tlrc.HEAD, with scan_temp_tf+tlrc.BRIK containing the data after temporal filtering.
cmd = ['3dBandpass -prefix ' filename '_temp_tf -quiet -overwrite ' num2str(fil(1)) ' ' num2str(fil(2)) ' ' filename '.nii'];
system(cmd);
% 3dAFNItoNIFTI converts the AFNI file (+tlrc.BRIK) generated from 3dBandpass back to the NIFTI file format (.nii)
% The input is scan_temp_tf+tlrc.BRIK generated by 3dBandpass, and the output file will be scan_trim_stc_mc_warp_sm_fil.nii.gz
cmd = ['3dAFNItoNIFTI -prefix ' filename '_fil.nii.gz -overwrite ' filename '_temp_tf+tlrc.BRIK'];
system(cmd);
filename=[filename '_fil'];
fprintf('Done\n');
% _______________________________________________________________________ %

%------ENDing note--------
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub,'COMPLETE functional concatenated data preprocessing\n'])
warning('on','all');
