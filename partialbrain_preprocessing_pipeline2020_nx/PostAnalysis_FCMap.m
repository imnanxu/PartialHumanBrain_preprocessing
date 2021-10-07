clear all
close all
clc

% dirhead='/projects';
% dirhead='/keilholz-lab/Nan/Preprocessing';
% dirhead='/home/nx25/Documents';


dirhead='/keilholz-lab/Nan/PB_preprocessing';

%adds data path to MATLAB paths
addpath([dirhead '/partialbrain_preprocessing_pipeline2020_nx/'])
addpath([dirhead '/partialbrain_preprocessing_pipeline2020_nx/NIfTItoolbox/']);
addpath(genpath([dirhead '/partialbrain_preprocessing_pipeline2020_nx/afni_matlab/']));
addpath(([dirhead '/partialbrain_preprocessing_pipeline2020_nx/spm12']))
diary([dirhead '/Data/MATLAB_log_PostALY_' datestr(now,'mmddyy') '.txt']);

%% File Path Settings --added by NX 02092020
diratlas_t=[dirhead '/partialbrain_preprocessing_pipeline2020_nx/spm12/'];
diratlas = [dirhead '/partialbrain_preprocessing_pipeline2020_nx/resources'];
% atlas_filename=[diratlas '/Fan2016parcel_Yeo/BN_Atlas_246_2mm.nii.gz']; atlas='fan246';
atlas_filename=[diratlas '/Schaefer2018parcel_Yeo/Schaefer2018_400Parcels_7Networks_order_FSLMNI152_2mm.nii.gz']; atlas='schaefer400';
fsldir='';
% if ismac == 1
%     fsldir = '/Applications/fsl/bin/';
%     setenv('FSLDIR','/Applications/fsl');
%     setenv('FSLOUTPUTTYPE','NIFTI_GZ');
% else
%     fsldir = '/usr/local/fsl/bin/';
%     setenv('FSLDIR','/usr/local/fsl');
%     setenv('FSLOUTPUTTYPE','NIFTI_GZ');
% end

% addpath(diratlas);

%load directories of the subjects
dirdata=dir([dirhead '/Data']);

%below generates list of subjects to iterate over
n_subj_st=find(strcmp({dirdata.name}, 'subject001')==1);
n_subj_ed=find(strcmp({dirdata.name}, 'subject020')==1);
subj_ct=0;
for s_row=n_subj_st:n_subj_ed
    subj_ct=subj_ct+1;
    subs(subj_ct,:) = string([dirdata(s_row).folder, '/', char(dirdata(s_row).name)]);
end
subs

%% Parallel Computing through parfor --added by NX 02092020
% delete(gcp('nocreate'));
% parpool(14,'IdleTimeout', 100000);
% warning off
scans={'f01', 'rest', 'f02', 'f03', 'f04', 'f05', 'f06'; ... %subj1
       'rest', 'f01', 'f02', 'f03', 'f04', 'f05', 'f06'; ... %subj2
       'rest', 'f01', 'f02', 'f03', 'f04', 'f05', 'f06'; ... %subj3
       'rest', 'f01', 'f02', 'f03', 'f04', 'f05', 'f06'; ... %subj4
       'rest', 'f01', 'f02', 'f03', 'f04', 'f05', 'f06'; ... %subj5
       'rest', 'f01', 'f02', 'f03', 'f04', 'f05', 'f06'; ... %subj6
       'rest', 'f01', 'f02', 'f03', 'f04', 'f05', 'f06'; ... %subj7
       'rest', 'f01', 'f02', 'f03', 'f04', 'f05', 'f06'; ... %subj10
       'rest', 'f01', 'f02', 'f03', 'f04', 'f05', 'f06'; ... %subj13
       'rest', 'f01', 'f02', 'f03', 'f04', 'f05', 'f06'; ... %subj15
       'rest', 'f01', 'f02', 'f03', 'f04', 'f05', 'f06'; ... %subj16
       'rest', 'f01', 'f02', 'f03', 'f04', 'f05', 'f06'; ... %subj17
       'rest', 'f01', 'f02', 'f03', 'f04', 'f05', 'f06'; ... %subj19
       'f04', 'rest', 'f01', 'f02', 'f03', 'f05', 'f06'}; %subj20
   subjIDs=[1,2,3,4,5,6,7,10,13,15,16,17,19,20];
   
   
   %%%%2016 Fan 246
