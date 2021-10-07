# PartialHumanBrain_preprocessing
This is for preprocessing EPI data with human brains with partial coverage
This preprocessing pipeline was developed by Nan Xu and was used to preprocess the visual entrainment data, which has <50% brain coverage.

## I. Pre-requisites: MATLAB (including SPM12), AFNI, FSL
Please have the above pre-installed on your computing server (Linux system). In the default parameter settings, the spm12 folder was saved under the path ./PB_preprocessing/partialbrain_preprocessing_pipeline2020_nx/

## II. Pipeline functions and scripts: ./PB_preprocessing/partialbrain_preprocessing_pipeline2020_nx/
### 1. The main scrip:
./PB_preprocessing/partialbrain_preprocessing_pipeline2020_nx/MainScript_server.m
(*You may need to change the predefined parameters and the folder path ("dirhead") to fit your data*)

###  2. A post FC and histogram analysis is also included:
./PB_preprocessing/partialbrain_preprocessing_pipeline2020_nx/PostAnalysis_FCMap.m

## III. Sample data: ./PB_preprocessing/Data/
Two sample datasets were included. 

## VI. Resources files: ./PB_preprocessing/resources/
1. The field map files of the sample data are included in ./PB_preprocessing/resources/fmap/
 (* These files are for distortion corrections. Please substitute the these files with the correct ones from your imaging sessions.*)
2. Two parcellation atlasses are included: 
a. Schaefer-Yeo 400 parcels (https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/brain_parcellation/Schaefer2018_LocalGlobal)
b. Brainnetome atlas  (https://atlas.brainnetome.org/)



