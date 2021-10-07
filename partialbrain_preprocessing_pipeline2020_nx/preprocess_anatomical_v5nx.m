function preprocess_anatomical_v5nx(fsldir, subjectdir, diratlas, bet)

%% ________________________________________________________________________
%                                                                          
%                                                                          
%                      Yasmine's Preprocessing Pipeline
%                                                                          
% _________________________________________________________________________
%                                                                          
%           Modified from Anzar Abbas's Preprocessing Pipeline 
%
%                          Last updated 07/24/2019
%                                                                          
% This function can preprocess functional MRI data from an individual
% subject with an anatomical scan and one or more functional scans. The
% preprocessing can be applied to data from monkeys and humans,
% as long as a standard space MRI atlas exists for that species. 
%
% It is important to note that this function relies heavily on FSL
% (https://fsl.fmrib.ox.ac.uk), which must be downloaded and installed.
% Additionally, this function also requires the use of a NIfTI toolbox
% by Jimmy Shen, which has been provided with this function.
%
% A document accompanying this function, named anz_preprocess_manual.pdf,
% should specify the details of the preprocessing pipeline being applied
% and how to address the  paramters that need to be inputted into the
% function. A shorter description of the parameters has been given here as
% well.
%                                                                        
%                                                                          
% _____________________________ subjectdir ________________________________
%                                                                          
% A string which specifies the entire path to the folder in which all of
% the subject's data is stored. This folder should have two types of files
%                                                                          
%   1 - The anatomical image, saved as a NIfTI file, and named 't1'.
%                                                                          
%   2 - The functional image(s), saved as a NIfTI file. One  subject may
%       have more than one functional scan. The name of the functional
%       scan must begin with 'f' and be  followed by two digits specifying
%       the scan number. For example, a subject with one functional scan
%       will have only one file named 'f01'. A subject with two or more
%       functional scans will have multiple functional scans named f01,
%       f02, ..., f10, and so on.
%                                                                          
% It is often helpful to have the subjectdir previously saved as a string
% variable in MATLAB.
%                                                                          
% _______________________________ diratlas ________________________________
%                                                                          
% This is a  string which specifies the entire path to the folder in which
% the standard space atlas data is stored.  This folder should have the
% following files:
%                                                                          
%   1 - The atlas T1 brain image, which is the MNI brain image. This is an
%       anatomical image of the brain in which only neural tissue is
%       present. This file must be named 'mni_brain.nii.gz'
%                                                                          
%   2 - The atlas brain mask image. This is a binary image in which
%       everything that is brain is specified with the value of 1 and
%       everything that is not brain is specified with a value of 0. This
%       file must be named 'atlas_t1_brain_mask.nii.gz'
%
%
% It is often helpful to have the diratlas previously saved as a string
% variable in MATLAB.
              
% _________________________________ BET __________________________________
%                                                                          
% Brain Extraction - This is the input for FSL's Brain Extraction Tool
% (BET). This skull-strips the anatomical image for later use.
% bet is a 1x2 matrix in which the first value is the fractional intensity
% threshold (-1 > 1; default is 0.5). This is the -f option in FSL's BET.
% The second value in the matrix is the vertical gradient in fractional
% intensity threshold (-1>1; default is 0). Positive values give a larger
% brain outline at the bottom and a smaller brain outline at the top. This
% is the -g option in FSL's BET.


% ______________________________________________________________________ %
%                                                                         %
%                                   Setup                                 %
% _______________________________________________________________________ %

% Setting FSL environment and output filetype to '.nii.gz' Saving the
% directories in which all the FSL functions are stored. This part of the
% script is making the assumption that the FSL directory on your computer
% is in the default location that FSL uses when it is being installed. If
% that is not the case, you should change the path of the directory in the
% code above.

k = strfind(subjectdir,'subject');
sub = [subjectdir(k:end),' - ']; 
clear k
% This is simply helping with the text that will be displayed as the
% function is running. 'sub' is a string with the name of the subject that
% will be printed with every update

warning('off','all');
% There are a few warnings that MATLAB outputs depending on the type of
% computer this function that is being run on. As far as my understanding
% goes, they are irrelevant, hence the function is temporarily turning off
% warnings so that the updates being printed as the code runs look clean.

% 
% _______________________________________________________________________ %

% To be removed for parfor compatiblity
cd (subjectdir)      

        
%% ______________________________________________________________________ %
%                                                                         %
%                                  Anatomicals                            %
% _______________________________________________________________________ %
        


fprintf('Working on Anatomical Data\n\n')
        
       
% FSL: Anatomical Image Reorientation ________________________________ %
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub,'Anatomical brain reorientation ... '])
% Every step in this function will print an update in the command
% window. That update will include the time and the name of the
% subject and scan being preprocessed. The above three lines of
% code will repeat with every step.
cmd = [fsldir,'fslreorient2std t1 t1_reorient']; 
system(cmd);
% Reorienting the anatomical image to standard just in case it
% isn't already.
fprintf('Done\n')
% _______________________________________________________________ %        
%              
% FSL: Anatomical Bias Correction _________________________________ %
% ('Bias correction' would go here, if we had it.)
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub,'Anatomical bias correction ... '])
cmd = [fsldir, 'fast -B t1_reorient'];
system(cmd);
system('mv t1_reorient_restore.nii.gz t1_reorient_bc.nii.gz'); fprintf('Done\n') 
% system('mv t1_reorient_restore.nii.gz t1_reorient_bc0.nii.gz');
% cmd = [fsldir, 'flirt -in t1_reorient_bc0.nii.gz -ref t1_reorient_bc0.nii.gz -applyisoxfm 2.0 -nosearch -out t1_reorient_bc.nii.gz'];
% system(cmd);
% _______________________________________________________________ %
%
% FSL: Anatomical Brain Registration to Atlas ________________________ %
% Using FSL's flirt&flnrt to register the anatomical images to the MNI atlas.
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub,'Anatomical brain registration to atlas ... \n'])
fprintf([time,sub,'--completing linear transformations ... '])
cmd = [fsldir,'flirt -in t1_reorient_bc.nii.gz -ref ', diratlas, ... %revised by NX 021720
    '/mni_brain.nii.gz -dof 12 -out t1_reorient_linreg', ...
    ' -omat t1_to_mni_lin.mat'];
