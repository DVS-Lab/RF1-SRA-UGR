clear all 
close all
clc

%% 

% This code pulls in subjects from newsubs.txt and makes covariates and motion regressors, demeans them and
% generates a spreadsheet for easy copying and pasting into FSL.

% For this code to work, place motion_outliers.csv and ____.csv into your
% code directory. Make sure they are named below.

currentdir = pwd;

subjects_all = readtable('L3subs.txt');
subjects = table2array(subjects_all);
outputdir = [currentdir '/covariates/'];


if exist(outputdir) == 7
    rmdir(outputdir, 's');
    mkdir(outputdir);
else
    mkdir(outputdir); % set name
end

input_behavioral = 'SFN_Covariates.xlsx'; % input file  
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

cov_data = [data.sub, data.sub_age, data.fevs_sum, data.mspss_sum];
behavioral_data = [];

% Find subjects

for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(cov_data==subj);
    save = cov_data(subj_row,:);
    behavioral_data = [behavioral_data;save];
end

ageXfevs = [behavioral_data(:,2) .* behavioral_data(:,3)];
ageXmspss = [behavioral_data(:,2) .* behavioral_data(:,4)];
fevsXmspss = [behavioral_data(:,3) .* behavioral_data(:,4)];
ageXfevsXmspss = [behavioral_data(:,2) .* behavioral_data(:,3) .* behavioral_data(:,4)];

behavioral_data_full = [behavioral_data, ageXfevs, ageXmspss, fevsXmspss, ageXfevsXmspss];

behavior_test = isnan(behavioral_data_full);

exclusions_applied = [];
missing_data = [];
subjects_keep=[];

for ii = 1:length(behavior_test)
    saveme = [];
    missing = [];
    row = behavior_test(ii,:);
    test = sum(row) > 0;
    if test == 0
        saveme = behavioral_data_full(ii,:);
    end

    if test == 1
        missing = behavioral_data_full(ii,:);
    end

    exclusions_applied = [exclusions_applied;saveme];
    missing_data = [missing_data; missing];
    subjects_keep = [subjects_keep;saveme];
end

demeaned_output_raw = exclusions_applied(:,2:end) - mean(exclusions_applied(:,2:end));

demeaned_output = array2table(demeaned_output_raw(1:end,:),'VariableNames', {'age', 'fevs', 'mspss', 'ageXfevs', 'ageXmspss', 'fevsXmspss', 'ageXfevsXmspss'});
subject_output = array2table(subjects_keep(1:end, 1),'VariableNames', {'subject'});

%% Makes a ones matrix 

[N,M] = size(demeaned_output);
A(1:N,1) = ones; % subject number

ones_output = array2table(A(1:end,:),'VariableNames', {'ones'});

%% Output file

% NOTE, In the future add motion outliers!!!

final_output_age_only = [subject_output(:,'subject'), ones_output(:,'ones'), demeaned_output(:,'age')];
final_output_agexfevs = [subject_output(:,'subject'), ones_output(:,'ones'), demeaned_output(:,'age'), demeaned_output(:,'fevs'), demeaned_output(:,'ageXfevs')];
final_output_agexfevsxsocial = [subject_output(:,'subject'), ones_output(:,'ones'), demeaned_output(:,'age'), demeaned_output(:,'fevs'),  demeaned_output(:,'mspss'), demeaned_output(:,'ageXfevs'), demeaned_output(:,'ageXmspss'), demeaned_output(:,'fevsXmspss'), demeaned_output(:,'ageXfevsXmspss')];

dest_path = [outputdir, 'rf1_covariates_ageonly.xls'];
[L] = isfile(dest_path);
if L == 1
    delete(dest_path)
end

name = ('rf1_covariates_ageonly.xls');
fileoutput = [dest_path];
writetable(final_output_age_only, fileoutput); % Save as csv file

dest_path = [outputdir, 'rf1_covariates_agexfevs.xls'];
[L] = isfile(dest_path);
if L == 1
    delete(dest_path)
end

name = ('rf1_covariates_ageXfevs.xls');
fileoutput = [dest_path];
writetable(final_output_agexfevs, fileoutput); % Save as csv file

dest_path = [outputdir, 'rf1_covariates_ageXfevsXios.xls'];
[L] = isfile(dest_path);
if L == 1
    delete(dest_path)
end

name = ('rf1_covariates_ageXfevsXsocial.xls');
fileoutput = [dest_path];
writetable(final_output_agexfevsxsocial, fileoutput); % Save as csv file