%Scipt permettant d'extraire les onsets à partir de fichiers '.txt', '.res', etc.
%Utiliser la fonction xlsread pour du format '.xls' ou '.csv'

%% Définir les paths
addpath('D:\Studies\Gaston\fmri_data\test_pilot'); % Path pour le dossier qui contient les participants
addpath('D:\data_science\matlab_data\functions'); % Path pour le dossier qui contient les scripts
cd('D:\Studies\Gaston\fmri_data\test_pilot') % Aller vers le dossier qui contient les participants

%% Créer le path pour les sujets
% La fonction spm_select permet d'ouvrir l'interface de selection de
% fichier de spm. Elle est pratique parce qu'elle nous permet de selection
% plusieurs fichiers d'un coup. Nous allons selectionner TOUS les fichiers
% des participants dont on a besoin.
% Le résultat sera une matrice de character arrays.

subjectdir = spm_select(inf,'dir','select all participants directories'); % -inf: allows to select any
% number of files. -dir: specify that the selected files will be a
% directories. -'select all ...' is a custom message.