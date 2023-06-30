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
codedir = '/data/projects/istart-ugdg/code'; % Run code from this path.
addpath(codedir)
maindir = '/data/projects/istart-ugdg';
roidir = '/data/projects/istart-ugdg/derivatives/imaging_plots/'; % Results from extractROI script.
oldroidir = '/data/projects/istart-ugdg/derivatives/imaging_plots_old/'; % For debugging and comparison
resultsdir = '/data/projects/istart-ugdg/derivatives/imaging_plots/results/'; % Output where results will be saved.
cov_dir ='/data/projects/istart-ugdg/derivatives/fsl/covariates/'; % Input for covariates

%FULL = readtable([cov_dir 'final_output_full.xls']); % Full N = 51 (StrategicBehavior)
%REWARD = readtable([cov_dir 'final_output_reward.xls']); % N = 50 (BAS, SPSRQ)
%ATTITUDES = readtable([cov_dir 'final_output_attitudes.xls']); % N = 45 (PNR, TEIQUE)
%SUBSTANCE = readtable([cov_dir 'final_output_substance_AUDIT.xls']); % N = 46 (AUDIT, DUDIT)
COMPOSITE = readtable([cov_dir 'final_output_strat_int.xls']); % N = 54 (REWARD and SUBSTANCE)
STRATEGIC = readtable([codedir '/strategic_behavior.xls']);

% Inputs into scatterplots.

% Strategic_Behavior	Composite_Substance	 Composite_Reward	Composite_Reward_Squared	Composite_SubstanceXReward	Composite_SubstanceXReward_Squared

ID_Measure_1 = STRATEGIC.Proportion;  %STRATEGIC.Raw Proportion;
ID_Measure_1_name= ' Proportion';
ID_Measure_2 = COMPOSITE.StrategicXReward; %STRATEGIC.Proportion; %
ID_Measure_2_name=' Int';%' Composite_SubstanceXReward_Squared'
rois= {'IFG_extracted' 'Insula_extracted'}; % 'pTPJ_extracted' 'seed-NAcc-thr' 'seed-vmPFC-5mm-thr'};% 'seed-pTPJ-bin' 'seed-mPFC-thr' 'seed-SPL-thr' 'seed-ACC-50-thr' 'seed-insula-thr'  'seed-dlPFC-thr'}; % 'seed-pTPJ-thr' 'seed-vmPFC-5mm-thr' 'seed-SPL-thr' 'seed-ACC-50-thr'}; % 'seed-dlPFC-UGR-bin' 'seed-ACC-10mm' 
models = {['_type-act_cov-COMPOSITE_noINT_model-GLM3_']}; % ppi_seed-IFG_extracted 'nppi-ecn' nppi-ecn ppi_seed-NAcc-bin act ppi_seed-IFG_extracted};

% 

%DGP_old = load('/data/projects/istart-ugdg/derivatives/imaging_plots_old/seed-vmPFC-5mm-thr_type-act_cov-COMPOSITE_model-GLM3_cope-01.txt');
%UGP_old = load('/data/projects/istart-ugdg/derivatives/imaging_plots_old/seed-vmPFC-5mm-thr_type-act_cov-COMPOSITE_model-GLM3_cope-02.txt');

%DGP = load('/data/projects/istart-ugdg/derivatives/imaging_plots/seed-vmPFC-5mm-thr_type-act_cov-COMPOSITE_model-GLM3_cope-01.txt');
%UGP = load('/data/projects/istart-ugdg/derivatives/imaging_plots/seed-vmPFC-5mm-thr_type-act_cov-COMPOSITE_model-GLM3_cope-02.txt');

% Test hypotheses:

H2 = 0; % Modulated and unmodulated cue activation. 
H3 = 1; % Modulated and unmodulated choice activation. 
H4 = 0; % Modulated and unmodulated NaCC PPI. 
H4_plot = 0; % Use if plotting multiple ROIs on the same bar plot. Code is crude and can only handle two ROIs.
H5 = 0; % Modulated and unmodulated analysis of ECN.
E1 = 0; % Modulated exploratory results for UGR (Ishika analysis)

usenewroidir = 1; % Use new dir.
modulated = 0;
unmodulated = 1;

%% Specify COPES and L3 models:

