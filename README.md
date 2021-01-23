# Preprocessing_fmri
This script will allow you to accomplish usual preprocessing steps (Realignement, Slice-timing, Coregistration, Segmentation, Normalization and Smoothing) for functional magnetic resonance (fMRI) images in an automated way.  
  
  It is based on SPM toolbox that runs on MATLAB.  
    
## The logic behind spm scripting
 SPM uses a batch editor that allows to implement each step (or multiple steps) for as many Sessions (runs) as we would like.  
   
It also allows us to save the batch as a matlab cell (matlabbatch) that contains a structure.  

The general idea is to modify the fields of the structure and adapt it to new data.
