function preprocess_functional_parcellation_zscore(subjectdir, atlas_filename, filename, atlas)

k = strfind(subjectdir,'subject');
sub = [subjectdir(k:end),' - ']; 
% clear k
% This is simply helping with the text that will be displayed as the
% function is running. 'sub' is a string with the name of the subject that
% will be printed with every update

warning('off','all');
cd(subjectdir);
newStr = split(filename,'_');
scan=newStr{1};
T = datetime('now'); time = whatsthetime(T);
fprintf([time,sub, scan ': ','Functional Parcellation & Zcoring ... '])

%% Parcellation & Z-scoring   
nii_tmp=load_untouch_nii(atlas_filename);
TMP=nii_tmp.img; ROI_ids=unique(TMP(:));
 
filename1=[filename, '.nii.gz'];

% cmd=['3dROIstats -mask ' atlas_filename ' -nomeanout -nobriklab -nzmean -quiet ' ...
%      filename1 '  > ' filename '_seed_' atlas '.txt'];
% system(cmd);

nii_img=load_untouch_nii(filename1);
IMG0=nii_img.img; %IMG_parcel=zeros(size(IMG0)); IMG_zscore=zeros(size(IMG0));
Ntime=size(IMG0,4);

ts_parcel=zeros(length(ROI_ids)-1,Ntime);
ts_zscore=zeros(length(ROI_ids)-1,Ntime);

voxel_per_roi1=zeros(length(ROI_ids)-1,1);
voxel_per_roi2=zeros(length(ROI_ids)-1,1);
parfor roi_ct=1:length(ROI_ids)-1
   mask_roi=zeros(size(TMP));
   roi=ROI_ids(roi_ct+1);
   mask_roi(TMP==roi)=1;
   voxel_per_roi1(roi_ct)=length(nonzeros(mask_roi));
   
   IMG_masked=bsxfun(@times, mask_roi, IMG0);
   v_roi = nonzeros(IMG_masked(:,:,:,1));  
   voxel_per_roi2(roi_ct)=length(v_roi);
   IMG_masked_2D=reshape(nonzeros(IMG_masked),[voxel_per_roi2(roi_ct), Ntime]);
   ts_parcel(roi_ct,:)=mean(IMG_masked_2D,1);      
   ts_zscore(roi_ct,:) = zscore(ts_parcel(roi_ct,:));   
end
voxel_per_roi=[voxel_per_roi1, voxel_per_roi2];
save([filename '_on_parcel_' atlas '.mat'],'ts_parcel', 'ts_zscore','voxel_per_roi');
fprintf('Done\n')
