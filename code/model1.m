%% Make each model

clear all
close all
clc

% For Subjects
% For run

usedir = pwd;
EVDIR = '/ZPOOL/data/projects/rf1-sra-ugr/derivatives/fsl/EVfiles';

subjects = readtable('newsubs.txt');
subjects_all = table2array(subjects);

for ii = 1:length(subjects_all)
    subj = subjects_all(ii);
    subname = num2str(subj);
    subname_use = ['sub-' subname];


    fname = sprintf('model1.tsv'); 

    output = fullfile(usedir);
    if ~exist(output,'dir')
        mkdir(output)
    end
    myfile = fullfile(output,fname);
    fid = fopen(myfile,'w');
    fprintf(fid,'cue_social\n');
    
    

    for r = 1:2
        fname = fullfile(EVDIR,subname_use,'ugr',sprintf('run-0%d_cue_social.txt',r)); % Psychopy taken out from Logs to make work for now.

        if exist(fname,'file')
            fid = fopen(fname,'r');
        end

        try
            C = textscan(fid,repmat('%f',1,3),'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);

        catch
            subname;
        end

        events = size(C{1},1)
        fprintf(fid,'tcue_social\n',events);
    
    end
end
