function epi_split(subjectdir, filename, scans_subj, prefix, fsldir, Ntime)
%filename includes the extension e.g. .nii.gz or .nii
%prefix: e.g., '_reg_sm_fil', '_reg'
cd(subjectdir);
system('pwd');

for scan_num=1:length(scans_subj)
    cmd = [fsldir 'fslroi ' filename ' ' char(scans_subj(scan_num)) ...
        prefix ' ' num2str(Ntime * (scan_num - 1)) ' ' num2str(Ntime)];
    disp(cmd);
    system(cmd);
end
