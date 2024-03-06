clear all
close all
clc

% This code imports subject earnings (across conditions) and their
% individual difference measures and analyzes the data. 

% Daniel Sazhin
% 12/09/21
% DVS Lab
% Temple University
currentdir = pwd;
input_folder = [currentdir '\output_UGDG\'];
%input_behavioral = 'ISTART-ALL-Combined-042122.xlsx'; % input file  
%motion_input = 'motion_data_input.xls';

subjects_all = readtable('newsubs_UGDG.txt');
subjects = table2array(subjects_all);

input_behavioral = 'v2.2_SFN_Covariates.xls'; % input file  
%motion_input = 'motion_data_input.xls';


%% Raw DG

DG_P_Earnings = [];
DG_P_Offers=[];
DG_P_Prop = [];

for ii = 1:length(subjects);
    
    name = ['Subject_' num2str(subjects(ii)) '_DGP.csv'];
    input = [input_folder,name];
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
    input = [input_folder,name];
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
        input = [input_folder,name];
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
% 
% PercentChange = ((UG_P_Raw_Offers- DG_P_Offers)./ DG_P_Offers)*100;
% 
% % Monetary subjects
% 
% MonetaryDifference = UG_P_Raw_Offers- DG_P_Offers;
% 
% % Proportion difference in offer
% 
% ProportionDifference = UG_P_Raw_Props- DG_P_Prop;
% 
% outputstrat= [subjects, PercentChange, MonetaryDifference, ProportionDifference];
% outputstrattotable = array2table(outputstrat(1:end,:),'VariableNames', {'Subject', 'Percent', 'Raw', 'Proportion'});
% 
% 
% name = ('\strategic_behavior.xls');
% fileoutput = [currentdir, name];
% writetable(outputstrattotable , fileoutput);


%% Plot earnings

% data = [mean(DG_P_Earnings), mean(UG_P_Raw_Earnings), mean(UG_R_Earnings)]; 
% x = linspace(1,3,3);
% figure
% bar(x,data)
% ax = gca;
% ax.FontSize = 12;
% box off
% xlabel ('Tasks', 'FontSize', 16);
% ylabel  ('Earnings', 'FontSize', 16);
% set(gcf,'color','w');
% set(gca, 'XTick', 1:3, 'XTickLabels', {'DG-P', 'UG-P', 'UG-R'})
% 
% hold on
% 
% % Standard Error
% 
% B1Er = std(DG_P_Earnings) / sqrt(length(DG_P_Earnings));
% B2Er = std(UG_P_Raw_Earnings) / sqrt(length(UG_P_Raw_Earnings));
% B3Er = std(UG_R_Earnings) / sqrt(length(UG_R_Earnings));
% 
% 
% err = [B1Er,B2Er,B3Er] * 2;
% 
% er = errorbar(x,data,err); 
% er.Color = [0 0 0];
% er.LineStyle = 'none';
% er.LineWidth = 1;
% hold off
% 
% saveas(gcf,'Bar_Earnings')

%% Plot offers

data = [mean(DG_P_Offers), mean(UG_P_Raw_Offers)]; 
x = linspace(1,2,2);
fig = figure
x1 = bar(x(1),data(1));
x1.LineWidth= 2.5
hold on
x2 = bar(x(2),data(2));
x2.LineWidth= 2.5
colormap('jet')

ax = gca;
ax.FontSize = 12;
box off
xlabel ('Tasks', 'FontSize', 16);
ylabel  ('Average Offers Made Across Subjects', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:2, 'XTickLabels', {'DG-P', 'UG-P'})

hold on

% Standard Error

B1Er = std(DG_P_Offers) / sqrt(length(DG_P_Offers));
B2Er = std(UG_P_Raw_Offers) / sqrt(length(UG_P_Raw_Offers));


err = [B1Er,B2Er] * 2;

er = errorbar(x,data,err); 
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 2.5;
hold off

saveas(gcf,'Bar_Offers.tif')

%% Plot proportions chosen

data = [mean(DG_P_Prop), mean(UG_P_Raw_Props)]; 
x = linspace(1,2,2);
fig = figure
x1 = bar(x(1),data(1));
x1.LineWidth= 2.5
hold on
x2 = bar(x(2),data(2));
x2.LineWidth= 2.5
colormap('jet')

ax = gca;
ax.FontSize = 12;
box off
xlabel ('Tasks', 'FontSize', 16);
ylabel  ('Offers', 'FontSize', 16);
title ('Mean Endowment Offered By Participants')
set(gcf,'color','w');
set(gca, 'XTick', 1:2, 'XTickLabels', {'DG-P', 'UG-P'})

hold on

% Standard Error

B1Er = std(DG_P_Prop) / sqrt(length(DG_P_Prop));
B2Er = std(UG_P_Raw_Props) / sqrt(length(UG_P_Raw_Props));


err = [B1Er,B2Er] * 2;

er = errorbar(x,data,err); 
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 2.5;
hold off

saveas(gcf,'Bar_Props.tif')


%% Strategic Behavior

% We will define this as the difference in offers between UG and DG.

Strategic_Behavior = UG_P_Raw_Props- DG_P_Prop;

%Total_Earnings = DG_P_Earnings + UG_P_Raw_Earnings + UG_R_Earnings;
% 
% Total_Earnings = DG_P_Earnings + UG_P_Raw_Earnings + UG_R_Earnings; % Similar to strategic behavior
% 
% figure
% histogram(Total_Earnings, 14)
% ylim('auto');
% ax = gca;
% ax.FontSize = 9;
% xlabel ('Total Earnings','FontSize', 16)
% ylabel ('Frequency','FontSize', 16)
% set(gca,'box','off')
% set(gcf,'color','w');
% 
% 
% saveas(gcf,'Total_Earnings.png')
% 
% %% Read in EI and PNR 
% 
% if make_attitudes == 1
%     
% data = readtable(input_behavioral);
% 
% TEIQUE_raw = [data.('ID'), data.('score_tei_globaltrait')];
% PNR_raw = [data.('ID'), data.('score_pnr_total')];
% 
% % Eliminate Nans
% 
% eliminate_rows = any(isnan(TEIQUE_raw),2);
% TEIQUE_temp = [];
% 
% for ii = 1:length(TEIQUE_raw)
%     keep = [];
%     row = TEIQUE_raw(ii,:);
%     if eliminate_rows(ii) == 0
%         keep = row;
%     end
%     TEIQUE_temp = [TEIQUE_temp; keep];
% end
% 
% eliminate_rows = any(isnan(PNR_raw),2);
% PNR_temp = [];
% 
% for ii = 1:length(PNR_raw)
%     keep = [];
%     row = PNR_raw(ii,:);
%     if eliminate_rows(ii) == 0
%         keep = row;
%     end
%     PNR_temp = [PNR_temp; keep];
% end
%  
% TEIQUE_missing = [];
% TEIQUE_final = [];
% for ii = 1:length(subjects)
%     subj = subjects(ii);
%     subj_row = find(TEIQUE_temp==subj);
%     if subj_row > 0
%         test = TEIQUE_temp(subj_row,:);
%         if test(2) < 100
%             TEIQUE_final = [TEIQUE_final;test];
%         else
%             TEIQUE_missing = [TEIQUE_missing; subjects(ii)];
%         end
%     end
%     
% end
% 
% PNR_missing = [];
% PNR_final = [];
% 
% for ii = 1:length(subjects)
%     subj = subjects(ii);
%     subj_row = find(PNR_temp==subj);
%     if subj_row > 0
%         test = PNR_temp(subj_row,:);
%         if test(2) < 100
%             PNR_final = [PNR_final;test];
%         else
%             PNR_missing = [PNR_missing; subjects(ii)];
%         end
%     end
%     
% end

    
%% DG-P logistic regression

subject_combined_rejections = [];
missing_reject = [];
subject_combined_acceptances = [];
missing_accept = [];
missing_data=[];
badsubject = [];
Betas = [];
Pvals = [];
save_X = [];
save_Y = [];
sub_prop = [];
Cor_Endow_DeltaP=[];
Cor_Endow_Intercept=[];
Cor_DeltaP_Intercept= [];

for ii = 1:length(subjects)
    S = [];
    T = [];
    try
        name = ['Subject_' num2str(subjects(ii)) '_DGP.csv'];
        input = [input_folder,name];
        T = readtable(input);
    catch
        missing_data = [missing_data, subjects(ii)];
    end
    try
        subject_DGP = [T];
        Y = subject_DGP.Decision;
        
    end
    
    %X = [subject_DGP.Endowment,subject_DGP.More_Prop-subject_DGP.Less_Prop,((subject_DGP.More_Prop+subject_DGP.Less_Prop)/2)];
    X = [subject_DGP.Endowment,((subject_DGP.More_Prop+subject_DGP.Less_Prop)/2)];
    X = zscore(X);
    %endowprop = X(:,1).*X(:,2);
    %X = [X, endowprop];
    save_X = [save_X; X];
    save_Y = [save_Y; Y];
    
    [B,DEV,STATS] = glmfit(X,Y,'binomial','link','logit');
    coeff=STATS.coeffcorr;
    Cor_Endow_DeltaP=[Cor_Endow_DeltaP; coeff(2,3)];
    Cor_Endow_Intercept=[Cor_Endow_Intercept; coeff(1,2)];
    Cor_DeltaP_Intercept= [Cor_DeltaP_Intercept; coeff(1,3)];
    

    Betas = [Betas, B];
    
  
end


save = [];
dump = [];
% [B,DEV,STATS] = glmfit(save_X,save_Y,'binomial','link','logit');
%save_Y=categorical(save_Y);
[B,DEV,STATS] = glmfit(save_X,save_Y,'binomial','link','logit');
se=STATS.se;

data = [B(1), B(2), B(3)]; %, B(4), B(5)];
x = linspace(1,3,3);
figure
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Regressors', 'FontSize', 16);
ylabel  ('Z-standardized Beta Weight', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:3, 'XTickLabels', {'Intercept', 'Endowment', 'Average between offers'})
title('Does Endowment and Offers Predict DG-P More/Less Choices?')

