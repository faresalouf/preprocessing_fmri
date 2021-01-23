%% Specify paths and directories

% SPM directory
spmdir = 'D:\Mat_lab\toolbox\spm12';

% Open SPM
%spm fmri

% Add Job directory to path
addpath('D:\Studies\Gaston\scripts_fmri\my_scripts\batch') %% can be changed

% Data directory
studydir = 'D:\Studies\Gaston\fmri_data\test_pilot'; %% can be changed

% Subjects 
subj = {'P01';'P02';'P03';'P04'}; %% can be changed

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
        
        load D:\Studies\Gaston\scripts_fmri\my_scripts\batch\estimate_reslice_job.mat; % Load variable matlabbatch.
        % matlabbatch is a cell that contain a structure. matlabbatch{1} is
        % a structure with fields.
        
        matlabbatch{1}.spm.spatial.realign.estwrite.data{1,1} = funcImages; % Change the data field to
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
        
        
        %%%%% Coregister
       