system(cmd); fprintf('Done\n')
fprintf([time,sub,'--completing non-linear transformations ... '])
cmd = [fsldir,'fnirt --in=t1_reorient_bc.nii.gz --aff=t1_to_mni_lin.mat' ...
    ' --ref=' diratlas '/mni_brain.nii.gz --iout=t1_reorient_linreg_nonlinreg.nii.gz' ...
    ' --cout=t1_to_mni_coef.nii.gz --fout=t1_to_mni_warp.nii.gz --jacrange=-0.001,100'];
system(cmd); fprintf('Done\n')
%belows are purely added by NX 050920
fprintf([time,sub,'--inverting registration warp ... \n'])
cmd = [fsldir, 'invwarp --ref=t1_reorient_bc.nii.gz --warp=t1_to_mni_warp.nii.gz --out=t1_to_mni_invwarp.nii.gz --noconstraint -v'];
system(cmd); fprintf('Done\n')
fprintf([time,sub,'--applying inverted warp to template... '])
cmd = [fsldir, 'applywarp --in=' diratlas '/mni_brain.nii.gz --ref=t1_reorient_bc.nii.gz --warp=t1_to_mni_invwarp.nii.gz --out=mni_to_t1.nii.gz'];
system(cmd); fprintf('Done\n')
fprintf([time,sub,'--applying inverted warp to parcellated atlas... '])
cmd = [fsldir, 'applywarp --in=' diratlas '/BN_Atlas_246_2mm.nii.gz --ref=t1_reorient_bc.nii.gz --warp=t1_to_mni_invwarp.nii.gz --out=atlas_to_t1.nii.gz'];
system(cmd); fprintf('Done\n')
% _______________________________________________________________ %

% FSL: Anatomical Brain Extraction ___________________________________ %
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub,'FSL-Anatomical brain extraction (BET) ... \n'])
fprintf([time,sub,'--extract registered T1 ... '])
cmd = [fsldir,'bet t1_reorient_linreg_nonlinreg.nii.gz ' ...
    't1_reorient_linreg_nonlinreg_bet.nii.gz -f ' num2str(bet) ' -g .09 -R'];