hold on

% Standard Error

B1Er = se(1);
B2Er = se(2);
B3Er = se(3);
%B4Er = se(4);
%B5Er = se(5);

err = [B1Er,B2Er,B3Er] * 2;

er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 1;
hold off

saveas(gcf,'Bar_DGP.png')

%% Correlation DGP bar plot.

data = [mean(Cor_Endow_DeltaP), mean(Cor_Endow_Intercept), mean(Cor_DeltaP_Intercept)];
x = linspace(1,3,3);
figure
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Regressors', 'FontSize', 16);
ylabel  ('R subjects', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:3, 'XTickLabels', {'Endowment & DeltaP', 'Endowment & Intercept', 'Delta P & Intercept'})
title('Correlation Between DGP Regressors')

hold on

% Standard Error

B1Er = std(Cor_Endow_DeltaP(:,1)) / sqrt(length((Cor_Endow_DeltaP(:,1))));
B2Er = std(Cor_Endow_Intercept(:,1)) / sqrt(length((Cor_Endow_Intercept(:,1))));
B3Er = std(Cor_DeltaP_Intercept(:,1)) / sqrt(length((Cor_DeltaP_Intercept(:,1))));
%B4Er = se(4);
%B5Er = se(5);

err = [B1Er,B2Er,B3Er] * 2;

