# PartialHumanBrain_preprocessing
This is for preprocessing EPI data with human brains with partial coverage
This preprocessing pipeline was used to preprocess the visual entrainment data, which has <40% brain coverage.

## Dependencies: SPM12, AFNI, FSL
## I. Files
### 1. The pipeline (Matlab scripts and functions): ./PB_preprocessing/partialbrain_preprocessing_pipeline2020_nx/
The main script of preprocessing is ./PB_preprocessing/partialbrain_preprocessing_pipeline2020_nx/MainScript_server.m
(*You may need to change the predefined parameters and the folder path ("dirhead") to fit your data*)

###  2. A post FC and histogram analysis is also included: ./PB_preprocessing/partialbrain_preprocessing_pipeline2020_nx/PostAnalysis_FCMap.m

## II. Sample data: ./PB_preprocessing/Data/
Two sample datasets were included. 

## III. Resources files: ./PB_preprocessing/resources/
1. The field map files of the sample data are included in ./PB_preprocessing/resources/fmap/
 (* These files are for distortion corrections. Please substitute the these files with the correct ones from your imaging sessions.*)
2. Two parcellation atlasses are included: 
a. Schaefer-Yeo 400 parcels (https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/brain_parcellation/Schaefer2018_LocalGlobal)
b. Brainnetome atlas  (https://atlas.brainnetome.org/)



