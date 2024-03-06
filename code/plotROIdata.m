clear
close all;
clc

% Daniel Sazhin
% Adapted from D.Smith's code in r21-cardgame
% ISTART
% 03/23/21
% DVS Lab
% Temple University

% This code plots ROIs for the UGDG task.

% set up dirs
codedir = pwd; %'/ZPOOL/data/projects/rf1-sra-ugr/code'; % Run code from this path.
addpath(codedir)
maindir = 'A:\Data\RF1-SRA-UGR\';
roidir = 'A:\Data\RF1-SRA-UGR\derivatives\imaging_plots\'; % Results from extractROI script.
oldroidir = '/ZPOOL/data/projects/rf1-sra-ugr/derivatives/imaging_plots_old/'; % For debugging and comparison
resultsdir = '/ZPOOL/data/projects/rf1-sra-ugr/derivatives/imaging_plots/results/'; % Output where results will be saved.
cov_dir ='/ZPOOL/data/projects/rf1-sra-ugr/derivatives/fsl/covariates/'; % Input for covariates

%FULL = readtable([cov_dir 'final_output_full.xls']); % Full N = 51 (StrategicBehavior)
%REWARD = readtable([cov_dir 'final_output_reward.xls']); % N = 50 (BAS, SPSRQ)
%ATTITUDES = readtable([cov_dir 'final_output_attitudes.xls']); % N = 45 (PNR, TEIQUE)
%SUBSTANCE = readtable([cov_dir 'final_output_substance_AUDIT.xls']); % N = 46 (AUDIT, DUDIT)
%COMPOSITE = readtable([cov_dir 'final_output_strat_int.xls']); % N = 54 (REWARD and SUBSTANCE)
STRATEGIC = readtable([codedir '\covariates\final_output_agexEI.xls']);

%% Make age X activation scatterplot.

covariates = readtable([codedir '\covariates\final_output_agexOAFEM.xls']);

s = 's_n_age_1_type-act_cov-OAFEMwINT2_model-ugr_cope-05.txt';
n = 's_n_age_1_type-act_cov-OAFEMwINT2_model-ugr_cope-06.txt';
social = load([roidir,s]);
nonsocial = load([roidir,n]);

figure
scatter(covariates.age, social-nonsocial,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
ax = gca;
ax.FontSize = 12;
title ([''])
xlabel ('Age', 'FontSize', 16);
ylabel  ('vlPFC Activation', 'FontSize', 16);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'vlPFC.tif')


%% ECN result

currentdir =pwd;

subjects_all = readtable('L3_List_OAFEM_sublist.txt');
subjects = table2array(subjects_all);
outputdir = [currentdir '/covariates/'];


% if exist(outputdir) == 7
%     rmdir(outputdir, 's');
%     mkdir(outputdir);
% else
%     mkdir(outputdir); % set name
% end

input_behavioral = 'covariates.csv'; % input file  
%motion_input = 'motion_data_input.xls';

currentdir = pwd;
subjects_all = readtable('L3_List_OAFEM_sublist.txt');
subjects = table2array(subjects_all);
outputdir = [currentdir '/covariates/'];

%input_behavioral = 'v2.1_SFN_Covariates.xlsx';
data = readtable(input_behavioral);
%data = table2array(data);

cov_data = [data.sub_id_rf1_data, data.sub_age, data.oafem_total];
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

s = 's_n_age_1_type-act_cov-OAFEMwINT2_model-ugr_cope-05.txt';
n = 's_n_age_1_type-act_cov-OAFEMwINT2_model-ugr_cope-06.txt';
social = load([roidir,s]);
nonsocial = load([roidir,n]);

figure
scatter(exclusions_applied(:,2), social-nonsocial,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
ax = gca;
ax.FontSize = 12;
title ([''])
xlabel ('Age', 'FontSize', 16);
ylabel  ('vlPFC Activation', 'FontSize', 16);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'vlPFC.svg')

%% Age histogram

figure
h = histogram(exclusions_applied(:,2));
counts = h.Values;
h.NumBins = 8;
ax = gca;
ax.FontSize = 12;
xlabel ('Age','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off')
set(gcf,'color','w');