er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 1;
hold off

saveas(gcf,'Bar_DGP_corrs.png')

% %% DGP High/low analysis
% 
% subject_combined_rejections = [];
% missing_reject = [];
% subject_combined_acceptances = [];
% missing_accept = [];
% missing_subject = [];
% badsubject = [];
% Betas = [];
% Pvals = [];
% save_X = [];
% save_Y = [];
% sub_prop = [];
% 
% subs = [1300]; %Subject 1300 chooses More a lot. Subject 3200 chooses less ALL the time. 
% for ii = 1:length(subs)
%     S = [];
%     T = [];
%    try
%         name = ['Subject_' num2str(subs(ii)) '_DGP.csv'];
%         input = [input_folder,name];
%         T = readtable(input);
%     catch
%         missing_data = [missing_data, subs(ii)];
%     end
%     try
%         subject_DGP = [T];
%         sub_p = [subs(ii), mean(T.Less_Prop)];
%         sub_prop = [sub_prop; sub_p]; % sub 3200 chooses more for greatest average of low offers. sub 1300 chooses more for the lowest average of low offers.
%         
%         
%     catch
%         missing_subject = [missing_subject, subs(ii)];
%     end
%     try
%         Y = categorical(subject_DGP.Decision);
%     end
%     
%      
%     X = [subject_DGP.Endowment, subject_DGP.More_Prop, subject_DGP.Less_Prop];
%     X = zscore(X);
%     save_X = [save_X; X];
%     save_Y = [save_Y; Y];
% %     try
%     
%     %[B,dev,stats] = mnrfit(X, Y); % Given the Endowment, proportion of endowment, can we predict accept/reject?
%     %Betas = [Betas, B];
%     %Pvals = [Pvals, stats.p];
% %     catch
% %         badsubject = [badsubject,subjects(ii)];
% %     
% %     end
% 
% %[B,dev,stats] = mnrfit(save_X, save_Y); % Given the Endowment, proportion of endowment, can we predict accept/reject?
%    %b = glmfit(X,Y,'binomial','link','logit'); 
%    save = [];
%    dump = [];
%    [B,DEV,STATS] = glmfit(save_X,save_Y,'binomial','link','logit');
%    se=STATS.se;
%    
%    data = [B(1),B(2),B(3),B(4)];
%    x = linspace(1,4,4);
%    figure
%    bar(x,data)
%    ax = gca;
%    ax.FontSize = 12;
%    box off
%    xlabel ('Regressors', 'FontSize', 16);
%    ylabel  ('Z-standardized Beta Weight', 'FontSize', 16);
%    set(gcf,'color','w');
%    set(gca, 'XTick', 1:4, 'XTickLabels', {'Intercept', 'Endowment', 'More Proportion', 'Less Proportion'})
%    title('Does Endowment/Prop Predict DGP Accept/Reject Choices?')
%    
%    hold on
%    
%    % Standard Error
%    
%    B1Er = se(1);
%    B2Er = se(2);
%    B3Er = se(3);
%    B4er = se(4);
%    
%    err = [B1Er,B2Er,B3Er,B4er] * 2;
%    
%    er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
%    er.Color = [0 0 0];
%    er.LineStyle = 'none';
%    er.LineWidth = 1;
%    hold off
%    
%    saveas(gcf,'Bar_DGP.png')
%     
%    
%    [R,P] = corrcoef(subject_DGP.Endowment, subject_DGP.Decision);
%    figure
%    scatter(subject_DGP.Endowment, subject_DGP.Decision,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
%    ax = gca;
%    ax.FontSize = 12;
%    title (['Subject ' num2str(subs(ii))])
%    xlabel ('Endowment', 'FontSize', 16);
%    ylabel  ('Choice', 'FontSize', 16);
%    i = lsline;
%    i.LineWidth = 5;
%    i.Color = [0 0 0];
%    set(gcf,'color','w');
%    
%    [R,P] = corrcoef(subject_DGP.Endowment, subject_DGP.Less_Prop);
%    figure
%    scatter(subject_DGP.Endowment, subject_DGP.Decision,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
%    ax = gca;
%    ax.FontSize = 12;
%    title (['Subject ' num2str(subs(ii))])
%    xlabel ('Less Proportion', 'FontSize', 16);
%    ylabel  ('Choice', 'FontSize', 16);
%    i = lsline;
%    i.LineWidth = 5;
%    i.Color = [0 0 0];
%    set(gcf,'color','w');
%    
% end


    

    

% %% UG-P logistic regression
% 
% subject_combined_rejections = [];
% missing_reject = [];
% subject_combined_acceptances = [];
% missing_accept = [];
% missing_data=[];
% badsubject = [];
% Betas = [];
% Pvals = [];
% save_X = [];
% save_Y = [];
% sub_prop = [];
% 
% for ii = 1:length(subjects)
%     S = [];
%     T = [];
%     try
%         name = ['Subject_' num2str(subjects(ii)) '_UGP.csv'];
%         input = [input_folder,name];
%         T = readtable(input);
%         
%         name = ['Subject_' num2str(subjects(ii)) '_UGP_2.csv'];
%         input = [input_folder,name];
%         S = readtable(input);
%         
%     catch
%         missing_data = [missing_data, subjects(ii)];
%     end
%     try
%         subject_UGP = [S;T];
%         Y = subject_UGP.Decision;
%         
%     end
%     
%     X = [subject_UGP.Endowment, subject_UGP.More_Prop-subject_UGP.Less_Prop];
%     X = zscore(X);
%     save_X = [save_X; X];
%     save_Y = [save_Y; Y];
%     try
%     %[b,dev,stats] = mnrfit(X, Y); % Given the Endowment, proportion of endowment, can we predict accept/reject?
%     %b = glmfit(X,Y,'binomial','link','logit');
%     Betas = [Betas, b];
%     Pvals = [Pvals, stats.p];
%     catch
%         badsubject = [badsubject,subjects(ii)];
%     end
% end
% 
% 
% save = [];
% dump = [];
% [B,DEV,STATS] = glmfit(save_X,save_Y,'binomial','link','logit');
% se=STATS.se;
% 
% data = [B(1), B(2), B(3)];
% x = linspace(1,3,3);
% figure
% bar(x,data)
% ax = gca;
% ax.FontSize = 12;
% box off
% xlabel ('Regressors', 'FontSize', 16);
% ylabel  ('Z-standardized Beta Weight', 'FontSize', 16);
% set(gcf,'color','w');
% set(gca, 'XTick', 1:3, 'XTickLabels', {'Intercept', 'Endowment', 'Delta P'})
% title('Does Endowment and Offers Predict UG-P More/Less Choices?')
% 
% hold on
% 
% % Standard Error
% 
% B1Er = se(1);
% B2Er = se(2);
% B3Er = se(3);
% %B4Er = se(4);
% 
% err = [B1Er,B2Er,B3Er] * 2;
% 
% er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
% er.Color = [0 0 0];
% er.LineStyle = 'none';
% er.LineWidth = 1;
% hold off
% 
% saveas(gcf,'Bar_UGP.png')

%% UG-P logistic regression

subject_combined_rejections = [];
missing_reject = [];
subject_combined_acceptances = [];
missing_accept = [];
missing_data=[];
badsubject = [];
Betas = [];
Pvals = [];
save_X = [];
save_Y = [];
sub_prop = [];
Cor_Endow_DeltaP=[];
Cor_Endow_Intercept=[];
Cor_DeltaP_Intercept= [];

for ii = 1:length(subjects)
    S = [];
    T = [];
        try
            name = ['Subject_' num2str(subjects(ii)) '_UGP.csv'];
            input = [input_folder,name];
            S = readtable(input);
            name = ['Subject_' num2str(subjects(ii)) '_UGP2.csv'];
            input = [input_folder,name];
            T = readtable(input);
            subject_UGP = [S;T];
         
        catch
            missing_data = [missing_data, subjects(ii)];
        end

        X = [subject_UGP.Endowment,((subject_UGP.More_Prop+subject_UGP.Less_Prop)/2)];
        X = zscore(X);
        
        Y = subject_UGP.Decision;
        save_X = [save_X; X];
        save_Y = [save_Y; Y];
        
        [B,DEV,STATS] = glmfit(X,Y,'binomial','link','logit');
        coeff=STATS.coeffcorr;
        Cor_Endow_DeltaP=[Cor_Endow_DeltaP; coeff(2,3)];
        Cor_Endow_Intercept=[Cor_Endow_Intercept; coeff(1,2)];
        Cor_DeltaP_Intercept= [Cor_DeltaP_Intercept; coeff(1,3)];
    
end


save = [];
dump = [];
[B,DEV,STATS] = glmfit(save_X,save_Y,'binomial','link','logit');
se=STATS.se;

data = [B(1), B(2), B(3)]; %, B(4), B(5)];
x = linspace(1,3,3);
figure
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Regressors', 'FontSize', 16);
ylabel  ('Z-standardized Beta Weight', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:3, 'XTickLabels', {'Intercept', 'Endowment', 'Average Offers'})
title('Does Endowment and Offers Predict UG-P More/Less Choices?')

hold on

% Standard Error

B1Er = se(1);
B2Er = se(2);
B3Er = se(3);
%B4Er = se(4);
%B5Er = se(5);

err = [B1Er,B2Er,B3Er] * 2;

er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 1;
hold off

saveas(gcf,'Bar_UGP.png')

%% Correlation UGP bar plot.

data = [mean(Cor_Endow_DeltaP), mean(Cor_Endow_Intercept), mean(Cor_DeltaP_Intercept)];
x = linspace(1,3,3);
figure
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Regressors', 'FontSize', 16);
ylabel  ('R subjects', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:3, 'XTickLabels', {'Endowment & DeltaP', 'Endowment & Intercept', 'Delta P & Intercept'})
title('Correlation Between UGP Regressors')

hold on

% Standard Error

B1Er = std(Cor_Endow_DeltaP(:,1)) / sqrt(length((Cor_Endow_DeltaP(:,1))));
B2Er = std(Cor_Endow_Intercept(:,1)) / sqrt(length((Cor_Endow_Intercept(:,1))));
B3Er = std(Cor_DeltaP_Intercept(:,1)) / sqrt(length((Cor_DeltaP_Intercept(:,1))));
%B4Er = se(4);
%B5Er = se(5);

err = [B1Er,B2Er,B3Er] * 2;

er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 1;
hold off

saveas(gcf,'Bar_UGP_corrs.png')
    
%% Combine tasks in model.

% Import results.
% Combine into single matrix
% Add +1 for DG and -1 for UG
% Generate interaction effects. 

% Import data:

missing_data=[];
save_X = [];
save_Y = [];
Cor_Endow_DeltaP=[];
Cor_Endow_Intercept=[];
Cor_DeltaP_Intercept= [];
Main_Effects = [];
subject_regressor = [];

for ii = 1:length(subjects)
    S = [];
    T = [];

        try
            name = ['Subject_' num2str(subjects(ii)) '_UGP.csv'];
            input = [input_folder,name];
            S = readtable(input);
            name = ['Subject_' num2str(subjects(ii)) '_UGP2.csv'];
            input = [input_folder,name];
            T = readtable(input);
            subject_UGP=[S;T];
            
            name = ['Subject_' num2str(subjects(ii)) '_DGP.csv'];
            input = [input_folder,name];
            U = readtable(input);
            subject_DGP = [U];
            
        catch
            missing_data = [missing_data, subjects(ii)];
        end
        
        % Generate regressors
        
        UG_X = [subject_UGP.Endowment,(subject_UGP.More_Prop-subject_UGP.Less_Prop)]; % Generate endowment and delta P.
        DG_X = [subject_DGP.Endowment,(subject_DGP.More_Prop-subject_DGP.Less_Prop)];
        X = zscore([UG_X;DG_X]); % z scores demeans
        
        % Add Task regressor and Interaction of Task/Endowment, Task/Delta
        % P. DG is 1 and UG is -1.
        
        [N,M]= size(UG_X);
        UG_mat = 0*(ones(N,1)); % UG is coded as 0
        
        [N,M]= size(DG_X);
        DG_mat = ones(N,1); % DG is coded as 0
        
        task_regressor = [UG_mat; DG_mat];
        
        [N,M]= size(task_regressor);
        
        regessor_mat = ones(N,1);
        regessor_mat = regessor_mat*subjects(ii);

        subject_regressor = [subject_regressor; regessor_mat];
        
        % Generate interaction of task regressor and endowment and delta p.
        
        endow_int = task_regressor.*X(:,1);
        deltaP_int = task_regressor.*X(:,2);
        %mean_int = task_regressor.*X(:,3);
        
        % Concatenate into regressor matrix.
        Main_Effects_part = [task_regressor, X];
        X = [task_regressor, X, endow_int, deltaP_int]; 
        Y = [subject_UGP.Decision;subject_DGP.Decision];
        
        % Loop over all of the participants.
        save_X = [save_X; X];
        save_Y = [save_Y; Y];
        Main_Effects = [Main_Effects; Main_Effects_part];
        
%         % Save correlations of regressors across participants.

%         [B,DEV,STATS] = glmfit(X,Y,'binomial','link','logit');
%         coeff=STATS.coeffcorr;
%         Cor_Endow_DeltaP=[Cor_Endow_DeltaP; coeff(2,3)];
%         Cor_Endow_Intercept=[Cor_Endow_Intercept; coeff(1,2)];
%         Cor_DeltaP_Intercept= [Cor_DeltaP_Intercept; coeff(1,3)];
end


% Run logistic regression.

[B,DEV,STATS] = glmfit(save_X,save_Y,'binomial','link','logit');
%Y=categorical(save_Y)
%[B,dev,stats] = mnrfit(save_X,Y);
se=STATS.se; 
data = [B(1), B(2), B(3), B(4), B(5), B(6)]; % Intercept, Task, Endowment, Delta P, Endow Interaction, Delta P interaction.
x = linspace(1,6,6);
figure
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Regressors', 'FontSize', 16);
ylabel  ('Z-standardized Beta Weight', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:6, 'XTickLabels', {'Intercept', 'Task', 'Endowment', 'Delta P', 'Task*Endow', 'Task*DeltaP'})
title('Does Endowment and Offers Predict Proposer More/Less Choices?')

hold on

% Standard Error

B1Er = se(1);
B2Er = se(2);
B3Er = se(3);
B4Er = se(4);
B5Er = se(5);
B6Er = se(6);
%B7Er = se(7);
%B8Er = se(8);


err = [B1Er,B2Er,B3Er,B4Er,B5Er,B6Er] * 2;

er = errorbar(x,data,err); 
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 1;
hold off

saveas(gcf,'Bar_proposer.png')

%% Mixed effects model


tb1 = array2table(Main_Effects(1:end,:),'VariableNames', {'x1','x2','x3'}); %x1 is Task, x2 is Endowment, and x3 is Delta P. 
tb2 = array2table(save_Y,'VariableNames', {'y'});
tb3 = array2table(subject_regressor,'VariableNames', {'subject'});
mixed_effects = [tb2, tb3, tb1];

% xs are fixed effects
% () are random effects 

% Subjects are a random effect. Need a different intercept for each subject
% due to different tastes. 

% Add a subj number column to mixed effects and use as a random effect.
% Use a random intercept first. Then random slope. 

% Use * for interactions. Check syntax. 

% y ~ x1 + x2 + x3 + intA + intB + (1 | subject) % Random intercept. Shift
% in preferences from less to more? Controls individual differences across.

% Null model.

% y ~ 1 + (1 | subject) vs. model. Is there a difference? 

% Run an ANOVA between the outputs. 

% Maybe add counterbalance order as a random effect

% Slope is how quick change in attitude.

% y ~ x1 + x2 + x3 + intA + intB + (x1 | subject) + (x2 | subject) + (x3 | subject)


% Where y is "predictor", x1 is Task, x2 is Endowment, and x3 is Delta P. 


random_intercept_model = fitlme(mixed_effects,'y ~ x1 + x2 + x3 + x1:x2 + x1:x3 + (1 | subject)');
null_intercept = fitlme(mixed_effects,'y ~ 1 + (1 | subject)');

[TABLE,SIMINFO] = compare(null_intercept, random_intercept_model)

random_slope_model = fitlme(mixed_effects,'y ~ x1 + x2 + x3 + x1:x2 + x1:x3 + (x1 | subject) + (x2 | subject) + (x3 | subject)');
null_slope = fitlme(mixed_effects,'y ~ 1 + (x1 | subject) + (x2 | subject) + (x3 | subject)');

[TABLE,SIMINFO] = compare(null_slope, random_slope_model)
