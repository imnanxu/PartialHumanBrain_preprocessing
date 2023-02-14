function preprocess_functional_sigreg(subjectdir, filename, gsr, wmcsfr)

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
newStr = split(filename,'_'); scan=newStr{1}; %added by NX 06262020
% clear k
% This is simply helping with the text that will be displayed as the
% function is running. 'sub' is a string with the name of the subject that
% will be printed with every update

warning('off','all');

cd(subjectdir);
% fprintf('--------Working on Functional data-----------\n\n')  %commendted out by NX 06262020


%% _______________________Global signal regression_______________________ %
% Conducting global signal regression on the functional data if
% the user asked for it
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub, scan ': ','Functional Global signal regression ... ']) %revised by NX 06262020
if gsr == 1
    nii = load_untouch_nii([filename,'.nii.gz']);
    f = nii.img;
    % Loading the functional scan into Matlab
    
    gsr_mask = load_untouch_nii('bwGlobalSig_mask.nii.gz');
    gsr_mask = gsr_mask.img;
    
    f_gsr = double(f);
    % Predefining the global signal regressed functional scan
    
    for t = 1:size(f,4)
        f_gsr(:,:,:,t) = f_gsr(:,:,:,t) .* gsr_mask;
    end
    % Removing all the gray matter voxels from f_wmcsf
    f_gsr_r = f_gsr;
    
    f_gsr_mean = zeros(1,size(f_gsr,4));
    % Predefining what will be the mean of the functional scan
    for t = 1:size(f,4)
        temp = f_gsr(:,:,:,t);
        temp_sum = sum(temp(:));
        temp_length = length(find(temp(:)));
        temp_mean = temp_sum/temp_length;
        f_gsr_mean(t) = temp_mean;
    end
    % Taking the mean of the functional timeseries. This is the
    % functional timecourse.
    % f_mean_zsc = zscore(f_mean);
    % Z-scoring the mean
    for x = 1:size(f,1)
        for y = 1:size(f,2)
            for z = 1:size(f,3)
                v = double(squeeze(f(x,y,z,:)));
                beta = (f_gsr_mean * f_gsr_mean') \ ...
                    (f_gsr_mean * v);
                f_gsr_r(x,y,z,:) = v' - f_gsr_mean * beta;
            end
        end
    end
    % Regressing the global signal from the functional
    % timeseries
    f = f_gsr_r; 
%     filename = [filename,'_gsr']; % commented out 0626 by NX
    nii.img = f;
    save_untouch_nii(nii,[filename,'_gsr.nii.gz']); % revised 0626 by NX
    % Saving the global signal regressed functional scan
    fprintf('Done\n')
else
    fprintf('Skipped\n')
end
% _______________________________________________________________________ %

%% _________White Matter and CSF signal regression _______________________ % 
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub, ': ','WM/CSF signal regression ... '])
if wmcsfr == 1
    if gsr == 0
        nii = load_untouch_nii([filename,'.nii.gz']);
        f = nii.img;
        % Loading the functional scan
    end
    wm_mask = load_untouch_nii('bwWM_mask_70perc.nii.gz');
    wm_mask = wm_mask.img;
    % Loading white matter mask
    csf_mask = ...
        load_untouch_nii('bwCSF_mask_70perc.nii.gz');
    csf_mask = csf_mask.img;
    % Loading the CSF mask
    wmcsf_mask = double(logical(wm_mask + csf_mask));
    % Creating a mask of the white matter and CSF together and
    % making sure that it is a binary matrix
    f_wmcsf = double(f);
    % Predefining the matrix that will hold just the timeseries
    % from the white matter and CSF 
    for t = 1:size(f,4)
        f_wmcsf(:,:,:,t) = f_wmcsf(:,:,:,t) .* wmcsf_mask;
    end
    % Removing all the gray matter voxels from f_wmcsf
    f_wmcsf_r = f_wmcsf;
    % Predefining the matrix that will be the regressed signal
    % from the white matter and CSF
    f_wmcsf_mean = zeros(1,size(f,4));
    % Predefining what will me the mean of the functional scan
    for t = 1:size(f,4)
        temp = f_wmcsf(:,:,:,t);
        temp_sum = sum(temp(:));
        temp_length = length(find(temp(:)));
        temp_mean = temp_sum/temp_length;
        f_wmcsf_mean(t) = temp_mean;
    end
    % Taking the mean of the wmcsf signal. This is the
    % functional timecourse of the wmcsf.
    % f_wmcsf_mean_zsc = zscore(f_wmcsf_mean);
    % Z-scoring the mean
    for x = 1:size(f,1)
        for y = 1:size(f,2)
            for z = 1:size(f,3)
                v = double(squeeze(f(x,y,z,:)));
                beta = (f_wmcsf_mean*f_wmcsf_mean') ...
                    \ (f_wmcsf_mean * v);
                f_wmcsf_r(x,y,z,:) = ...
                    v' - f_wmcsf_mean * beta;
            end
        end
    end
    % Regressing the white matter and CSF signal from the
    % functional timeseries 
    f = f_wmcsf_r;
    nii.img = f;
    save_untouch_nii(nii,[filename,'_wmcsfr.nii.gz']);
    % Saving the white matter/CSF regressef functiona scan
%     filename = [filename,'_wmcsfr']; % commented out 0626 by NX
    fprintf('Done\n')
else
    fprintf('Skipped\n')
end
% Conducting white matter and CSF signal regression on data in
% case the user specified.
% _______________________________________________________________________ %

