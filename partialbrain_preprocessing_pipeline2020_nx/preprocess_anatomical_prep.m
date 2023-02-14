function preprocess_anatomical_prep(fsldir, subjectdir, bet)
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
% _______________________________________________________________________ %
cd (subjectdir)      

% fprintf(['%=============== Processing Anatomical Data ===============%\n\n'])              
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
% FSL: Anatomical Brain Extraction ___________________________________ %
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub,'FSL-Anatomical brain extraction (BET) ... \n'])
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
% _______________________________________________________________ %        %------ENDing note--------
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub,'COMPLETE anatomical brain preparation\n'])
warning('on','all');
