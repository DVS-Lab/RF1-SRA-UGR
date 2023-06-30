clear all
close all
clc

% Daniel Sazhin
% ISTART Project (UGDG)
% DVS Lab
% 05/13/2022
% Temple University

% This code generates a composite reward sensitivity score using BAS and SR
% data. This code also generates a composite substance use score for AUDIT
% and DUDIT.

%% Inputs 

currentdir = pwd;
output_path = currentdir; % Set output path if you would like.
motion_input = 'motion_data_input.xls';
output_path = [currentdir '/covariates/'];
strat_input = [currentdir '/output/'];

input = 'ISTART-ALL-Combined-042122.xlsx'; % input file  %  
data = readtable(input);
Composite_raw = [data.('ID'), data.('BISBAS_BAS'), data.('SPSRWD')];
AUDIT_raw = [data.('ID'), data.('audit_standard_score')];
DUDIT_raw = [data.('ID'), data.('dudit_standard_score')];

% subjects = [1003, 1006, 1009, 1010, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1242, 1243, 1244, 1245, 1247, 1248, 1249, 1251, 1253, 1255, 1276, 1282, 1286, 1294, 1300, 1301, 1302, 1303, 3101, 3116, 3122, 3125, 3140, 3143, 3152, 3164, 3166, 3167, 3170, 3173, 3175, 3176, 3189, 3190, 3199, 3200, 3206, 3210, 3212, 3220, 3223];
subjects = [1003
1004
1006
1009
1010
1011
1012
1013
1015
1016
1019
1021
1242
1243
1244
1245
1247
1248
1249
1251
1253
1255
1276
1282
1286
1294
1300
1301
1302
1303
3101
3116
3122
3125
3140
3143
3152
3164
3166
3167
3170
3173
3175
3176
3189
3190
3199
3200
3206
3210
3212
3218
3220
3223];
%% Read in the tsnr and means 

% Find the columns you will need.

data = readtable(motion_input);
data = table2array(data);

motion_data = [];

% tsnr is second column. motion is third column

for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(data==subj);
    save = data(subj_row,:);
    motion_data = [motion_data;save];
end

motion_data_output = array2table(motion_data(1:end,:),'VariableNames', {'Subject', 'tsnr', 'fd_mean'});


%% Collate data to reflect desired subjects for reward sensitivity

% This code can help with debugging. Check "composite missing" to see which
% subjects need to be eliminated.

%if make_reward == 1 
    
% Eliminate Nans

eliminate_rows = any(isnan(Composite_raw),2);
Reward_temp = [];

for ii = 1:length(Composite_raw)
    keep = [];
    row = Composite_raw(ii,:);
    if eliminate_rows(ii) == 0
        keep = row;
    end
    Reward_temp = [Reward_temp; keep];
end

Composite_missing = [];
Composite_final = [];
for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(Reward_temp==subj);
    if subj_row > 0
        test = Reward_temp(subj_row,:);
        if test(2) < 100 % Tests for 999s in the data
            Composite_final = [Composite_final;test];
        else
            Composite_missing = [Composite_missing; subjects(ii)];
        end
    end
    
end

%% Perform z-scoring.

compRS = zscore(Composite_final(:,2)) + zscore(Composite_final(:,3)); % combine measures for your final data

figure, hist(compRS,50); title('Composite') % look at your data
figure, hist(compRS.^2,50); title('Composite Squared') % look at your data squared

normedRS = zeros(length(compRS),1); % create empty array for storing data
deciles = prctile(compRS,[10 20 30 40 50 60 70 80 90]); % identify quintiles

% place data into the appropriate quintiles
normedRS(compRS < deciles(1),1) = 1;
normedRS(compRS >= deciles(1) & compRS < deciles(2),1) = 2;
normedRS(compRS >= deciles(2) & compRS < deciles(3),1) = 3;
normedRS(compRS >= deciles(3) & compRS < deciles(4),1) = 4;
normedRS(compRS >= deciles(4) & compRS < deciles(5),1) = 5;
normedRS(compRS >= deciles(5) & compRS < deciles(6),1) = 6;
normedRS(compRS >= deciles(6) & compRS < deciles(7),1) = 7;
normedRS(compRS >= deciles(7) & compRS < deciles(8),1) = 8;
normedRS(compRS >= deciles(8) & compRS < deciles(9),1) = 9;
normedRS(compRS >= deciles(9),1) = 10;
%% 

