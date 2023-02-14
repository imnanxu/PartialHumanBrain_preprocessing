function preprocess_anatomical_maskcreation(fsldir, subjectdir, diratlas)
    warning('off','all');
    cd(subjectdir);
    k = strfind(subjectdir,'subject');
    sub = [subjectdir(k:end),' - ']; 
    clear k

%     fprintf('%=============== Generating Anatomical Masks ===============%\n\n')
    % SPM: Anatomical Brain Extraction & Segmentation & Compute Anatomical to Atlas Transformation _______________ %
    T = datetime('now'); time = whatsthetime(T);
    fprintf([time,sub,'SPM-segment anatomical brain and compute anatomical to atlas transformation ... \n'])
    Dir_anat=[subjectdir '/']; Dir_tmp=[diratlas '/']; 
    filename_anat='t1_reorient_bc.nii'; filename_tmp='TPM.nii';
    gunzip([filename_anat '.gz']);
    matlabbatch_seg=spm_anat_segmentation(Dir_anat, filename_anat, Dir_tmp, filename_tmp);
    spm_jobman('run', matlabbatch_seg); fprintf('Done SPM anatomical preprocessing.\n')
    % _______________________________________________________________ %  

    %% load masks
    nii_gm=load_untouch_nii('c1t1_reorient_bc.nii'); %gray matter
    nii_wm=load_untouch_nii('c2t1_reorient_bc.nii'); %white matter 
    nii_csf=load_untouch_nii('c3t1_reorient_bc.nii'); %csf
    GM=double(nii_gm.img); WM=double(nii_wm.img); CSF=double(nii_csf.img);

    GM_non0=GM(:); GM_non0(GM_non0==0)=[];
    WM_non0=WM(:); WM_non0(WM_non0==0)=[];
    CSF_non0=CSF(:); CSF_non0(CSF_non0==0)=[];

   
    [GM_non0asd,~]=sort(GM_non0,'ascend');
    [WM_non0asd,~]=sort(WM_non0,'ascend');
    [CSF_non0asd,~]=sort(CSF_non0,'ascend');

    thrGM=GM_non0asd(ceil(length(GM_non0)*.3));
    thrWM=WM_non0asd(ceil(length(WM_non0)*.3));
    thrCSF=CSF_non0asd(ceil(length(CSF_non0)*.3));

    GM=double(nii_gm.img); WM=double(nii_wm.img); CSF=double(nii_csf.img);
    mask_Global=GM+WM+CSF;
    mask_Global(mask_Global>0)=1;

    GM(GM<thrGM)=0; GM(GM>=thrGM)=1; 
    WM(WM<thrWM)=0; WM(WM>=thrWM)=1;
    CSF(CSF<thrCSF)=0; CSF(CSF>=thrCSF)=1;

    nii_gm_mask=nii_gm; nii_gm_mask.img=GM;
    nii_wm_mask=nii_wm; nii_wm_mask.img=WM;
    nii_csf_mask=nii_csf; nii_csf_mask.img=CSF;
    nii_globalsig_mask=nii_wm; nii_globalsig_mask.img=mask_Global;

    save_untouch_nii(nii_gm_mask,'GM_mask_70perc.nii'); 
    save_untouch_nii(nii_wm_mask,'WM_mask_70perc.nii'); 
    save_untouch_nii(nii_csf_mask,'CSF_mask_70perc.nii'); 
    save_untouch_nii(nii_globalsig_mask,'GlobalSig_mask.nii');   
    
    T = datetime('now'); time = whatsthetime(T);
    fprintf([time, ': SPM-create WM, CSF & Global Sig masks from anatomical data ... \n'])
    Dir_def=[subjectdir '/']; filename_def='t1_reorient_bc.nii'; vox=2; Dir_app=Dir_def;
    
    filename_app='WM_mask_70perc.nii';
    matlabbatch_nor=spm_func2atlas_normalization(Dir_def, filename_def, Dir_app, filename_app, 1, vox);        
    spm_jobman('run', matlabbatch_nor); fprintf('Done\n')
    
    filename_app='CSF_mask_70perc.nii';
    matlabbatch_nor=spm_func2atlas_normalization(Dir_def, filename_def, Dir_app, filename_app, 1, vox);        
    spm_jobman('run', matlabbatch_nor); fprintf('Done\n')
    
    filename_app='GlobalSig_mask.nii';
    matlabbatch_nor=spm_func2atlas_normalization(Dir_def, filename_def, Dir_app, filename_app, 1, vox);        
    spm_jobman('run', matlabbatch_nor); fprintf('Done\n')
    
    cmd_csf=[fsldir, 'fslmaths wCSF_mask_70perc -bin bwCSF_mask_70perc'];
    cmd_wm=[fsldir, 'fslmaths wWM_mask_70perc -bin bwWM_mask_70perc'];
    cmd_global=[fsldir, 'fslmaths wGlobalSig_mask -bin bwGlobalSig_mask'];
    system(cmd_wm);
    system(cmd_csf);
    system(cmd_global);
    
    %----ending note------------------------
    T = datetime('now'); time = whatsthetime(T);
    fprintf([time,sub,'COMPLETE anatomical mask generation\n'])
    warning('on','all');
    
