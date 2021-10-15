# This pipeline is for preproessing EPI human brains data with partial coverage. 
# Developed by Nan Xu in 2020
clear all
close all
clc

dirhead='/keilholz-lab/Nan/PB_preprocessing';

%adds data path to MATLAB paths
addpath([dirhead '/partialbrain_preprocessing_pipeline2020_nx/'])
addpath([dirhead '/partialbrain_preprocessing_pipeline2020_nx/NIfTItoolbox/']);
addpath(genpath([dirhead '/partialbrain_preprocessing_pipeline2020_nx/afni_matlab/']));
addpath(([dirhead '/partialbrain_preprocessing_pipeline2020_nx/spm12']))
diary([dirhead '/Data/MATLAB_log_Allscans_' datestr(now,'mmddyy') '.txt']);

%% Parameter Settings --added by NX 02092020
%establishes parameter variables
TR = .7;
% bet = .4; % brain extraction -f parameter
trimf = 0; 
stc = 0; % turn off slice timing correction
mc=1;  % turn on motion correction for each subject
funcregtype='spm'; % use spm for the functional registration
sm = 4; % smoothing filter size
fil = [.01, .1]; % temporal filter
gsr = 1; %turn on "global signal regression"
wmcsfr = 1; %white matter CSF  regression
% diratlas='../resources';
diratlas_t=[dirhead '/partialbrain_preprocessing_pipeline2020_nx/spm12/'];
diratlas = [dirhead '/partialbrain_preprocessing_pipeline2020_nx/resources'];
% atlas_filename=[diratlas '/Fan2016parcel_Yeo/BN_Atlas_246_2mm.nii.gz']; atlas='fan246';
atlas_filename=[diratlas '/Schaefer2018parcel_Yeo/Schaefer2018_400Parcels_7Networks_order_FSLMNI152_2mm.nii.gz']; atlas='schaefer400';

fsldir='';
% addpath(diratlas);

%load directories of the subjects
dirdata=dir([dirhead '/Data']);

%below generates list of subjects to iterate over
n_subj_st=find(strcmp({dirdata.name}, 'subject001')==1);
n_subj_ed=find(strcmp({dirdata.name}, 'subject002')==1); %please put the largest subj number here
subj_ct=0;
for s_row=n_subj_st:n_subj_ed
    subj_ct=subj_ct+1;
    subs(subj_ct,:) = string([dirdata(s_row).folder, '/', char(dirdata(s_row).name)]);
end
subs

%% Parallel Computing through parfor --added by NX 02092020
delete(gcp('nocreate'));
parpool(12,'IdleTimeout', 100000);
warning off
scans={'f01', 'rest'; ... %subj1
       'rest', 'f03'}; %subj2
Nscans=size(scans,2);    
parfor subj_ct=1:length(subs)
    
    %iterates through all subjects
	subjectdir = char(subs(subj_ct))
    scans_subj=scans(subj_ct,:);
 
    %starts anatomical brain preprocessing
    bet=0.3; % brain extraction -f parameter
	preprocess_anatomical_v5nx(fsldir, subjectdir, diratlas, bet)
    preprocess_anatomical_maskcreation(fsldir, subjectdir);
   
    %starts the functional scans merging    
    file_merge=epi_merge(fsldir, subjectdir, scans_subj);  %file_merge='AllScans';
    
%     %starts functional brain preprocessing
    bet=0.1; % brain extraction -f parameter    
    filename=preproces_functional4all_spm(subjectdir, file_merge, fsldir, diratlas, bet, sm, fil);   
end

for subj_ct=1:length(subs)
    
    %iterates through all subjects
	subjectdir = char(subs(subj_ct));
    scans_subj=scans(subj_ct,:); 
    filename='swAllScans_unwarp_reorient_fil';
   
    %split the merged epi file into individual scans    
    Ntime=870; prefix='_reg_sm_fil';
    epi_split(subjectdir, [filename '.nii'], scans_subj, prefix, fsldir, Ntime); %the splited scan has the filename [scan '_reg_sm_fil.nii.gz']; 
    cd(subjectdir);

    parfor scan_ct=1:Nscans
        scan=scans_subj(scan_ct);
        disp(scan)      
        filename=[char(scan) prefix]; 
        preprocess_functional_sigreg(subjectdir, filename, gsr, wmcsfr);
%         filename=['s' filename];
        if gsr==1
            ext='gsr';
            filename1=[filename '_' ext];
            preprocess_functional_parcellation_zscore(subjectdir, atlas_filename, filename1, atlas);
        end
        
        if wmcsfr==1
            ext='wmcsfr';
            filename1=[filename '_' ext];
            preprocess_functional_parcellation_zscore(subjectdir, atlas_filename, filename1, atlas)
        end
    end
end
