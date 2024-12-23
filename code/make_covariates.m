clear all 
close all
clc

%% 

% This code pulls in subjects from newsubs.txt and makes covariates and motion regressors, demeans them and
% generates a spreadsheet for easy copying and pasting into FSL.

% For this code to work, place motion_outliers.csv and ____.csv into your
% code directory. Make sure they are named below.

currentdir = pwd;

subjects_all = readtable('sublist_all.txt'); % L3 list of subs...
subjects = table2array(subjects_all);
outputdir = [currentdir '/covariates/output'];


if exist(outputdir) == 7
    rmdir(outputdir, 's');
    mkdir(outputdir);
else
    mkdir(outputdir); % set name
end

input_behavioral = '/ZPOOL/data/projects/rf1-sra-data/code/covariates/covariates.csv'; % input file  
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

% Specify variable names here.

var1 ='OAFEM'; %FEVS
var2 ='EI';

% Specify the names of the variables where they are found in the covariates
% spreadsheet:

% fevs_sum

cov_data = [data.sub_id_rf1_data , data.sub_age, data.oafem_total, data.score_tei_globaltrait]; % sub number, age, var1, var2


%% Extract data

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

ageXvar1 = [(exclusions_applied(:,2)-mean(exclusions_applied(:,2))) .* (exclusions_applied(:,3)-mean(exclusions_applied(:,3)))];
ageXvar2 = [(exclusions_applied(:,2)-mean(exclusions_applied(:,2))) .* (exclusions_applied(:,4)-mean(exclusions_applied(:,4)))];
var1Xvar2 = [(exclusions_applied(:,3)-mean(exclusions_applied(:,3))) .* (exclusions_applied(:,4)-mean(exclusions_applied(:,4)))];
ageXvar1Xvar2 = [(exclusions_applied(:,2)-mean(exclusions_applied(:,2))) .* (exclusions_applied(:,3)-mean(exclusions_applied(:,3))) .* (exclusions_applied(:,4)-mean(exclusions_applied(:,4)))];

behavioral_data_full = [exclusions_applied, ageXvar1, ageXvar2, var1Xvar2, ageXvar1Xvar2];

demeaned_output_raw = behavioral_data_full(:,2:end) - mean(behavioral_data_full(:,2:end));

demeaned_output = array2table(demeaned_output_raw(1:end,:),'VariableNames', {'age', var1, var2, 'ageXvar1', 'ageXvar2', 'var1Xvar2', 'ageXvar1Xvar2'});
subject_output = array2table(subjects_keep(1:end, 1),'VariableNames', {'subject'});

%% Makes a ones matrix 

[N,M] = size(demeaned_output);
A(1:N,1) = ones; % subject number

ones_output = array2table(A(1:end,:),'VariableNames', {'ones'});

%% Output file

% NOTE, In the future add motion outliers!!!



final_output_age_only = [subject_output(:,'subject'), ones_output(:,'ones'), demeaned_output(:,'age')];
final_output_agexvar2 = [subject_output(:,'subject'), ones_output(:,'ones'), demeaned_output(:,'age'), demeaned_output(:,var2), demeaned_output(:,'ageXvar2')];
final_output_agexvar1 = [subject_output(:,'subject'), ones_output(:,'ones'), demeaned_output(:,'age'), demeaned_output(:,var1), demeaned_output(:,'ageXvar2')];
final_output_agexvar1xvar2 = [subject_output(:,'subject'), ones_output(:,'ones'), demeaned_output(:,'age'), demeaned_output(:,var1),  demeaned_output(:,var2), demeaned_output(:,'ageXvar1'), demeaned_output(:,'ageXvar2'), demeaned_output(:,'var1Xvar2'), demeaned_output(:,'ageXvar1Xvar2')];

output2 = strcat('final_output_agex',var1)
output3 = strcat('final_output_agex',var2)
output4 = strcat('final_output_agex',var1,'x',var2)

dest_path = [outputdir, 'rf1_covariates_ageonly.xls'];

[L] = isfile(dest_path);
if L == 1
    delete(dest_path)
end

name = ('rf1_covariates_ageonly.xls');
fileoutput = [dest_path];
writetable(final_output_age_only, fileoutput); % Save as csv file


name = strcat(output2,'.xls');

dest_path = [outputdir, name];
[L] = isfile(dest_path);
if L == 1
    delete(dest_path)
end

fileoutput = [dest_path];
writetable(final_output_agexvar1, fileoutput); % Save as csv file

name = strcat(output3,'.xls');

dest_path = [outputdir, name];
[L] = isfile(dest_path);
if L == 1
    delete(dest_path)
end
fileoutput = [dest_path];

writetable(final_output_agexvar2, fileoutput); % Save as csv file

name = strcat(output4,'.xls');

dest_path = [outputdir, name];
[L] = isfile(dest_path);
if L == 1
    delete(dest_path)
end

fileoutput = [dest_path];
writetable(final_output_agexvar1xvar2, fileoutput); % Save as csv file