figure, hist(normedRS,50); title('Normed Composite') % look at your data
figure, hist(normedRS.^2,50); title('Normed Composite Squared') % look at your data squared

%% Output results.

normedRS = normedRS - mean(normedRS); % demeaned
Combined_reward = [Composite_final(:,1), normedRS, normedRS.^2]; % Pairs subject numbers with RS scores. 
Composite_final_output = array2table(Combined_reward(1:end,:),'VariableNames', {'Subject', 'Composite_Reward', 'Composite_Reward_Squared'});

name = ('Composite_Reward.xlsx');
fileoutput = [output_path, name];
writetable(Composite_final_output, fileoutput); % Save as csv file

%end

%% Make substance use


AUDIT_missing = [];
AUDIT_final = [];
for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(AUDIT_raw==subj);
    if subj_row > 0
        test = AUDIT_raw(subj_row(1),:);
        if test(2) < 100 % Tests for 999s in the data
            AUDIT_final = [AUDIT_final;test];
        else
            AUDIT_missing = [AUDIT_missing; subjects(ii)];
        end
    end
    
end

DUDIT_missing = [];
DUDIT_final = [];

for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(DUDIT_raw==subj);
    if subj_row > 0
        test = DUDIT_raw(subj_row(1),:);
        if test(2) < 100 % Tests for 999s in the data
            DUDIT_final = [DUDIT_final;test];
        else
            DUDIT_missing = [DUDIT_missing; subjects(ii)];
        end
    end 
end

%% Perform z-scoring.

comp_SU = zscore(AUDIT_final(:,2)) + zscore(DUDIT_final(:,2)); % combine measures for your final data

figure, hist(comp_SU,50); title('Composite') % look at your data
figure, hist(comp_SU.^2,50); title('Composite_Squared') % look at your data squared

% normed_comp_SU = zeros(length(compRS),1); % create empty array for storing data
% deciles = prctile(compRS,[10 20 30 40 50 60 70 80 90]); % identify quintiles
% 
% % place data into the appropriate quintiles
% normed_comp_SU(comp_SU < deciles(1),1) = 1;
% normed_comp_SU(comp_SU >= deciles(1) & comp_SU < deciles(2),1) = 2;
% normed_comp_SU(comp_SU >= deciles(2) & comp_SU < deciles(3),1) = 3;
% normed_comp_SU(comp_SU >= deciles(3) & comp_SU < deciles(4),1) = 4;
% normed_comp_SU(comp_SU >= deciles(4) & comp_SU < deciles(5),1) = 5;
% normed_comp_SU(comp_SU >= deciles(5) & comp_SU < deciles(6),1) = 6;
% normed_comp_SU(comp_SU >= deciles(6) & comp_SU < deciles(7),1) = 7;
% normed_comp_SU(comp_SU >= deciles(7) & comp_SU < deciles(8),1) = 8;
% normed_comp_SU(comp_SU >= deciles(8) & comp_SU < deciles(9),1) = 9;
% normed_comp_SU(comp_SU >= deciles(9),1) = 10;
%% 

% figure, hist(normed_comp_SU,50); title('Normed Composite') % look at your data
% figure, hist(normed_comp_SU.^2,50); title('Normed Composite Squared') % look at your data squared

%% Output results.

Combined_sub = [AUDIT_final(:,1), comp_SU, comp_SU.^2]; % Pairs subject numbers with RS scores. 
Composite_final_output_substance = array2table(Combined_sub(1:end,:),'VariableNames', {'Subject', 'Composite_Substance', 'Composite_Substance_Squared' });

name = ('Composite_Substance.xlsx');
fileoutput = [output_path, name];
writetable(Composite_final_output_substance, fileoutput); % Save as csv file

%% Combine RS and Substance Use with interactions

% 4 composite RS
% 5 composite RS squared
% 6 composite substance use
% 7 substance use * RS
% 8 substance use * RS squared