%
% # COPE Nums:
%
% # 1.  Cue Dict
% # 2.  Cue UGP
% # 3.  Cue UG-R
% # 4.  Choice DG-P
% # 5.  Choice UG-P
% # 6.  Choice UG-R
% # 7.  Cue Dict pmod
% # 8.  Cue UGP pmod
% # 9.  Cue UGR pmod
% # 10. SKIP (DG cue > UGP cue)
% # 11. SKIP (DGP pmod cue > UGP)
% # 12. SKIP (DGP choice > UGP)
% # 13. Choice DG-P pmod
% # 14. Choice UG-P pmod
% # 15. Choice UG-R pmod
% # 16. SKIP (DG-P choice pmod > UGP)

%% H2 Act Modulated Cue Phase

if H2 == 1
    if modulated == 1
        if usenewroidir == 1

            name = 'Act_modulated_cue_results';
            cope_DGP={'cope-07.txt'};
            cope_UGP={'cope-08.txt'};
            cope_UGR={'cope-09.txt'};

        else % use olddir.
            roidir = oldroidir;
            name = 'Act_modulated_cue_results';
            cope_DGP={'cope-07.txt'};
            cope_UGP={'cope-08.txt'};
            cope_UGR={'cope-09.txt'};
        end

        type=' act';
        plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
        
        % Regression
         for r = 1:length(rois)
        roi = rois{r} ;
        for m = 1:length(models)
            model = models{m};
            DGP = load(strjoin([roidir,roi,model,cope_DGP], ''));
        end
         end
       [A,B] =  size(DGP)
       A = ones(A);
       C = A(:,1);
       Y = [DGP];
       X = [C,ID_Measure_2];
       [b,stats]= regress(Y,X)
       
       
    end
    
    %% H2 Act Unmodulated Cue Phase
    
    if unmodulated == 1
        name = 'Act_unmodulated_cue_results';
        cope_DGP={'cope-01.txt'};
        cope_UGP={'cope-02.txt'};
        cope_UGR={'cope-03.txt'};
        type=' act'; 
        plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
    end
end

%% H3 Act Modulated Choices

if H3 == 1
    if modulated == 1
        name = 'Act_modulated_choice_results';
        cope_DGP={'cope-10.txt'};
        cope_UGP={'cope-11.txt'};
        cope_UGR={'cope-12.txt'};
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
    
    %% H4 PPI NAcc unmodulated plot special
    
    if unmodulated == 1

        Cope_DGP = [];
        Cope_UGP = [];

        for jj = 1:length(rois)
        
        DGP={'cope-10.txt'};
        UGP={'cope-11.txt'};

        name = 'PPI_unmodulated_choice_results';
        type=' ppi NAcc'; 

        DGP = load(strjoin([roidir,rois(jj),models,Cope_DGP], ''));
        UGP= load(strjoin([roidir,rois(jj),models,Cope_UGP], ''));

        Cope_DGP = [Cope_DGP, DGP];
        Cope_UGP = [Cope_UGP, DGP];

        end

        
        plot_ugdg_multiple(name, roidir, rois, models, Cope_DGP, Cope_UGP, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
    end
end
       
%%  H5 ECN modulated decisions

if H5 == 1
    if modulated == 1
        
        name = 'ECN_modulated_choice_results';
        
        cope_DGP={'cope-10.txt'};
        cope_UGP={'cope-11.txt'};
        cope_UGR={'cope-12.txt'};
        
        type=' ecn nppi';
        
        plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
    end
    
    %% H5 ECN unmodulated decisions
    if unmodulated == 1
        name = 'ECN_unmodulated_choice_results';
        
        cope_DGP={'cope-04.txt'};
        cope_UGP={'cope-05.txt'};
        cope_UGR={'cope-06.txt'};
        
        type=' ecn nppi';
        
        plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
    end
end
    %% Ishika Analysis

    if E1 == 1
        if modulated == 1
            %EV_UGR = load(/data)
            name = 'Act_modulated_exploratory_choice_results';
            cope_UGR={'cope-12.txt'};
            for ii = 1:length(models)
                model=models(ii)
                for jj = 6 %1:length(rois)
                    roi = rois(jj)

                    UGR= load(strjoin([roidir,roi,model,cope_UGR], ''));


                end
            end
        end
    end
