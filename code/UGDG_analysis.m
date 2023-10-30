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
input_folder = [currentdir '/output/'];

subjects_all = readtable('newsubs.txt');
subjects = table2array(subjects_all);

%input_behavioral = 'ISTART-ALL-Combined-042122.xlsx'; % input file  
%motion_input = 'motion_data_input.xls';

make_full = 1; % Reads in all subjects. Outputs subs, ones, strategic behavior, tsnr, fd means.


%% Subs for full subject N, strat behavior, and motion.

% This is the full pool of subjects. 

% 1002 and 1243 excluded for now (failed preprocessing) 

if make_full == 1
    values = subjects


%% UG_R earnings

subjects = values;
UG_R_Earnings = [];
UG_R_reject = [];
UG_R_accept = [];
missing_subject  = [];
UG_R_reject_rate = [];

for jj = 1:length(subjects)
    
    try
    save_value = [];
    UG_R_reject_rate_part = [];
    name = ['Subject_' num2str(subjects(jj)) '_accept_analysis.csv'];
    input = [input_folder,name];
    U = readtable(input);
    UG_R_Earnings = [UG_R_Earnings; sum(U.Earned)]; % Sum acceptances.
    UG_R_accept = [UG_R_accept; mean(U.Offer./U.Endowment)]; % Average accepted
    
    catch 
        missing_subject = [missing_subject, subjects(jj)];
    end
        
    try
    name = ['Subject_' num2str(subjects(jj)) '_reject_analysis.csv'];
    input = [input_folder,name];
    V = readtable(input);
    
    UG_R_reject = [UG_R_reject; mean(V.Offer./V.Endowment)]; % Average rejected
    UG_R_reject_rate_part = sum(U.Choice)/24; % reject rate
    
    catch
        UG_R_reject_rate_part = 1; % reject rate
        missing_subject = [missing_subject, subjects(jj)];
    end
    
    UG_R_reject_rate = [UG_R_reject_rate;UG_R_reject_rate_part];
end




%% UGR Offers accepted/rejected

data = [mean(UG_R_accept), mean(UG_R_reject)]; 
x = linspace(1,2,2);
fig = figure
x1 = bar(x(1),data(1));
x1.LineWidth= 2.5
hold on
x2 = bar(x(2),data(2));
x2.LineWidth= 2.5
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Decisions', 'FontSize', 16);
ylabel  ('Offered Proportion', 'FontSize', 16);
title ('Mean Endowment Accepted/Rejected in UG-R')
set(gcf,'color','w');
set(gca, 'XTick', 1:2, 'XTickLabels', {'Accepted', 'Rejected'})

hold on

% Standard Error

B1Er = std(UG_R_accept) / sqrt(length(UG_R_accept));
B2Er = std(UG_R_reject) / sqrt(length(UG_R_reject));


err = [B1Er,B2Er] * 2;

er = errorbar(x,data,err); 
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 2.5;
hold off

saveas(gcf,'Bar_Props.tif')



% %% Read in the tsr and means 
% 
% % Find the columns you will need.
% 
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




%% How often do participants reject offers?

figure

h = histogram(UG_R_reject_rate(:));
counts = h.Values;
h.NumBins = 5;
ax = gca;
ax.FontSize = 9;
xlabel ('Rate of Rejections as a Recipient','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off');
set(gcf,'color','w');


%% Do subjects reject unfair offers?

% Collect all the UG-R offers
% Define level of endowment
% Define proportion of endowment offered
% Define decision (1 = accept, 0 = reject)

subject_combined_rejections = [];
missing_reject = [];
subject_combined_acceptances = [];
missing_accept = [];
missing_subject = [];
badsubject = [];
Betas = [];
Pvals = [];
save_X = [];
save_Y = [];
sub_prop = [];
for ii = 1:length(values)
    S = [];
    T = [];
    try
        name = ['Subject_' num2str(values(ii)) '_reject_analysis.csv'];
        input = [input_folder,name];
        T = readtable(input);
        subject_combined_rejections = [subject_combined_rejections;  T.Endowment, T.Prop_Endowment];
    catch
        missing_reject = [missing_reject, values(ii)];
    end
    try
        name = ['Subject_' num2str(values(ii)) '_accept_analysis.csv'];
        input = [input_folder,name];
        S = readtable(input);
        subject_combined_acceptances = [subject_combined_acceptances; S.Endowment, S.Prop_Endowment];
    catch
        missing_accept = [missing_accept, values(ii)];
    end
    try
        subject_UGR = [S;T];
        sub_p = [values(ii), mean(T.Prop_Endowment)];
        sub_prop = [sub_prop; sub_p]; % sub 3125 rejects high P of offers. sub 1294 rejections low P offers
        
        
    catch
        missing_subject = [missing_subject, values(ii)];
    end
    try
        %Y = categorical(subject_UGR.Choice);
        Y = subject_UGR.Choice;
        
    end
    
    X = [subject_UGR.Endowment, subject_UGR.Prop_Endowment];
    X = zscore(X);
    save_X = [save_X; X];
    save_Y = [save_Y; Y];
    try
    %[B,dev,stats] = mnrfit(X, Y); % Given the Endowment, proportion of endowment, can we predict accept/reject?