Reward_substance = [Composite_final_output_substance.Composite_Substance,  Composite_final_output.Composite_Reward, Composite_final_output.Composite_Reward_Squared, Composite_final_output_substance.Composite_Substance.*Composite_final_output.Composite_Reward, Composite_final_output_substance.Composite_Substance.*Composite_final_output.Composite_Reward_Squared];
Reward_substance_demeaned = Reward_substance - mean(Reward_substance);
Reward_substance_final = [Composite_final_output_substance.Subject, Reward_substance_demeaned];

Reward_substance_output = array2table(Reward_substance_final(1:end,:),'VariableNames', {'Subject', 'Composite_Substance', 'Composite_Reward', 'Composite_Reward_Squared', 'Composite_SubstanceXReward', 'Composite_SubstanceXReward_Squared'});

%% Strategic Behavior 

% First figure out raw values, then combine into strategic behavior

% Raw DG needs to be average to account for missed/irregular number of
% trials. 

%% Raw DG

DG_P_Earnings = [];
DG_P_Offers=[];
DG_P_Prop = [];

for ii = 1:length(subjects);
    
    name = ['Subject_' num2str(subjects(ii)) '_DGP.csv'];
    input = [strat_input,name];
    O = readtable(input);
    DG_Part = [];
    for kk = 1:length(O.Trial)
        if O.Decision(kk) == 1
            save = O.More_Prop(kk);
        else
            save = O.Less_Prop(kk);
        end
        DG_Part = [DG_Part; save];
    end
    DG_P_Prop = [DG_P_Prop; mean(DG_Part)];
    DG_P_Offers = [DG_P_Offers; mean(O.Choice)]; % AMOUNT OFFERED!!!
    DG_P_Earnings = [DG_P_Earnings; sum(O.Endowment)-sum(O.Choice)]; % AMOUNT SAVED for self.
    
end

%% Raw results UG-P

Final_save_2 = [];
UG_P_2 = [];

Final_save = [];
UG_P = [];
%UG_P_Total = [];
Subjects = [];
Subjects_2 = [];
UG_P_Offers = [];
UG_P_Offers_2 = [];
UG_P_Earnings  = [];
UG_P_Earnings_2 = [];

Final_Subjects =[];
UG_P_Prop = [];
UG_P_Prop_2 = [];

for jj = 1:length(subjects)
    save_value = [];

    name = ['Subject_' num2str(subjects(jj)) '_UGP.csv'];
    input = [strat_input,name];
    T = readtable(input);
    UG_P_Offers = [UG_P_Offers; mean(T.Choice)]; % AMOUNT OFFERED!!!
    UG_P_Offers_Prop = [UG_P_Offers; mean(T.Choice)];

    UG_Part = [];

    for kk = 1:length(T.Trial)
        if T.Decision(kk) == 1
            save = T.More_Prop(kk);
        else
            save = T.Less_Prop(kk);
        end
        UG_Part = [UG_Part; save];

    end
    UG_P_Prop = [UG_P_Prop; mean(UG_Part)];
    UG_P_Earnings = [UG_P_Earnings; sum(T.Endowment)-sum(T.Choice)]; % AMOUNT SAVED for self, uncorrected for rejections.



    try
        save_value = [];
        name = ['Subject_' num2str(subjects(jj)) '_UGP2.csv'];
        input = [strat_input,name];
        S = readtable(input);
        UG_Part_2 = [];

        for kk = 1:length(T.Trial)
            if T.Decision(kk) == 1
                save = T.More_Prop(kk);
            else
                save = T.Less_Prop(kk);
            end
            UG_Part_2 = [UG_Part_2; save];

        end
        offers_2 = mean(S.Choice);
        earnings_2 = sum(S.Endowment)-sum(S.Choice);
    catch
        disp('missing second run')
        UG_Part_2 = NaN;
        offers_2 = NaN;
        earnings_2 = NaN;

    end

        UG_P_Prop_2 = [UG_P_Prop_2; mean(UG_Part_2)];
        UG_P_Offers_2 = [UG_P_Offers_2;offers_2]; % AMOUNT OFFERED!!!
        UG_P_Earnings_2 = [UG_P_Earnings_2; earnings_2]; % AMOUNT SAVED for self, uncorrected for rejections.
 
end

% Average if two runs are good, else keep first run.
UG_P_Raw_Props = []; 
UG_P_Raw_Earnings = [];
UG_P_Raw_Offers = [];

