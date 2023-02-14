# PartialHumanBrain_preprocessing
This is for preprocessing EPI human brain data with partial coverage.
This preprocessing pipeline was developed by Nan Xu and was used to preprocess the visual entrainment data, which has <50% brain coverage.

## I. Pre-requisites: MATLAB (including SPM12), AFNI, FSL
Please have the above pre-installed on your computing server (Linux system). Please install spm12 under the Matlab home folder (under 'userpath' in Matlab) following
https://en.wikibooks.org/wiki/SPM/Installation_on_Windows#Preamble.

## II. Pipeline functions and scripts: ./partialbrain_preprocessing_pipeline2020_nx/
### 1. The main scrip to run: MainScript_server.m 
Please modified the necessary parameters in the Parameter Settings section to fit your data

###  2. A post FC and histogram analysis also included: PostAnalysis_FCMap.m

## III. Data files: ./Data/
Functional MRI datasets for two subjects were included: ./subject001/ and ./subject002/. Each subject folder will have the following input and output files.
### 1. Input files: 
      2 EPI scans: rest.nii, f01.nii (or f03.nii)
      1 T1 scan: t1.nii   
### 2. Final output data:
   
The final seed-based extracted EPI timeseries are saved in 

## VI. Resources files: ./resources/
### 1. The field map files of the sample data are included in ./fmap/
These files are for distortion corrections. Please replace the these files with the correct ones from your imaging sessions.

### 2. Two parcellation atlasses are included: 
   a. Schaefer-Yeo 400 parcels (https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/brain_parcellation/Schaefer2018_LocalGlobal)
   
   b. Brainnetome atlas  (https://atlas.brainnetome.org/)



