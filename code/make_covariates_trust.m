clear all 
close all
clc

%% 

% This code pulls in subjects from newsubs.txt and makes covariates and motion regressors, demeans them and
% generates a spreadsheet for easy copying and pasting into FSL.

% For this code to work, place motion_outliers.csv and ____.csv into your
% code directory. Make sure they are named below.

currentdir = pwd;

subjects_all = readtable('L3subs_trust.txt');
subjects = table2array(subjects_all);
outputdir = [currentdir '/covariates/'];


if exist(outputdir) == 7
    rmdir(outputdir, 's');
    mkdir(outputdir);
else
    mkdir(outputdir); % set name
end

input_behavioral = 'Trust_Full_Covariates-3.xlsx'; % input file  
%motion_input = 'motion_data_input.xls';

%% Motion outliers

% data = readtable(motion_input);
% data = table2array(data);
% 
% motion_data = [];
% 
% % tsnr is second column. motion is third column
% 
% for ii = 1:length(subjects)
%     subj = subjects(ii);
%     subj_row = find(data==subj);
%     save = data(subj_row,:);
%     motion_data = [motion_data;save];
% end
% 
% motion_data_output = array2table(motion_data(1:end,:),'VariableNames', {'Subject', 'tsnr', 'fd_mean'});

%% Covariates

data = readtable(input_behavioral);
%data = table2array(data);

%cov_data = [data.sub, data.oafem, data.oafem_sum, data.score_tei_globaltrait];
cov_data = [data.sub, data.sub_age, data.oafem_total, data.ios_friend_score-data.ios_computer_score, data.ios_friend_score-data.ios_stranger_score];
behavioral_data = [];

% Find subjects

for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(cov_data==subj);
    save = cov_data(subj_row,:);
    behavioral_data = [behavioral_data;save];
end

behavior_test = isnan(behavioral_data);

exclusions_applied = [];
missing_data = [];
subjects_keep=[];

for ii = 1:length(behavior_test)
    saveme = [];
    missing = [];
    row = behavior_test(ii,:);
    test = sum(row) > 0;
    if test == 0
        saveme = behavioral_data(ii,:);
    end

    if test == 1
        missing = behavioral_data(ii,:);
    end

    exclusions_applied = [exclusions_applied;saveme];
    missing_data = [missing_data; missing];
    subjects_keep = [subjects_keep;saveme];
end

%% 

% data.ios_friend_score-data.ios_computer_score      data.ios_friend_score-data.ios_stranger_score

ageXios_fc = [(exclusions_applied(:,2)-mean(exclusions_applied(:,2))) .* (exclusions_applied(:,4)-mean(exclusions_applied(:,4)))];
ageXios_fs = [(exclusions_applied(:,2)-mean(exclusions_applied(:,2))) .* (exclusions_applied(:,5)-mean(exclusions_applied(:,5)))];
ageXOAFEM = [(exclusions_applied(:,2)-mean(exclusions_applied(:,2))) .* (exclusions_applied(:,3)-mean(exclusions_applied(:,3)))];
ageXoafemXios_fc = [(exclusions_applied(:,2)-mean(exclusions_applied(:,2))) .* (exclusions_applied(:,3)-mean(exclusions_applied(:,3))) .* (exclusions_applied(:,4)-mean(exclusions_applied(:,4)))];
ageXoafemXios_fs = [(exclusions_applied(:,2)-mean(exclusions_applied(:,2))) .* (exclusions_applied(:,3)-mean(exclusions_applied(:,3))) .* (exclusions_applied(:,5)-mean(exclusions_applied(:,5)))];

behavioral_data_full = [exclusions_applied, ageXios_fc, ageXios_fs, ageXOAFEM, ageXoafemXios_fc, ageXoafemXios_fs];

demeaned_output_raw = behavioral_data_full(:,2:end) - mean(behavioral_data_full(:,2:end));

demeaned_output = array2table(demeaned_output_raw(1:end,:),'VariableNames', {'age', 'oafem', 'ios_fc', 'ios_fs', 'ageXios_fc', 'ageXios_fs', 'ageXOAFEM', 'ageXoafemXios_fc' , 'ageXoafemXios_fs' });
subject_output = array2table(subjects_keep(1:end, 1),'VariableNames', {'subject'});

%% Makes a ones matrix 

[N,M] = size(demeaned_output);
A(1:N,1) = ones; % subject number

ones_output = array2table(A(1:end,:),'VariableNames', {'ones'});

%% Output file

% NOTE, In the future add motion outliers!!!

final_output_ageXoafemXios = [subject_output(:,'subject'), ones_output(:,'ones'), demeaned_output(:,'age'), demeaned_output(:,'oafem'),  demeaned_output(:,'ios_fc'),  demeaned_output(:,'ios_fs') demeaned_output(:,'ageXios_fc'), demeaned_output(:,'ageXios_fs'), demeaned_output(:,'ageXOAFEM'), demeaned_output(:,'ageXoafemXios_fc'),demeaned_output(:,'ageXoafemXios_fs')];

dest_path = [outputdir, 'rf1_covariates_ageXoafemXios.xls'];
[L] = isfile(dest_path);
if L == 1
    delete(dest_path)
end

name = ('rf1_covariates_ageXoafemXios.xls');
fileoutput = [dest_path];
writetable(final_output_ageXoafemXios, fileoutput); % Save as csv file