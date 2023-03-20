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
filename1=[filename, '.nii.gz'];
cmd=['3dROIstats -mask ' atlas_filename ' -nomeanout -nzmean -quiet ' ...
     filename1 '  > ' filename '_seed_' atlas '.txt']; system(cmd);
ts_parcel=dlmread([filename '_seed_' atlas '.txt'])'; ts_zscore=zscore(ts_parcel,[],2);

cmd=['3dROIstats -mask ' atlas_filename ' -nomeanout -nzvoxels -quiet ' ...
     atlas_filename '  > ' atlas '_voxelNum.txt']; system(cmd); 
voxel_per_roi1=dlmread([atlas '_voxelNum.txt'])';

cmd=['3dROIstats -mask ' atlas_filename ' -nomeanout -nzvoxels -quiet ' ...
     filename1 '[0]  > ' filename '_voxelNum_' atlas '.txt']; system(cmd);
voxel_per_roi2=dlmread([filename '_voxelNum_' atlas '.txt'])';
voxel_per_roi=[voxel_per_roi1, voxel_per_roi2];

save([filename '_on_parcel_' atlas '.mat'],'ts_parcel', 'ts_zscore','voxel_per_roi');
fprintf('Done\n')