%     b = glmfit(X,Y,'binomial','link','logit');
%     Betas = [Betas, b];
%     Pvals = [Pvals, stats.p];
    catch
        badsubject = [badsubject,values(ii)];
    end
end


save = [];
dump = [];
%save_Y=categorical(save_Y);
[B,DEV,STATS] = glmfit(save_X,save_Y,'binomial','link','logit'); %mnrfit(save_X,save_Y)
se=STATS.se;

data = [mean(B(1,:));  mean(B(2,:));  mean(B(3,:))];
x = linspace(1,3,3);
figure
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Regressors', 'FontSize', 16);
ylabel  ('Z-standardized Beta Weight', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:3, 'XTickLabels', {'Intercept', 'Endowment', 'Proportion'});
title('Does Endowment Predict UG-R Accept/Reject Choices?')

hold on

% Standard Error

B1Er = se(1);
B2Er = se(2);
B3Er = se(3);

err = [B1Er,B2Er,B3Er] * 2;

er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 1;
hold off

saveas(gcf,'Bar_UGR.png')

%% UGR High/low analysis.

subject_combined_rejections = [];
missing_reject = [];
subject_combined_acceptances = [];
missing_accept = [];
missing_subject = [];
badsubject = [];
Betas = [];
Pvals = [];
save_X = [];
save_Y = [];
sub_prop = [];

subs = [3125] % Subject 1294 ACCEPTS almost all offers.  Subject 3125 REJECTS almost all offers. 
for ii = 1:length(subs)
    S = [];
    T = [];
    try
        name = ['Subject_' num2str(subs(ii)) '_reject_analysis.csv']
        input = [input_folder,name];
        T = readtable(input);
        subject_combined_rejections = [subject_combined_rejections;  ([T.Endowment, T.Prop_Endowment])];
    catch
        missing_reject = [missing_reject, subs(ii)];
    end
    try
        name = ['Subject_' num2str(subs(ii)) '_accept_analysis.csv'];
        input = [input_folder,name];
        S = readtable(input);
        subject_combined_acceptances = [subject_combined_acceptances; S.Endowment, S.Prop_Endowment];
    catch
        missing_accept = [missing_accept, subs(ii)];
    end
    try
        subject_UGR = [S;T];
        sub_p = [subs(ii), mean(T.Prop_Endowment)];
        sub_prop = [sub_prop; sub_p]; % sub 3125 rejects high P of offers. sub 1294 rejections low P offers
        
        
    catch
        missing_subject = [missing_subject, subs(ii)];
    end
    try
        Y = categorical(subject_UGR.Choice);
    end
    
     
    X = [subject_UGR.Endowment, subject_UGR.Prop_Endowment];
    X = zscore(X);
    save_X = [save_X; X];
    save_Y = [save_Y; Y];
    try
    %[B,dev,stats] = mnrfit(X, Y); % Given the Endowment, proportion of endowment, can we predict accept/reject?
%     b = glmfit(X,Y,'binomial','link','logit');
%     Betas = [Betas, b];
%     Pvals = [Pvals, stats.p];
    catch
        badsubject = [badsubject,values(ii)];
    
end
    
   save = [];
   dump = [];
   save_Y=categorical(save_Y);
   %[B,DEV,STATS] = glmfit(X,Y,'binomial','link','logit');
   se=STATS.se;
   
   data = [mean(B(1,:));  mean(B(2,:));  mean(B(3,:))];
   x = linspace(1,3,3);
   figure
   bar(x,data)
   ax = gca;
   ax.FontSize = 12;
   box off
   xlabel ('Regressors', 'FontSize', 16);
   ylabel  ('Z-standardized Beta Weight', 'FontSize', 16);
   set(gcf,'color','w');
   set(gca, 'XTick', 1:3, 'XTickLabels', {'Intercept', 'Endowment', 'Proportion'})
   title('Does Endowment Predict UG-R Accept/Reject Choices?')
   
   hold on
   
   % Standard Error
   
   B1Er = se(1)
   B2Er = se(2)
   B3Er = se(3)
   
   err = [B1Er,B2Er,B3Er] * 2;
   
   er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
   er.Color = [0 0 0];
   er.LineStyle = 'none';
   er.LineWidth = 1;
   hold off
   
   saveas(gcf,'Bar_UGR.png')
    
    [R,P] = corrcoef(subject_UGR.Endowment, subject_UGR.Choice);
    figure
    scatter(subject_UGR.Endowment, subject_UGR.Choice,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
    ax = gca;
    ax.FontSize = 12;
    title (['Subject ' num2str(subs(ii))])
    xlabel ('Endowment', 'FontSize', 16);
    ylabel  ('Choice', 'FontSize', 16);
    i = lsline;
    i.LineWidth = 5;
    i.Color = [0 0 0];
    set(gcf,'color','w');
    
    [R,P] = corrcoef(subject_UGR.Prop_Endowment, subject_UGR.Choice);
    figure
    scatter(subject_UGR.Prop_Endowment, subject_UGR.Choice,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
    ax = gca;
    ax.FontSize = 12;
    title (['Subject ' num2str(subs(ii))])
    xlabel ('Proportion', 'FontSize', 16);
    ylabel  ('Choice', 'FontSize', 16);
    i = lsline;
    i.LineWidth = 5;
    i.Color = [0 0 0];
    set(gcf,'color','w');
    
    
end
    
