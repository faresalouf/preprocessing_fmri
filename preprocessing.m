%% Specify paths and directories

% SPM directory
spmdir = 'D:\Mat_lab\toolbox\spm12';

% Open SPM
spm fmri

% Add Job directory to path
addpath('D:\Studies\Gaston\scripts_fmri\my_scripts\batch') %% can be changed

% Data directory
studydir = 'D:\Studies\Gaston\fmri_data\test_pilot'; %% can be changed

% Subjects 
subj = {'P04'}; %% can be changed

% Data within subject's directory
data = 'fmri'; %% can be changed

% Runs directory
run = {'run1';'run2';'run3';'run4'}; %% can be changed

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create subject directory, run directory, structural directory
for i=1:length(subj) % loop across subjects
    for k=1:length(run) % loop across runs
        subjX = subj{i};% subjX will be a character
        subjdir = fullfile(studydir,subjX); % Create a directory for each subject
        rundir = fullfile( subjdir,data,run{k} ); %  Create a directory for each run of each subject
        structdir = fullfile(subjdir,data,'T1'); % Create a directory for the structural image
        
        %%%%% Realign and estimate
        cd(rundir) % go to run directory
        clear matlabbatch % remove variable matlabbatch from workspace
        funcImages = dir( fullfile(rundir,'f*.nii') ); % List in a structure array all the
        % functional images to be realigned.
        
        for j=1:length(funcImages)
            funcImagesX(j,:) = [rundir,'\', funcImages(j).name]; % funcImagesX is a character array that 
            % will contain the path to each functional image
        end
        
        funcImages = cellstr(funcImagesX); % funcImages is now a cell array of character vectors 
        % that are the path to each functional image; it allows to
        % encapsulate each file path in one cell as a character vectors
        clear funcImagesX % remove from workspace
        
        load D:\Studies\Gaston\scripts_fmri\my_scripts\batch\realignment_job.mat; % Load variable matlabbatch.
        % matlabbatch is a cell that contain a structure. matlabbatch{1} is
        % a structure with fields.
        
        matlabbatch{1}.spm.spatial.realign.estwrite.data{1,1}= funcImages; % Change the data field to
        % the data of interest
        
        spm_jobman('run', matlabbatch);
        
        
         %SLICE TIMING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %         cd(rundir)
        %         scanSLT = dir (fullfile(rundir, 'rsn*.nii')); % adds an 'a' prefix -> arsn*
        %         for j=1:length(scanSLT)
        %             scanSLTX(j,:)=[rundir,'\',scanSLT(j).name];
        %         end
        %         scanSLT = cellstr(scanSLTX);
        %         clear scanSLTX
        %
        %         load D:\Leo6_ZH\FMRI_results\jobs\SLT.mat;
        %         cd(rundir)
        %         matlabbatch{1}.spm.temporal.st.scans = scanSLT;
        %         spm_jobman ('run', matlabbatch)
        
        
        %%%%% Coregisteration
        cd(rundir)
        clear matlabbatch
        scanCO1 = dir( fullfile(rundir,'meanf*.nii') ); % Get the reference scan information in a structure
        scanCO1 = [rundir,'\',scanCO1.name]; % Get the path to my mean functional image
        scanCO1 = cellstr(scanCO1); % Convert the path (character vector) to a cell containing a character vector
        
        cd(structdir)
        scanCO2 = dir ( fullfile(structdir, 's*.nii') ); % Get the T1 scan info in a structure
        scanCO2 = [structdir,'\',scanCO2.name]; % Get the path to my structural image
        scanCO2 = cellstr(scanCO2);
        
        load D:\Studies\Gaston\scripts_fmri\my_scripts\batch\coregistration_job.mat % load matlabbatch var
        cd(rundir)
        matlabbatch{1}.spm.spatial.coreg.estimate.ref = scanCO1;
        matlabbatch{1}.spm.spatial.coreg.estimate.source = scanCO2;
        spm_jobman('run', matlabbatch);
        
        %%%%% Segmentation
        
        cd(rundir)
        clear matlabbatch
        scanSE = dir( fullfile(structdir,'s*.nii') );
        scanSE = [structdir,'\',scanSE.name];
        scanSE = cellstr(scanSE);
        
        load D:\Studies\Gaston\scripts_fmri\my_scripts\batch\segmentation_job.mat;
        cd(rundir)
        matlabbatch{1}.spm.spatial.preproc.channel.vols = scanSE;
        spm_jobman('run', matlabbatch)
        
        %%%%% Normalization
        
        % Get the deformation field
        clear matlabbatch
        cd(structdir)
        scanT1 = dir( fullfile(structdir,'s*.nii') );
        scanT1 = [structdir,'\',scanT1.name];
        scanT1 = cellstr(scanT1);
        
        % Get the realigned functional images to write
        cd(rundir)
        images2write = dir( fullfile(rundir,'rf*.nii') ); % We now have a structure with many elements
        
        % Loop through each element and get the name of it in a character
        % array
        
       for j=1:length(images2write)
           images2writeX(j,:)= [rundir,'\',images2write(j).name];
       end
       
      images2write = images2writeX;
      images2write = cellstr(images2write);
      clear images2writeX
      
      load D:\Studies\Gaston\scripts_fmri\my_scripts\batch\normalization_job.mat
      matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = scanT1;
      matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = images2write;
      spm_jobman('run', matlabbatch);
      
       
       %%%%% Smoothing
       clear matlabbatch
       scanSMOOTH = dir( fullfile(rundir, 'wrf*.nii') );
       for j=1:length(scanSMOOTH)
           scanSMOOTHX(j,:)=[rundir,'\',scanSMOOTH(j).name];
       end
       
       scanSMOOTH = cellstr(scanSMOOTHX);
       clear scanSMOOTHX
       
       load D:\Studies\Gaston\scripts_fmri\my_scripts\batch\smoothing_job.mat;
       cd (rundir)
       matlabbatch{1}.spm.spatial.smooth.data = scanSMOOTH;
       matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8];
       matlabbatch{1}.spm.spatial.smooth.dtype = 0;
       matlabbatch{1}.spm.spatial.smooth.im = 0;
       matlabbatch{1}.spm.spatial.smooth.prefix = 'S';
       spm_jobman('run', matlabbatch);
       
    end
end

      
       
       
       
       
       
       
       
       
       
       
       
       
       
      
           
           
           
           
           
           
           
        
        
        
        
        
        
        
        
        
       