%     parcelname='fan246';
%     Nroi=246;
%     net_id={'Subcortical', 'Visual', 'SM', 'DA', 'VA', 'Limbic', 'FP', 'Default'};
%     net_id_sh={'SC', 'V', 'SM', 'DA', 'VA', 'L', 'FP', 'D'};
%     net_st=[0, 40, 74, 107, 137, 159, 185, 211, 246];    
%     F2Y=[6;4;7;6;7;7;3;3;2;2;7;6;7;7;4;6;6;6;6;6;6;6;7;6;3;3;5;6;6;3;6;6;7;7;7;6;4;4;4;4;7;7;7;7;5;6;5;5;5;5;7;7;2;2;3;3;2;2;2;2;4;4;3;3;4;2;2;2;5;5;2;2;2;2;2;2;5;5;7;7;7;6;7;7;3;3;7;7;5;5;3;3;5;5;7;5;3;3;6;6;5;5;5;5;1;1;3;1;5;5;5;1;1;1;5;5;5;5;1;1;7;7;4;4;3;3;3;3;3;3;2;2;3;3;1;1;6;6;3;3;7;6;3;7;2;2;6;6;2;3;1;1;7;7;2;2;2;2;3;2;2;2;2;2;0;6;4;4;4;4;2;2;4;4;7;7;0;0;7;4;7;1;4;4;4;4;7;7;1;1;1;1;1;1;1;1;1;1;1;1;3;1;1;1;1;1;1;1;1;1;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];    
%     lb=41; 
    
    %%%%2018 Shaeffer 400
    parcelname='shaeffer400';
    Nroi=400;
    F2Y=[0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;4;4;4;4;4;4;4;4;4;4;4;4;4;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;2;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;4;4;4;4;4;4;4;4;4;4;4;4;4;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6;6];
    net_st=[0, 61, 138, 184, 231, 257, 309, 400];    
    net_id={'Visual', 'SM', 'DA', 'VA', 'Limbic', 'FP', 'Default'};
    net_id_sh={'V', 'SM', 'DA', 'VA', 'L', 'FP', 'D'};
    filename_gsr=['rest_reg_sm_fil_gsr_on_parcel_' atlas '.mat'];
    filename_wmcsfr=['rest_reg_sm_fil_wmcsfr_on_parcel_' atlas '.mat'];
    lb=0;
   
    
   tick_pos=diff(net_st)/2+net_st(1:end-1);  
    
   parcel_differences=zeros(Nroi,length(subs)+1);
   
    
%    restdata_gsr=cell(length(subs),1);
%    restdata_wmcsfr=cell(length(subs),1);

AllScans={'rest','f01','f02','f03','f04','f05','f06'};   
ts_zscore_gsr=cell(length(subs),length(AllScans));
ts_zscore_sort_gsr=cell(length(subs),length(AllScans));
ts_zscore_wmcsfr=cell(length(subs),length(AllScans));
ts_zscore_sort_wmcsfr=cell(length(subs),length(AllScans));
for subj_ct=1:length(subs)
    
    %iterates through all subjects
	subjectdir = char(subs(subj_ct));
    subj_id=subjIDs(subj_ct);    

    
%     filename_gsr='rest_reg_sm_fil_gsr_on_parcel_fan246.mat';
%     filename_wmcsfr='rest_reg_sm_fil_wmcsfr_on_parcel_fan246.mat';
    
    cd(subjectdir);
    for scan_ct=1:7
        filename_gsr=['s' AllScans{scan_ct} '_reg_fil_gsr_on_parcel_' atlas '.mat'];
        filename_wmcsfr=['s' AllScans{scan_ct} '_reg_fil_wmcsfr_on_parcel_' atlas '.mat'];
   
        load(filename_gsr); ts_zscore=[F2Y, ts_zscore]; ts_zscore_sort=sortrows(ts_zscore,1);
        ts_zscore_sort_gsr{subj_ct,scan_ct}=ts_zscore_sort;
        ts_zscore_gsr{subj_ct,scan_ct}=ts_zscore;
