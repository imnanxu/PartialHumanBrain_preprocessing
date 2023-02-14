# fMRI preprocessing pipeline for partially covered human brains
This preprocessing pipeline was developed by Nan Xu and was used to preprocess EPI human brain data with partial coverage, which has been used in (Xu et al., 2022). EPI scans with >40% brain coverage can be sucessfully preprocessed. This automated pipeline is based around SPM12 (https://www.fil.ion.ucl.ac.uk/spm/software/spm12/), FSL (Jenkinson et al., 2012), and AFNI (Cox, 1996; Cox & Hyde, 1997). Detailed preprocessing procedures were described in (Xu et al., 2022, Section 2.1). In summary, following procedures will be performed. 

First, the anatomical T1 image is spatially normalized to the Montreal Neurological Institute (MNI) atlas. Next, the functional EPI timeseries are concatenated, realigned, and normalized to the MNI atlas. The motion parameters and brain tissue masks (CSF, white matter and grey matter) are also estimated. Third, the normalized EPI data were spatially smoothed, and temporally filtered. Fourth, the EPI data were further regressed by the white matter and CSF signals or the global signals (gray matter, white matter, and CSF). Fifth, the concatenated EPI data was split back to each scan. Sixth, the preprocessed EPI timeseries were extracted from the brain parcels and then z-scored. 


## I. Pre-requisites: MATLAB (including SPM12), AFNI, FSL
Please have the above pre-installed on your computing server (Linux system). Please install spm12 under the Matlab home folder (under 'userpath' in Matlab) following
https://en.wikibooks.org/wiki/SPM/Installation_on_Windows#Preamble.

## II. Pipeline functions and scripts: ./partialbrain_preprocessing_pipeline2020_nx/
### 1. The main scrip to run: MainScript_server.m 
Please modified the necessary parameters in the Parameter Settings section to fit your data

<!-- ###  2. A post FC and histogram analysis also included: PostAnalysis_FCMap.m -->

## III. Data files: ./Data/
Functional MRI datasets for two subjects were provided: ./subject001/ and ./subject002/. Each subject folder will have the following input and output files.
### 1. Required input files: >=1 EPI scans & 1 anatomical scan. 
Sample data includes the following files:

      2 EPI scans: rest.nii, f01.nii (or f03.nii) 
      1 anatomical scan: t1.nii 

You can name your own EPI filenames and specifiy that in the Paramter Settion section in MainScript_sever.m. However, please always rename your anatomical scan to t1.nii.
### 2. Final outputs:

   <!-- The final seed-based extracted EPI timeseries are saved in -->
## VI. Resources files: ./resources/
### 1. The field map files of the sample data are included in ./fmap/
These files are for distortion corrections. Please replace the these files with the correct ones from your imaging sessions.

### 2. Two parcellation atlasses are included: 
   a. Schaefer-Yeo 400 parcels (https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/brain_parcellation/Schaefer2018_LocalGlobal)
   
   b. Brainnetome atlas  (https://atlas.brainnetome.org/)



## References:
Cox, R. W. (1996). AFNI: software for analysis and visualization of functional magnetic resonance neuroimages. Computers and Biomedical research, 29(3), 162-173.

Cox, Robert W., and James S. Hyde. "Software tools for analysis and visualization of fMRI data." NMR in Biomedicine: An International Journal Devoted to the Development and Application of Magnetic Resonance In Vivo 10, no. 4‐5 (1997): 171-178.

Jenkinson, M., Beckmann, C. F., Behrens, T. E., & Woolrich, M. W. 720 Smith SM (2012) FSL. Neuroimage, 62, 782-790.

Xu, N., Smith, D. M., Jeno, G., Seeburger, D. T., Schumacher, E. H., & Keilholz, S. D. (2022). The effect of random and systematic visual stimulation on entrained infraslow quasi-periodic dynamic global waves in human brain activity. bioRxiv, 2022-12.