saveas(gcf,'age_Scores.svg')

%% ECN result


subjects_all = readtable('L3subs.txt');
subjects = table2array(subjects_all);
outputdir = [currentdir '/covariates/'];


if exist(outputdir) == 7
    rmdir(outputdir, 's');
    mkdir(outputdir);
else
    mkdir(outputdir); % set name
end

input_behavioral = 'v2.1_SFN_Covariates.xlsx'; % input file  
%motion_input = 'motion_data_input.xls';

currentdir = pwd;
subjects_all = readtable('L3subs.txt');
subjects = table2array(subjects_all);
outputdir = [currentdir '/covariates/'];

input_behavioral = 'v2.1_SFN_Covariates.xlsx';
data = readtable(input_behavioral);
%data = table2array(data);

cov_data = [data.sub, data.sub_age, data.score_tei_globaltrait];
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

n = 'ecn_mask1_type-nppi-ecn_cov-EIwINT2_model-ugr_cope-08.txt';

nonsocial = load([roidir,n]);

figure
scatter(exclusions_applied(:,2), nonsocial,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
ax = gca;
ax.FontSize = 12;
title ([''])
xlabel ('Age', 'FontSize', 16);
ylabel  ('ECN-vmPFC Nonsocial Fairness', 'FontSize', 16);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'vmPFC.svg')



% hold on 
% 
% scatter(covariates.age, nonsocial,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
% ax = gca;
% ax.FontSize = 12;
% title (['Subject '])
% xlabel ('Proportion', 'FontSize', 16);
% ylabel  ('Choice', 'FontSize', 16);
% i = lsline;
% i.LineWidth = 5;
% i.Color = [0 0 0];
% set(gcf,'color','w');



%%

% Inputs into scatterplots.

% Strategic_Behavior	Composite_Substance	 Composite_Reward	Composite_Reward_Squared	Composite_SubstanceXReward	Composite_SubstanceXReward_Squared

ID_Measure_1 = STRATEGIC.ones;  %STRATEGIC.Raw Proportion;
ID_Measure_1_name= ' Proportion';
ID_Measure_2 = STRATEGIC.ones; %STRATEGIC.Proportion; %
ID_Measure_2_name=' Int';%' Composite_SubstanceXReward_Squared'
rois= {'s_n_mask'}; % 'pTPJ_extracted' 'seed-NAcc-thr' 'seed-vmPFC-5mm-thr'};% 'seed-pTPJ-bin' 'seed-mPFC-thr' 'seed-SPL-thr' 'seed-ACC-50-thr' 'seed-insula-thr'  'seed-dlPFC-thr'}; % 'seed-pTPJ-thr' 'seed-vmPFC-5mm-thr' 'seed-SPL-thr' 'seed-ACC-50-thr'}; % 'seed-dlPFC-UGR-bin' 'seed-ACC-10mm' 
models = {['_type-act_cov-noINT_model-ugr_']}; % ppi_seed-IFG_extracted 'nppi-ecn' nppi-ecn ppi_seed-NAcc-bin act ppi_seed-IFG_extracted};



%DGP_old = load('/data/projects/istart-ugdg/derivatives/imaging_plots_old/seed-vmPFC-5mm-thr_type-act_cov-COMPOSITE_model-GLM3_cope-01.txt');
%UGP_old = load('/data/projects/istart-ugdg/derivatives/imaging_plots_old/seed-vmPFC-5mm-thr_type-act_cov-COMPOSITE_model-GLM3_cope-02.txt');

%DGP = load('/data/projects/istart-ugdg/derivatives/imaging_plots/seed-vmPFC-5mm-thr_type-act_cov-COMPOSITE_model-GLM3_cope-01.txt');
%UGP = load('/data/projects/istart-ugdg/derivatives/imaging_plots/seed-vmPFC-5mm-thr_type-act_cov-COMPOSITE_model-GLM3_cope-02.txt');

% Test hypotheses:

% H2 = 1
% %% H3 Act Modulated Choices
% 
% if H2 == 1
%     if modulated == 1
%         name = 'Act_modulated_choice_results';
%         social={'cope-11.txt'};
%         nonsocial={'cope-12.txt'};
%         type=' act';
%         plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
%     end
%     
%     %% H3 Act Unmodulated Choices
%     
%     if unmodulated == 1
%         name = 'Act_unmodulated_choice_results';
%         cope_DGP={'cope-04.txt'};
%         cope_UGP={'cope-05.txt'};
%         cope_UGR={'cope-06.txt'};
%         type=' act'; 
%         plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
%     end
% end
% 
% 
% %% H4 NAcc PPI modulated choice
% 
% if H4 == 1
%     if modulated == 1
%         name = 'PPI_modulated_choice_results'
%         cope_DGP={'cope-10.txt'};
%         cope_UGP={'cope-11.txt'};
%         cope_UGR={'cope-12.txt'};
%         type=' ppi NAcc';
%         plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
%     end
%     
%     %% H4 PPI NAcc unmodulated
%     
%     if unmodulated == 1
%         name = 'PPI_unmodulated_choice_results';
%         cope_DGP={'cope-04.txt'};
%         cope_UGP={'cope-05.txt'};
%         cope_UGR={'cope-06.txt'};
%         type=' ppi NAcc'; 
%         %plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
%     end
% end
% 
% %% H4 NAcc PPI modulated choice plot multiple
% 
% if H4_plot == 1
%     if modulated == 1
%         Cope_DGP={'cope-10.txt'};
%         Cope_UGP={'cope-11.txt'};
% 
%         name = 'PPI_modulated_choice_results';
%         type=' ppi NAcc'; 
% 
%         plot_ugdg_multiple(name, roidir, rois, models, Cope_DGP, Cope_UGP, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
%     end
% % 
% %     %% H4 PPI NAcc unmodulated plot special
% % 
% %     if unmodulated == 1
% % 
% %         Cope_DGP = [];
% %         Cope_UGP = [];
% % 
% %         for jj = 1:length(rois)
% % 
% %         DGP={'cope-10.txt'};
% %         UGP={'cope-11.txt'};
% % 
% %         name = 'PPI_unmodulated_choice_results';
% %         type=' ppi NAcc'; 
% % 
% %         DGP = load(strjoin([roidir,rois(jj),models,Cope_DGP], ''));
% %         UGP= load(strjoin([roidir,rois(jj),models,Cope_UGP], ''));
% % 
% %         Cope_DGP = [Cope_DGP, DGP];
% %         Cope_UGP = [Cope_UGP, DGP];
% % 
% %         end
% % 
% % 
% %         plot_ugdg_multiple(name, roidir, rois, models, Cope_DGP, Cope_UGP, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
% %     end
% % end
% % 
% % %%  H5 ECN modulated decisions
% % 
% % if H5 == 1
% %     if modulated == 1
% % 
% %         name = 'ECN_modulated_choice_results';
% % 
% %         cope_DGP={'cope-10.txt'};
% %         cope_UGP={'cope-11.txt'};
% %         cope_UGR={'cope-12.txt'};
% % 
% %         type=' ecn nppi';
% % 
% %         plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
% %     end
% % 
% %     %% H5 ECN unmodulated decisions
% %     if unmodulated == 1
% %         name = 'ECN_unmodulated_choice_results';
% % 
% %         cope_DGP={'cope-04.txt'};
% %         cope_UGP={'cope-05.txt'};
% %         cope_UGR={'cope-06.txt'};
% % 
% %         type=' ecn nppi';
% % 
% %         plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
% %     end
% % end
% %     %% Ishika Analysis
% % 
% %     if E1 == 1
% %         if modulated == 1
% %             %EV_UGR = load(/data)
% %             name = 'Act_modulated_exploratory_choice_results';
% %             cope_UGR={'cope-12.txt'};
% %             for ii = 1:length(models)
% %                 model=models(ii)
% %                 for jj = 6 %1:length(rois)
% %                     roi = rois(jj)
% % 
% %                     UGR= load(strjoin([roidir,roi,model,cope_UGR], ''));
% % 
% % 
% %                 end
% %             end
% %         end
% %     end