for kk = 1:length(UG_P_Prop_2)
    test = UG_P_Prop_2(kk);
    if test > 0
        UG_P_Raw_Props = [UG_P_Raw_Props; (UG_P_Prop(kk)+UG_P_Prop_2(kk))/2];
        UG_P_Raw_Offers = [UG_P_Raw_Offers; (UG_P_Offers(kk)+UG_P_Offers_2(kk))/2];
        %UG_P_Raw_Earnings = [UG_P_Earnings; UG_P_Earnings(kk) + UG_P_Earnings_2(kk)];
    else
        % Just take the first run
        UG_P_Raw_Props = [UG_P_Raw_Props; UG_P_Prop(kk)];
        UG_P_Raw_Offers = [UG_P_Raw_Offers; UG_P_Offers(kk)];
       % UG_P_Raw_Earnings = [UG_P_Raw_Earnings; UG_P_Earnings(kk)];
    end
end
    

%UG_P_Raw_Props = ((UG_P_Prop+UG_P_Prop_2)/2);
%UG_P_Raw_Offers = (UG_P_Offers+UG_P_Offers_2/2); % Sum offers
%UG_P_Raw_Earnings = UG_P_Earnings + UG_P_Earnings_2; % Uncorrected

%% Export several measures of strategic behavior

% Percent change from DG to UG

PercentChange = ((UG_P_Raw_Offers- DG_P_Offers)./ DG_P_Offers)*100;

% Monetary values

MonetaryDifference = UG_P_Raw_Offers- DG_P_Offers;

% Proportion difference in offer

Strategic_Behavior = UG_P_Raw_Props- DG_P_Prop;

% Demean strategic behavior

demeaned_Strategic_Behavior = Strategic_Behavior - mean(Strategic_Behavior);

demeaned_Strategic_Behavior_output = array2table(demeaned_Strategic_Behavior(1:end,:),'VariableNames', {'Strategic_Behavior'});

% Generate reward sensitivity interaction measure

strat_int = [demeaned_Strategic_Behavior_output.Strategic_Behavior.*Composite_final_output.Composite_Reward, demeaned_Strategic_Behavior_output.Strategic_Behavior.*Composite_final_output.Composite_Reward_Squared];
demeaned_strat_int = strat_int - mean(strat_int);

demeaned_Strategic_int_output = array2table(demeaned_strat_int(1:end,:),'VariableNames', {'StrategicXReward' 'StrategicXReward_Squared'});


%% Combine into comprehensive set of IDs

[N,M] = size(motion_data_output);
A(1:N,1) = ones; % subject number

ones_output = array2table(A(1:end,:),'VariableNames', {'Ones'});
name = ('ones.xls');
writetable(ones_output, name); % Save as csv file

final_output_reward = [motion_data_output(:,'Subject'), ones_output(:,'Ones'), demeaned_Strategic_Behavior_output(:,'Strategic_Behavior'), Reward_substance_output(:,'Composite_Substance'), Reward_substance_output(:,'Composite_Reward'), Reward_substance_output(:,'Composite_Reward_Squared'), Reward_substance_output(:,'Composite_SubstanceXReward'), Reward_substance_output(:,'Composite_SubstanceXReward_Squared'), motion_data_output(:,'tsnr'), motion_data_output(:,'fd_mean')];

dest_path = [output_path, 'final_output_reward.xls'];
[L] = isfile(dest_path);
if L == 1
    delete(dest_path)
end

final_output_strat_int = [motion_data_output(:,'Subject'), ones_output(:,'Ones'), demeaned_Strategic_Behavior_output(:,'Strategic_Behavior'), Reward_substance_output(:,'Composite_Substance'), Reward_substance_output(:,'Composite_Reward'), Reward_substance_output(:,'Composite_Reward_Squared'), demeaned_Strategic_int_output(:,'StrategicXReward'), demeaned_Strategic_int_output(:,'StrategicXReward_Squared'), motion_data_output(:,'tsnr'), motion_data_output(:,'fd_mean')];

dest_path = [output_path, 'final_output_strat_int.xls'];
[L] = isfile(dest_path);
if L == 1
    delete(dest_path)
end

name = ('final_output_strat_int.xls');
fileoutput = [output_path, name];
writetable(final_output_strat_int, fileoutput); % Save as csv file