%         eval(['ts_zscore_gsr' num2str(subj_id) '=ts_zscore_sort;']);
    %     restdata_gsr{subj_ct}=ts_zscore_sort(:,2:end);
        if scan_ct==1
            parcel_differences(:,1)=voxel_per_roi(:,1);   
            parcel_differences(:,1+subj_ct)=voxel_per_roi(:,2);
        end
        
        f1=figure(1);
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        subplot(2,4,scan_ct); corrMap=corr(ts_zscore_sort(:,2:end)'); corrMap(corrMap==1)=0;
        imagesc(corrMap);  
        title(['gsr: subj' num2str(subj_id) ': ' AllScans{scan_ct}]); axis equal; axis tight
        caxis([-1 1]); colormap(jet); hold on; 
        for i=2:8
            plot([0 Nroi],[net_st(i) net_st(i)],'k'); 
            plot([net_st(i) net_st(i)],[0 Nroi],'k'); 
        end
        set(gca,'XTick',tick_pos,'XTickLabel',net_id_sh,'YTick',tick_pos,'YTickLabel',net_id_sh);  
        axis([lb Nroi lb Nroi])

        f3=figure(3);
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        subplot(2,4,scan_ct); histogram(corrMap(:),50); 
        title(['gsr: subj' num2str(subj_id) ': ' AllScans{scan_ct}]); axis([-1 1 0 12000])

        load(filename_wmcsfr); ts_zscore=[F2Y, ts_zscore]; ts_zscore_sort=sortrows(ts_zscore,1);        
        ts_zscore_sort_wmcsfr{subj_ct,scan_ct}=ts_zscore_sort;
        ts_zscore_wmcsfr{subj_ct,scan_ct}=ts_zscore;
%         eval(['ts_zscore_wmcsfr' num2str(subj_id) '=ts_zscore_sort;']);
    %     restdata_wmcsfr{subj_ct}=ts_zscore_sort(:,2:end);

        f2=figure(2);
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        subplot(2,4,scan_ct); corrMap=corr(ts_zscore_sort(:,2:end)'); corrMap(corrMap==1)=0;
        imagesc(corrMap);  
        title(['wmcsfr: subj' num2str(subj_id) ': ' AllScans{scan_ct}]); axis equal; axis tight
        caxis([-1 1]); colormap(jet); hold on; 
        for i=2:8
            plot([0 Nroi],[net_st(i) net_st(i)],'k'); 
            plot([net_st(i) net_st(i)],[0 Nroi],'k'); 
        end
        set(gca,'XTick',tick_pos,'XTickLabel',net_id_sh,'YTick',tick_pos,'YTickLabel',net_id_sh); 
        axis([lb Nroi lb Nroi])

        f4=figure(4); 
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        subplot(2,4,scan_ct); histogram(corrMap(:),50); 
        title(['wmcsfr: subj' num2str(subj_id) ': ' AllScans{scan_ct}]); axis([-1 1 0 12000])        
    end 
    saveas(f1,['../Figures/' parcelname '_subj' num2str(subj_id) '_corr_gsr.fig']);
    saveas(f2,['../Figures/' parcelname '_subj' num2str(subj_id) '_corr_wmcsfr.fig']);
    saveas(f3,['../Figures/' parcelname '_subj' num2str(subj_id) '_hist_gsr.fig']);
    saveas(f4,['../Figures/' parcelname '_subj' num2str(subj_id) '_hist_wmcsfr.fig']);

    
    saveas(f1,['../Figures/' parcelname '_subj' num2str(subj_id) '_corr_gsr.tif']);
    saveas(f2,['../Figures/' parcelname '_subj' num2str(subj_id) '_corr_wmcsfr.tif']);
    saveas(f3,['../Figures/' parcelname '_subj' num2str(subj_id) '_hist_gsr.tif']);
    saveas(f4,['../Figures/' parcelname '_subj' num2str(subj_id) '_hist_wmcsfr.tif']);
% pause
    close all
    disp(['subject ' num2str(subj_id) ' is completed!']);
end


parcel_differences0=[F2Y, parcel_differences];
parcel_differences0=sortrows(parcel_differences0,1);
parcel_differences0=parcel_differences0(:,2:end);

h=figure;
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
subplot(121)
imagesc(parcel_differences0); title('parcel size differences')
colormap(gca, 'jet'); colorbar; hold on
for i=2:8
        plot([0 Nroi],[net_st(i) net_st(i)],'k','LineWidth',2);         
end
for i=2:15
     plot([i-.5, i-.5], [0 Nroi],'k','LineWidth',1);
end
set(gca,'YTick',tick_pos,'YTickLabel',net_id_sh, 'XTick',[1:15],'XTickLabel', {'GT', 's1', 's2', 's3', 's4', 's5', 's6', 's7', 's10', 's13', 's15', 's16', 's17', 's19', 's20'}); 

parcel_smallerthanhalf=zeros(Nroi,length(subs));
thr=.85;
for i=1:Nroi
   for j=1:length(subs)
       if parcel_differences0(i,j+1)<parcel_differences0(i,1)*thr
           parcel_smallerthanhalf(i,j)=1;           
       end
   end
end

subplot(122)
imagesc(parcel_smallerthanhalf); title(['smaller than ' num2str(thr) ' of atlas parcels'])
colormap(gca, flipud(hot)); colorbar; hold on
for i=2:8
        plot([0 Nroi],[net_st(i) net_st(i)],'r','LineWidth',2);         
end
for i=2:15
     plot([i-.5, i-.5], [0 Nroi],'r','LineWidth',1);
end
set(gca,'YTick',tick_pos,'YTickLabel',net_id_sh, 'XTick',[1:14],'XTickLabel', {'s1', 's2', 's3', 's4', 's5', 's6', 's7', 's10', 's13', 's15', 's16', 's17', 's19', 's20'}); 
saveas(h,['../Figures/' parcelname '_rest_voxel_per_parcels.tif']);
saveas(h,['../Figures/' parcelname '_rest_voxel_per_parcels.fig']);
save(['Results_zscore_' parcelname '.mat']);

%% paper parcel coverage percentage
parcel_differencest=parcel_differences; 
for i=1:Nroi
   parcel_differencest(i,:)=parcel_differences(i,:)./parcel_differences(i,1);
end

parcel_differences1=[F2Y, parcel_differencest];
parcel_differences1=sortrows(parcel_differences1,1);
parcel_differences1=parcel_differences1(:,2:end);

h=figure;
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
subplot(121); parcel_differences1(:,1)=[]; parcel_differences1(:,4)=[];
imagesc(parcel_differences1); title('percetage of parcel coverage')
colormap(gca, 'jet'); colorbar; hold on
for i=2:7
        plot([0 Nroi],[net_st(i) net_st(i)],'c','LineWidth',2);         
end
for i=2:15
     plot([i-.5, i-.5], [0 Nroi],'k','LineWidth',1);
end
set(gca,'YTick',tick_pos,'YTickLabel',net_id_sh, 'XTick',[1:13],'XTickLabel', {'s1', 's2', 's3', 's5', 's6', 's7', 's10', 's13', 's15', 's16', 's17', 's19', 's20'}); 
colormap(gca, flipud(hot));

parcel_smallerthanhalf=zeros(Nroi,length(subs));
for i=1:Nroi
   for j=1:length(subs)
       if parcel_differences0(i,j+1)<parcel_differences0(i,1)*.85;
           parcel_smallerthanhalf(i,j)=1;           
       end
   end
end

subplot(122); parcel_smallerthanhalf(:,10)=[];
imagesc(parcel_smallerthanhalf); title('smaller than 85% of atlas parcels')
colormap(gca, flipud(hot)); colorbar; hold on
for i=2:7
        plot([0 Nroi],[net_st(i) net_st(i)],'r','LineWidth',2);         
end
for i=2:15
     plot([i-.5, i-.5], [0 Nroi],'r','LineWidth',1);
end
set(gca,'YTick',tick_pos,'YTickLabel',net_id_sh, 'XTick',[1:13],'XTickLabel', {'s1', 's2', 's3', 's5', 's6', 's7', 's10', 's13', 's15', 's16', 's17', 's19', 's20'}); 
% saveas(h,['../Figures/' parcelname '_rest_voxel_per_parcels.tif']);
% saveas(h,['../Figures/' parcelname '_rest_voxel_per_parcels.fig']);
