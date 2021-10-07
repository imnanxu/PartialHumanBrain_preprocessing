# PartialHumanBrain_preprocessing
This is for preprocessing EPI data with human brains with partial coverage
This preprocessing pipeline was used to preprocess the visual entrainment data, which has <40% brain coverage.

## Dependencies: SPM12, AFNI, FSL
## Files
1. The pipeline (Matlab scripts and functions): ./PB_preprocessing/partialbrain_preprocessing_pipeline2020_nx/
a. The main script of preprocessing is ./PB_preprocessing/partialbrain_preprocessing_pipeline2020_nx/MainScript_server.m
-You main need to change the predefined parameters and the folder path ("dirhead") to fit your data
b. A post FC and histogram analysis is also included: ./PB_preprocessing/partialbrain_preprocessing_pipeline2020_nx/PostAnalysis_FCMap.m

2. Sample data: ./PB_preprocessing/Data/
Two sample datasets were included. 

