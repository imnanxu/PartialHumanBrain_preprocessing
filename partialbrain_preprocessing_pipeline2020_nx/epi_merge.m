%% ________Merge functional scans from different sessions____________ %
function file_merge=epi_merge(fsldir, subjectdir, scans)


k = strfind(subjectdir,'subject');
sub = [subjectdir(k:end),' - ']; 
cd(subjectdir);

T = datetime('now'); time = whatsthetime(T);
fprintf([time, sub, ': ','Merge all nii files ... '])
cmd=[fsldir, 'fslmerge -t AllScans.nii.gz'];
for scan_ct=1:length(scans)           
    cmd=[cmd ' ' scans{scan_ct} '.nii'];        
end
system(cmd);  fprintf('Done\n')    
file_merge='AllScans';

