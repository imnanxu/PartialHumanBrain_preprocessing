# fMRI preprocessing pipeline for partially covered human brains
This preprocessing pipeline was developed by Nan Xu and was used to preprocess EPI human brain data with partial coverage, which has been used in (Xu et al., 2022). EPI scans with >40% brain coverage can be sucessfully normalized to the MNI space and preprocessed. This automated pipeline is based around SPM12 (https://www.fil.ion.ucl.ac.uk/spm/software/spm12/), FSL (Jenkinson et al., 2012), and AFNI (Cox, 1996; Cox & Hyde, 1997). Detailed preprocessing procedures were described in (Xu et al., 2022, Section 2.1). In summary, following procedures will be performed. 

First, the anatomical T1 image is spatially normalized to the Montreal Neurological Institute (MNI) atlas. Next, the functional EPI timeseries are concatenated, realigned, and normalized to the MNI atlas. The motion parameters and brain tissue masks (CSF, white matter and grey matter) are also estimated. Third, the normalized EPI data were spatially smoothed, and temporally filtered. Fourth, the EPI data were further regressed by the white matter and CSF signals or the global signals (gray matter, white matter, and CSF). Fifth, the concatenated EPI data was split back to each scan. Sixth, the preprocessed EPI timeseries were extracted from the brain parcels and then z-scored. 


## I. Pre-requisites: MATLAB (including SPM12), AFNI, FSL
Please have the above pre-installed on your computing server (Linux system). Please install spm12 under the Matlab home folder (under 'userpath' in Matlab) following
https://en.wikibooks.org/wiki/SPM/Installation_on_Windows#Preamble.

## II. Resources files: ./resources/
### 1. ./resources/fmap/: field map files of the sample data
These files are for distortion corrections. Please replace the these files with the ones from your imaging sessions.

### 2. Parcellation atlas files:
Two parcellation atlases are included:

   a. Schaefer-Yeo 400 parcels (https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/brain_parcellation/Schaefer2018_LocalGlobal)
   
   b. Brainnetome atlas  (https://atlas.brainnetome.org/)

You could choose either atlas in MainScript_sever.m (described below) for the timeseries extraction. You could also add your own parcellation atlas files here and specify the atlas filename in MainScript_sever.m.

## III. Pipeline functions and scripts: ./partialbrain_preprocessing_pipeline2020_nx/
### 1. Main script: MainScript_server.m 
Please modified the necessary parameters in the Parameter Settings section for your data.

<!-- ###  2. A post FC and histogram analysis also included: PostAnalysis_FCMap.m -->

## IV. Data files: ./Data/
Functional MRI datasets for two subjects were provided: ./subject001/ and ./subject002/. Each subject folder will have the following input and output files.
### 1. Required input files: >=1 EPI scans & 1 anatomical scan. 
Sample data includes the following files:

      2 EPI scans: rest.nii, f01.nii (or f03.nii) 
      1 anatomical scan: t1.nii 

You can name your own EPI filenames and specifiy that in the Paramter Settion section in MainScript_sever.m. However, please always rename your anatomical scan to t1.nii.
### 2. Preprocessing steps & Outputs:
| Data under preprocessing | Precessing steps |    Key output files   |
|--------------------------|-----------------|--------------|
| Anatomical scan          | reorientation   | t1_reorient  |
|                          | bias correction | t1_reorient_bc |
|                          | brain extraction | t1_reorient_bet |
|                          | tissue segmentation |c1t1_reorient_bc (grey matter), c2t1_reorient_bc (white matter), c3t1_reorient_bc (csf)|
|                          | mask generation |  WM_mask_70perc (white matter mask), CSF_mask_70perc (white matter mask), GlobalSig_mask (whole brain mask) |
|                          | mask registration (to MNI space) |  wWM_mask_70perc (white matter mask), wCSF_mask_70perc (white matter mask), wGlobalSig_mask (whole brain mask) |
| Functional EPI scans     | scans concatenation/subject | AllScans  |
|                          | fieldmap correction   | AllScans_unwarp  |
|                          | reorientation   | AllScans_unwarp_reorient  |
|                          | motion estimation | AllScans_unwarp_reorient |
|                          | bias correction on the 1st volume | AllScans_unwarp_reorient_bc |
|                          | brain extraction on the 1st volume | AllScans_unwarp_reorient_bc_bet |
|                          | functional registration to all volumnes | wAllScans_unwarp_reorient |
|                          | spatial smoothing |  swAllScans_unwarp_reorient |
|                          | termporal filtering |  swAllScans_unwarp_reorient_fil |
|                          | termporal filtering |  swAllScans_unwarp_reorient_fil |
|                          | split back to individual scans | `scan` \_reg_sm_fil |
|                          | signal regression | `scan` \_reg_sm_fil_gsr (preprocessed 4D EPI data with global signal regression); `scan` \_reg_sm_fil_wmcsf (preprocessed 4D EPI data with WM&CSF regression) |
|                          | parcellation and z-scoring | `scan` \_reg_sm_fil_gsr_on_parcel_`atlas name`.mat or/and `scan` \_reg_sm_fil_wmcsf_on_parcel_`atlas name`.mat. |

In the final preprocessing step, 3 variables are saved in each .mat file: ts_parcel (a 2D matrix of extracted timeseries from selected atlas), ts_zscore (a 2D matrix of z-scored timeseries from selected atlas), and voxel_per_roi (a 2-column matrix including the number of voxels per parcel). Note that the EPI scan might be only partially covered, some parcels from the selected atlas might not be fully covered by the EPI data. For the voxel_per_roi variable, the 1st column includes the ground truth number of voxels in each parcel (calculated from the atlas file), and the 2nd column includes the experical number of voxels in each parcel (calculated from the EPI scan).

## References:
Cox, R. W. (1996). AFNI: software for analysis and visualization of functional magnetic resonance neuroimages. Computers and Biomedical research, 29(3), 162-173.

Cox, Robert W., and James S. Hyde. "Software tools for analysis and visualization of fMRI data." NMR in Biomedicine: An International Journal Devoted to the Development and Application of Magnetic Resonance In Vivo 10, no. 4‐5 (1997): 171-178.

Jenkinson, M., Beckmann, C. F., Behrens, T. E., & Woolrich, M. W. 720 Smith SM (2012) FSL. Neuroimage, 62, 782-790.

Xu, N., Smith, D. M., Jeno, G., Seeburger, D. T., Schumacher, E. H., & Keilholz, S. D. (2022). The effect of random and systematic visual stimulation on entrained infraslow quasi-periodic dynamic global waves in human brain activity. bioRxiv, 2022-12.

