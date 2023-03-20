
clear all; close all; clc
%% Parameter Settings
%%%% Setup main directory which hosts /Data, /resources/, and /partialbrain_preprocessing_pipeline2020_nx folders
cd ../
dirhead=pwd; 
% %% install spm12 under the Matlab home folder following
% %% https://en.wikibooks.org/wiki/SPM/Installation_on_Windows#Preamble
addpath([userpath, '/spm12']);

%%%% Setup preprocesing parameters
TR = .7; % EPI scan repitition time
Ntime=100; % number of timepoints for each EPI scan
bet_ant=0.3; bet_epi=0.1; % brain extraction -f parameter for anatomical and for epi scans
funcregtype='spm'; % use spm for the functional registration
sm = 4; % smoothing filter size
fil = [.01, .1]; % temporal filter in Hz
gsr = 1; %turn on "global signal regression"
wmcsfr = 1; %turn on "white matter & CSF  regression"

%%%% Select Atlas from the ./resources folder
diratlas = [dirhead '/resources'];
atlas='schaefer400'; %Schaefer-Yeo2018 400parcels
atlas_filename=[diratlas '/Schaefer2018parcel_Yeo/Schaefer2018_400Parcels_7Networks_order_FSLMNI152_2mm.nii.gz']; 
% atlas='fan246'; %Brainnetome2016 246parcels
% atlas_filename=[diratlas '/Fan2016parcel_Yeo/BN_Atlas_246_2mm.nii.gz']; 

%%%% Setup directories of the subjects
dirdata=dir([dirhead '/Data']);
n_subj_st=find(strcmp({dirdata.name}, 'subject001')==1);
n_subj_ed=find(strcmp({dirdata.name}, 'subject020')==1); %please put the largest subj number here

%%%% Setup scan filenames for each subject; subjects need to have the same
%%%% number of scans
scans={'f01', 'rest'; ... %subj1
       'rest', 'f03'}; %subj2
%% Parameters Loading
%%%% Generates list of subjects to iterate over
subj_ct=0;
for s_row=n_subj_st:n_subj_ed
    subj_ct=subj_ct+1;
    subjs(subj_ct,:) = string([dirdata(s_row).folder, '/', char(dirdata(s_row).name)]);
end
subjs
Nsubjs=length(subjs);
%%%% Adds data path to MATLAB paths
addpath([dirhead '/partialbrain_preprocessing_pipeline2020_nx/'],...
        [dirhead '/partialbrain_preprocessing_pipeline2020_nx/NIfTItoolbox/'])
diary([dirhead '/MATLAB_log_preprocess_' datestr(now,'mmddyy') '.txt']);
fsldir='';
% addpath(diratlas);

%% Parallel Computing for Preprocessing
% delete(gcp('nocreate')); 
% parpool(2,'IdleTimeout', 100000);
% warning off

Nscans=size(scans,2);    
parfor subj_ct=1:length(subjs)    
    %iterates through all subjects
	subjectdir = char(subjs(subj_ct))
    scans_subj=scans(subj_ct,:);
 
%     %starts anatomical brain preprocessing
    preprocess_anatomical_prep(fsldir, subjectdir, bet_ant)
    preprocess_anatomical_maskcreation(fsldir, subjectdir, diratlas);
   
%     %starts the functional scans merging    
    file_merge=epi_merge(fsldir, subjectdir, scans_subj);  %file_merge='AllScans';
     
%     %starts functional brain preprocessing  
    filename=preproces_functional4all_spm(subjectdir, file_merge, fsldir, diratlas, bet_epi, sm);   
end

for subj_ct=1:length(subjs)
    
    %iterates through all subjects
	subjectdir = char(subjs(subj_ct)); disp(subjectdir);
    scans_subj=scans(subj_ct,:);    

    filename='swAllScans_unwarp_reorient'; prefix='_reg_sm';
   
    %split the merged epi file into individual scans    
    epi_split(subjectdir, [filename '.nii'], scans_subj, prefix, fsldir, Ntime); %the splited scan has the filename [scan '_reg_sm_fil.nii.gz']; 
    cd(subjectdir);

    parfor scan_ct=1:Nscans
        scan=scans_subj(scan_ct);
        disp(scan)      
        filename=[char(scan) prefix]; 
        filename=preprocess_functional_filsigreg(subjectdir, filename, fil, gsr, wmcsfr);

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
cd(dirhead)
