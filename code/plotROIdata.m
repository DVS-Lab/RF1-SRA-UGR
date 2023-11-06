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
codedir = '/ZPOOL/data/projects/rf1-sra-ugr/code'; % Run code from this path.
addpath(codedir)
maindir = '/ZPOOL/data/projects/rf1-sra-ugr';
roidir = '/ZPOOL/data/projects/rf1-sra-ugr/derivatives/imaging_plots/'; % Results from extractROI script.
oldroidir = '/ZPOOL/data/projects/rf1-sra-ugr/derivatives/imaging_plots_old/'; % For debugging and comparison
resultsdir = '/ZPOOL/data/projects/rf1-sra-ugr/derivatives/imaging_plots/results/'; % Output where results will be saved.
cov_dir ='/ZPOOL/data/projects/rf1-sra-ugr/derivatives/fsl/covariates/'; % Input for covariates

%FULL = readtable([cov_dir 'final_output_full.xls']); % Full N = 51 (StrategicBehavior)
%REWARD = readtable([cov_dir 'final_output_reward.xls']); % N = 50 (BAS, SPSRQ)
%ATTITUDES = readtable([cov_dir 'final_output_attitudes.xls']); % N = 45 (PNR, TEIQUE)
%SUBSTANCE = readtable([cov_dir 'final_output_substance_AUDIT.xls']); % N = 46 (AUDIT, DUDIT)
%COMPOSITE = readtable([cov_dir 'final_output_strat_int.xls']); % N = 54 (REWARD and SUBSTANCE)
STRATEGIC = readtable([codedir '/covariates/rf1_covariates_ageXEI.xls']);

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

H2 = 1
%% H3 Act Modulated Choices

if H2 == 1
    if modulated == 1
        name = 'Act_modulated_choice_results';
        social={'cope-11.txt'};
        nonsocial={'cope-12.txt'};
        type=' act';
        plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
    end
    
    %% H3 Act Unmodulated Choices
    
    if unmodulated == 1
        name = 'Act_unmodulated_choice_results';
        cope_DGP={'cope-04.txt'};
        cope_UGP={'cope-05.txt'};
        cope_UGR={'cope-06.txt'};
        type=' act'; 
        plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
    end
end

%% H4 NAcc PPI modulated choice

if H4 == 1
    if modulated == 1
        name = 'PPI_modulated_choice_results'
        cope_DGP={'cope-10.txt'};
        cope_UGP={'cope-11.txt'};
        cope_UGR={'cope-12.txt'};
        type=' ppi NAcc';
        plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
    end
    
    %% H4 PPI NAcc unmodulated
    
    if unmodulated == 1
        name = 'PPI_unmodulated_choice_results';
        cope_DGP={'cope-04.txt'};
        cope_UGP={'cope-05.txt'};
        cope_UGR={'cope-06.txt'};
        type=' ppi NAcc'; 
        %plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
    end
end

%% H4 NAcc PPI modulated choice plot multiple

if H4_plot == 1
    if modulated == 1
        Cope_DGP={'cope-10.txt'};
        Cope_UGP={'cope-11.txt'};

        name = 'PPI_modulated_choice_results';
        type=' ppi NAcc'; 

        plot_ugdg_multiple(name, roidir, rois, models, Cope_DGP, Cope_UGP, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
    end
% 
%     %% H4 PPI NAcc unmodulated plot special
% 
%     if unmodulated == 1
% 
%         Cope_DGP = [];
%         Cope_UGP = [];
% 
%         for jj = 1:length(rois)
% 
%         DGP={'cope-10.txt'};
%         UGP={'cope-11.txt'};
% 
%         name = 'PPI_unmodulated_choice_results';
%         type=' ppi NAcc'; 
% 
%         DGP = load(strjoin([roidir,rois(jj),models,Cope_DGP], ''));
%         UGP= load(strjoin([roidir,rois(jj),models,Cope_UGP], ''));
% 
%         Cope_DGP = [Cope_DGP, DGP];
%         Cope_UGP = [Cope_UGP, DGP];
% 
%         end
% 
% 
%         plot_ugdg_multiple(name, roidir, rois, models, Cope_DGP, Cope_UGP, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
%     end
% end
% 
% %%  H5 ECN modulated decisions
% 
% if H5 == 1
%     if modulated == 1
% 
%         name = 'ECN_modulated_choice_results';
% 
%         cope_DGP={'cope-10.txt'};
%         cope_UGP={'cope-11.txt'};
%         cope_UGR={'cope-12.txt'};
% 
%         type=' ecn nppi';
% 
%         plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
%     end
% 
%     %% H5 ECN unmodulated decisions
%     if unmodulated == 1
%         name = 'ECN_unmodulated_choice_results';
% 
%         cope_DGP={'cope-04.txt'};
%         cope_UGP={'cope-05.txt'};
%         cope_UGR={'cope-06.txt'};
% 
%         type=' ecn nppi';
% 
%         plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
%     end
% end
%     %% Ishika Analysis
% 
%     if E1 == 1
%         if modulated == 1
%             %EV_UGR = load(/data)
%             name = 'Act_modulated_exploratory_choice_results';
%             cope_UGR={'cope-12.txt'};
%             for ii = 1:length(models)
%                 model=models(ii)
%                 for jj = 6 %1:length(rois)
%                     roi = rois(jj)
% 
%                     UGR= load(strjoin([roidir,roi,model,cope_UGR], ''));
% 
% 
%                 end
%             end
%         end
%     end