system(cmd);fprintf('Done\n')
fprintf([time,sub,'--extract non-registered T1 ... '])
if isfile('t1_reorient_bc.nii')
    delete t1_reorient_bc.nii
end
if isfile('t1_reorient_bet.nii')
    delete t1_reorient_bet.nii
end
cmd = [fsldir,'bet t1_reorient_bc.nii.gz ' ... %revised by NX 021720
    't1_reorient_bet.nii.gz -f ' num2str(bet) ' -g .05 -R']; % this doesn't impact on the white matter...
%NX tried (021720) f=0, 0.1, 0.2; g=-0.1, -0.05, 0; f=0.2, g=-0.05 is the best!
system(cmd);fprintf('Done\n')
% _______________________________________________________________ %
%
% FSL: Anatomical Brain Segmentation _________________________________ %
% Segmentation for BET
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub,'Anatomical brain segmentation ... \n'])
fprintf([time,sub,'--segment white matter from registered and bet extracted T1 ... '])
cmd = [fsldir, 'fast -B -l 10 t1_reorient_linreg_nonlinreg_bet.nii.gz'];
system(cmd);
cmd = [fsldir, 'fslmaths t1_reorient_linreg_nonlinreg_bet_pve_2.nii.gz ' ...
    '-thr 0.5 -bin t1_reorient_linreg_nonlinreg_bet_wm.nii.gz'];
system(cmd); fprintf('Done\n')
% Segmentation for non-registered        
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub,'--segment white matter from non-registered T1 ... '])
cmd = [fsldir, 'fast -B -l 10 t1_reorient_bet.nii.gz'];
system(cmd);
cmd = [fsldir, 'fslmaths t1_reorient_bet_pve_2.nii.gz ' ...
    '-thr 0.5 -bin t1_reorient_bet_wm.nii.gz'];
system(cmd); fprintf('Done\n')
%
% _______________________________________________________________ %        


% SPM: Anatomical Brain Extraction & Segmentation & Compute Anatomical to Atlas Transformation _______________ %
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub,'SPM-segment anatomical brain and compute anatomical to atlas transformation ... \n'])
Dir_anat=[subjectdir '/']; Dir_tmp=[diratlas '/']; 
filename_anat='t1_reorient_bc.nii'; filename_tmp='TPM.nii';
gunzip([filename_anat '.gz']);
matlabbatch_seg=spm_anat_segmentation(Dir_anat, filename_anat, Dir_tmp, filename_tmp);
spm_jobman('run', matlabbatch_seg); fprintf('Done SPM anatomical preprocessing.\n')
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub,'COMPLETE anatomical brain preprocessing\n'])
%_____________________________________________________________%
%         Anzar's code is below this. For now, I'm going to try what Amrit
%         has set up. 
%
%         cmd = [fsldir,'fast -B -l 10 -g t1_reorient_linreg_nonlinreg_bet'];
%         system(cmd);
%         system('rm t1_reorient_linreg_nonlinreg_bet_seg.nii.gz');
%         system(['mv t1_reorient_linreg_nonlinreg_bet_seg_0.nii.gz ', ...
%             't1_reorient_linreg_nonlinreg_bet_csf.nii.gz']);
%         system(['mv t1_reorient_linreg_nonlinreg_bet_seg_1.nii.gz ', ...
%             't1_reorient_linreg_nonlinreg_bet_gm.nii.gz']);
%         system(['mv t1_reorient_linreg_nonlinreg_bet_seg_2.nii.gz ', ...
%             't1_reorient_linreg_nonlinreg_bet_wm.nii.gz']);
%         system(['mv t1_reorient_linreg_nonlinreg_bet_restore.nii.gz ', ...
%             't1_reorient_linreg_nonlinreg_bet_biascorrected.nii.gz']);
%         system('rm *pve*'); system('rm *mixeltype*');
        % Using FSL's FAST tool to separate out the three main tissue types
        % in the brain and then renaming them so that their filenames are
        % more indicative of what they actually are
%         fprintf('Done\n')
        % _______________________________________________________________ %
%       
               
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub,'COMPLETE anatomical brain preprocessing\n'])
warning('on','all');
