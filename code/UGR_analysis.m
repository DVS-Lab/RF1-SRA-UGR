clear all
close all
clc

% This code imports subject earnings (across conditions) and their
% individual difference measures and analyzes the data. 

% Daniel Sazhin
% 06/07/23
% DVS Lab
% Temple University
currentdir = pwd;
input_folder = [currentdir '\output\'];

subjects_all = readtable('newsubs.txt');
subjects = table2array(subjects_all);

input_behavioral = 'v2.2_SFN_Covariates.xls'; % input file  
%motion_input = 'motion_data_input.xls';

make_full = 1; % Reads in all subjects. Outputs subs, ones, strategic behavior, tsnr, fd means.


%% Subs for full subject N, strat behavior, and motion.

% This is the full pool of subjects. 
% 
% 
% if make_full == 1
%     values = [10317
% 10369
% 10402
% 10418
% 10429
% 10462
% 10478
% 10486
% 10529
% 10541
% 10555
% 10572
% 10581
% 10584
% 10585
% 10589
% 10590
% 10596
% 10603
% 10606
% 10608
% 10617
% 10636
% 10638
% 10641
% 10642
% 10644
% 10647
% 10649
% 10652
% 10656
% 10657
% 10659
% 10663
% 10673
% 10674
% 10677
% 10685
% 10690
% 10691
% 10700
% 10701
% 10716
% 10720
% 10723
% 10741
% 10774
% 10777
% 10781
% 10783
% 10800
% 10804];
% 
% end
% 
values = subjects;
%% UG_R earnings

UG_R_Earnings = [];
UG_R_reject = [];
UG_R_accept = [];
missing_subject  = [];
UG_R_reject_rate = [];
nonsocial_beta = [];
social_beta = [];
nonsocialfit = [];
socialfit = [];
social_fit = [];
nonsocial_fit = [];


for jj = 1:length(subjects)
    
    nonsocial_accept = [];
    social_accept = [];
    nonsocial_reject = [];
    social_reject = [];

    try
        save_value = [];
        UG_R_reject_rate_part = [];
        name = ['Subject_' num2str(subjects(jj)) '_accept_analysis.csv'];
        input = [input_folder,name];
        U = readtable(input);
        
        [K,~]=size(U);
        
        
        for kk = 1:K
            row = U(kk,:);
            test = row.Block;
            if round(test) == 2
                nonsocial_accept = [nonsocial_accept; row];
            end
            
            if round(test) == 3
                social_accept = [social_accept; row];
            end
        end

        
        save_value = [];
        name = ['Subject_' num2str(subjects(jj)) '_reject_analysis.csv'];
        input = [input_folder,name];
        V = readtable(input);
        
        [K,~]=size(V);
        
        
        for kk = 1:K
            row = V(kk,:);
            test = row.Block;
            if round(test) == 2
                nonsocial_reject = [nonsocial_reject; row];
            end
            
            if round(test) == 3
                social_reject = [social_reject; row];
            end
        end
        
        social_proportion = [social_reject.Prop_Endowment;social_accept.Prop_Endowment];
        nonsocial_proportion = [nonsocial_reject.Prop_Endowment;nonsocial_accept.Prop_Endowment];
        social_decision = [social_reject.Choice;social_accept.Choice];
        nonsocial_decision = [nonsocial_reject.Choice;nonsocial_accept.Choice];
        
        [B,DEV,STATS] = glmfit(social_proportion,social_decision,'binomial','link','logit'); %mnrfit(save_X,save_Y)
        socialfit = polyfit(social_proportion,social_decision, 1);
        savesocial = [subjects(ii), B(2)];
        social_beta = [social_beta; savesocial];
  
        savesocialfit = [subjects(ii), socialfit(1)];
        social_fit = [social_fit; savesocialfit];
        
        [B,DEV,STATS] = glmfit(nonsocial_proportion,nonsocial_decision,'binomial','link','logit'); %mnrfit(save_X,save_Y)
        nonsocialfit = polyfit(nonsocial_proportion,nonsocial_decision, 1);
        savenonsocial = [subjects(ii), B(2)];
        nonsocial_beta = [nonsocial_beta; savenonsocial];
        savenonsocialfit = [subjects(ii), nonsocialfit(1)]; 
        nonsocial_fit = [nonsocial_fit; savenonsocialfit];
        
    catch
        missing_subject = [missing_subject, subjects(jj)];
    end
end

% Pull in same subjects to find raw age value

input_behavioral = 'v2.2_SFN_Covariates.xls'; % input file  
data = readtable(input_behavioral);
cov_data = [data.sub_id, data.sub_age, data.oafem_total, data.sub_age];

behavioral_data = [];

for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(cov_data==subj);
    save = cov_data(subj_row,:);
    behavioral_data = [behavioral_data;save];
end


% scatter betas with age.

% figure
% scatter(behavioral_data(:,2), nonsocial_beta(:,2), 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
% 
% hold on
% 
% scatter(behavioral_data(:,2), social_beta(:,2), 'MarkerEdgeColor',[0 1 1],'MarkerFaceColor',[0 1 .1],'LineWidth',1.5);
% ax = gca;
% ax.FontSize = 12;
% legend('social','nonsocial')
% title ([''])
% xlabel ('Age', 'FontSize', 16);
% ylabel  ('Beta Proportion', 'FontSize', 16);
% 
% i(1) = lsline;
% i(1).LineWidth = 5;
% i(1).Color = [0 0 0];
% set(gcf,'color','w');
% 
% i(2) = lsline;
% i(2).LineWidth = 5;
% i(2).Color = [0 0 0];
% set(gcf,'color','w');

%% 

% figure
% 
% scatter(behavioral_data(:,2), nonsocial_fit(:,2), 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
% 
% hold on
% 
% 
% scatter(behavioral_data(:,2), social_fit(:,2), 'MarkerEdgeColor',[0 1 1],'MarkerFaceColor',[0 1 .1],'LineWidth',1.5);
% ax = gca;
% ax.FontSize = 12;
% legend('social','nonsocial')
% title ([''])
% xlabel ('Age', 'FontSize', 16);
% ylabel  ('Polyfit Proportion', 'FontSize', 16);
% 
% i(1) = lsline;
% i(1).LineWidth = 5;
% i(1).Color = [0 0 0];
% set(gcf,'color','w');
% 
% i(2) = lsline;
% i(2).LineWidth = 5;
% i(2).Color = [0 0 0];
% set(gcf,'color','w');
% 
% 
% 
% set(gcf,'color','w');

%% UG_R earnings

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
    UG_R_reject_rate_part = sum(U.Choice)/96; % reject rate
    
    catch
        UG_R_reject_rate_part = 1; % reject rate
        missing_subject = [missing_subject, subjects(jj)];
    end
    
    UG_R_reject_rate = [UG_R_reject_rate;UG_R_reject_rate_part];
end


figure
scatter(behavioral_data(:,2),UG_R_reject_rate)

ax = gca;
ax.FontSize = 12;
title ([''])
xlabel ('Age', 'FontSize', 16);
ylabel  ('Rejection Rate', 'FontSize', 16);

i(1) = lsline;
i(1).LineWidth = 5;
i(1).Color = [0 0 0];
set(gcf,'color','w');


saveas(gcf,'age_rejection.svg')


%%
%     
%     UG_R_Earnings = [UG_R_Earnings; sum(U.Earned)]; % Sum acceptances.
%     UG_R_accept = [UG_R_accept; mean(U.Offer./U.Endowment)]; % Average accepted
%     
%     catch 
%         missing_subject = [missing_subject, subjects(jj)];
%     end
%         
%     try
%     name = ['Subject_' num2str(subjects(jj)) '_reject_analysis.csv'];
%     input = [input_folder,name];
%     V = readtable(input);
%     
%     UG_R_reject = [UG_R_reject; mean(V.Offer./V.Endowment)]; % Average rejected
%     UG_R_reject_rate_part = sum(U.Choice)/120; % reject rate
%     
%     catch
%         UG_R_reject_rate_part = 1; % reject rate
%         missing_subject = [missing_subject, subjects(jj)];
%     end
%     
%     UG_R_reject_rate = [UG_R_reject_rate;UG_R_reject_rate_part];
% end




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

saveas(gcf,'Bar_Props.svg')



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

%% Age

figure

h = histogram(behavioral_data(:,2));
counts = h.Values;
h.NumBins = 8;
ax = gca;
ax.FontSize = 9;
xlabel ('Rate of Rejections as a Recipient','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off');
set(gcf,'color','w');

saveas(gcf,'age_hist.svg')

%% Make barplot of proportions offered

% We need to bin the offers for each participant. (.05, .10, .25, .50)

sub_nonsocial_accepts = [];
sub_social_accepts = [];
savesocialbins = [];
savenonsocialbins = [];

for jj = 1:length(subjects)

    try
        save_value = [];
        UG_R_reject_rate_part = [];
        name = ['Subject_' num2str(subjects(jj)) '_accept_analysis.csv'];
        input = [input_folder,name];
        U = readtable(input);
        
        savesocialbin1 = [];
        savesocialbin2 = [];
        savesocialbin3 = [];
        savesocialbin4 = [];

        savenonsocialbin1 = [];
        savenonsocialbin2 = [];
        savenonsocialbin3 = [];
        savenonsocialbin4 = [];


        for kk = 1:size(U,1)
            row = U.Prop_Endowment(kk);
            Block = U.Block(kk);
            if row < .08
                if Block == 3
                    bin1 = row;
                    savesocialbin1 = [savesocialbin1; bin1];
                end
                if Block == 2
                    bin1 = row;
                    savenonsocialbin1 = [savenonsocialbin1; bin1];
                end

            end


            if row > .08 && row < .20

                if Block == 3
                    bin2 = row;
                    savesocialbin2 = [savesocialbin2; bin2];
                end

                if Block == 2
                    bin2 = row;
                    savenonsocialbin2 = [savenonsocialbin2; bin2];
                end
            end

            if row > .19 && row < .30

                if Block == 3
                    bin3 = row;
                    savesocialbin3 = [savesocialbin3; bin3];
                end

                if Block == 2
                    bin3 = row;
                    savenonsocialbin3 = [savenonsocialbin3; bin3];
                end
            end



            if row > .30
                if Block == 3
                    bin4 = row;
                    savesocialbin4 = [savesocialbin4; bin4];
                end

                if Block == 2
                    bin4 = row;
                    savenonsocialbin4 = [savenonsocialbin4; bin4];
                end
            end
        
        savesocialbins = [size((savesocialbin1),1), size((savesocialbin2),1), size((savesocialbin3),1), size((savesocialbin4),1)];
        savenonsocialbins = [size((savenonsocialbin1),1), size((savenonsocialbin2),1), size((savenonsocialbin3),1), size((savenonsocialbin4),1)];

        end

        sub_social_accepts = [sub_social_accepts; savesocialbins];
        sub_nonsocial_accepts = [sub_nonsocial_accepts; savenonsocialbins];

    catch
        missing_subject = [missing_subject, subjects(jj)];
    end
end

%% Rejections

sub_nonsocial_rejects = [];
sub_social_rejects = [];
savesocialbins = [];
savenonsocialbins = [];

for jj = 1:length(subjects)

    try

        name = ['Subject_' num2str(subjects(jj)) '_reject_analysis.csv'];
        input = [input_folder,name];
        V = readtable(input);
        
        savesocialbin1 = [];
        savesocialbin2 = [];
        savesocialbin3 = [];
        savesocialbin4 = [];

        savenonsocialbin1 = [];
        savenonsocialbin2 = [];
        savenonsocialbin3 = [];
        savenonsocialbin4 = [];


        for kk = 1:size(V,1)
            row = V.Prop_Endowment(kk);
            Block = V.Block(kk);
            if row < .08
                if Block == 3
                    bin1 = row;
                    savesocialbin1 = [savesocialbin1; bin1];
                end
                if Block == 2
                    bin1 = row;
                    savenonsocialbin1 = [savenonsocialbin1; bin1];
                end

            end


            if row > .08 && row < .20

                if Block == 3
                    bin2 = row;
                    savesocialbin2 = [savesocialbin2; bin2];
                end

                if Block == 2
                    bin2 = row;
                    savenonsocialbin2 = [savenonsocialbin2; bin2];
                end
            end

            if row > .19 && row < .30

                if Block == 3
                    bin3 = row;
                    savesocialbin3 = [savesocialbin3; bin3];
                end

                if Block == 2
                    bin3 = row;
                    savenonsocialbin3 = [savenonsocialbin3; bin3];
                end
            end



            if row > .30
                if Block == 3
                    bin4 = row;
                    savesocialbin4 = [savesocialbin4; bin4];
                end

                if Block == 2
                    bin4 = row;
                    savenonsocialbin4 = [savenonsocialbin4; bin4];
                end
            end
        
        savesocialbins = [size((savesocialbin1),1), size((savesocialbin2),1), size((savesocialbin3),1), size((savesocialbin4),1)];
        savenonsocialbins = [size((savenonsocialbin1),1), size((savenonsocialbin2),1), size((savenonsocialbin3),1), size((savenonsocialbin4),1)];

        end

        sub_social_rejects = [sub_social_rejects; savesocialbins];
        sub_nonsocial_rejects = [sub_nonsocial_rejects; savenonsocialbins];

    catch
        missing_subject = [missing_subject, subjects(jj)];
    end
end

%% plot proportions

% Take proportion of rejections / acceptances

% Add reject and accept together.

total = sub_social_rejects + sub_social_accepts;
prop_socialreject = sub_social_rejects./total;

data = [mean(prop_socialreject(:,1)), mean(prop_socialreject (:,2)), mean(prop_socialreject (:,3)), mean(prop_socialreject (:,4))]; 
x = linspace(1,4,4);
fig = figure
x1 = bar(x(1),data(1));
x1.LineWidth= 2.5
hold on
x2 = bar(x(2),data(2));
x2.LineWidth= 2.5
hold on
x3 = bar(x(3),data(3));
x3.LineWidth= 2.5
hold on
x4 = bar(x(4),data(4));
x4.LineWidth= 2.5
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Proportions', 'FontSize', 16);
ylabel  ('Rejection Rate', 'FontSize', 16);
title ('Rejection Rate in UG-R')
set(gcf,'color','w');
set(gca, 'XTick', 1:4, 'XTickLabels', {'0.05', '0.10', '0.25', '.05'})

hold on

% Standard Error

B1Er = std(prop_socialreject(:,1)) / sqrt(length(prop_socialreject(:,1)));
B2Er = std(prop_socialreject(:,2)) / sqrt(length(prop_socialreject(:,2)));
B3Er = std(prop_socialreject(:,3)) / sqrt(length(prop_socialreject(:,3)));
B4Er = std(prop_socialreject(:,4)) / sqrt(length(prop_socialreject(:,4)));

err = [B1Er,B2Er, B3Er, B4Er] * 2;

er = errorbar(x,data,err); 
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 2.5;

hold on

%% Add nonsocial

figure
total = sub_nonsocial_rejects + sub_nonsocial_accepts;
prop_nonsocialreject = sub_nonsocial_rejects./total;



data = [mean(prop_nonsocialreject(:,1)), mean(prop_nonsocialreject (:,2)), mean(prop_nonsocialreject (:,3)), mean(prop_nonsocialreject (:,4))]; 


x = linspace(1,4,4);
x1 = bar(x(1),data(1));
x1.LineWidth= 2.5
hold on
x2 = bar(x(2),data(2));
x2.LineWidth= 2.5
hold on
x3 = bar(x(3),data(3));
x3.LineWidth= 2.5
hold on
x4 = bar(x(4),data(4));
x4.LineWidth= 2.5
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Proportions', 'FontSize', 16);
ylabel  ('Rejection Rate', 'FontSize', 16);
title ('Rejection Rate in UG-R')
set(gcf,'color','w');
set(gca, 'XTick', 1:4, 'XTickLabels', {'0.05', '0.10', '0.25', '.05'})
hold on

% Standard Error

B1Er = std(prop_nonsocialreject(:,1)) / sqrt(length(prop_nonsocialreject(:,1)));
B2Er = std(prop_nonsocialreject(:,2)) / sqrt(length(prop_nonsocialreject(:,2)));
B3Er = std(prop_nonsocialreject(:,3)) / sqrt(length(prop_nonsocialreject(:,3)));
B4Er = std(prop_nonsocialreject(:,4)) / sqrt(length(prop_nonsocialreject(:,4)));

err = [B1Er,B2Er, B3Er, B4Er] * 2;

er = errorbar(x,data,err); 
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 2.5;
hold off

saveas(gcf,'Prop_Non_social_Rejections.svg')
     
%% plot proportions together

% Take proportion of rejections / acceptances

% Add reject and accept together.

total = sub_social_rejects + sub_social_accepts;
prop_socialreject = sub_social_rejects./total;

total_nonsocial = sub_nonsocial_rejects + sub_nonsocial_accepts;
prop_nonsocialreject = sub_nonsocial_rejects./total_nonsocial;

data_nonsocial = [mean(prop_nonsocialreject(:,1)), mean(prop_nonsocialreject (:,2)), mean(prop_nonsocialreject (:,3)), mean(prop_nonsocialreject (:,4))]; 
data_social = [mean(prop_socialreject(:,1)), mean(prop_socialreject (:,2)), mean(prop_socialreject (:,3)), mean(prop_socialreject (:,4))]; 

figure

bin1= [prop_nonsocialreject(:,1), prop_socialreject(:,1)];
bin2= [prop_nonsocialreject(:,2), prop_socialreject(:,2)];
bin3= [prop_nonsocialreject(:,3), prop_socialreject(:,3)];
bin4= [prop_nonsocialreject(:,4), prop_socialreject(:,4)];

barweb_dvs2([mean(bin1);mean(bin2);mean(bin3);mean(bin4)], [std(bin1)/sqrt(length(bin1)); std(bin2)/sqrt(length(bin2)); std(bin3)/sqrt(length(bin3)); std(bin4)/sqrt(length(bin4))]);
xlabel('Proportion offered');
xticks([1, 2, 3, 4]);
xticklabels({'0.05','0.10', '0.25', '0.50'});
ylabel('Rejection Rate');
legend('Nonsocial','Social');

saveas(gcf,'Prop_social_nonsocial.svg')

%% ANOVA

[p, tb1, STATS] = anova2([prop_socialreject; prop_nonsocialreject],2);

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
        subject_combined_rejections = [subject_combined_rejections;  T.Prop_Endowment, T.Block];
    catch
        missing_reject = [missing_reject, values(ii)];
    end
    try
        name = ['Subject_' num2str(values(ii)) '_accept_analysis.csv'];
        input = [input_folder,name];
        S = readtable(input);
        subject_combined_acceptances = [subject_combined_acceptances; S.Prop_Endowment, S.Block];
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
    
    try
        %Y = categorical(subject_UGR.Choice);
        Y = subject_UGR.Choice;
        
    end
    
    sub_age = behavioral_data(ii,2);
    [N,~] = size(subject_UGR.Prop_Endowment);
    age_mat = zeros(N,1)+sub_age;

    int1 = (subject_UGR.Prop_Endowment-mean(subject_UGR.Prop_Endowment)) .* (subject_UGR.Block-mean(subject_UGR.Block));
    int2 = (age_mat-mean(age_mat)) .* (subject_UGR.Block-mean(subject_UGR.Block));
    int3 = (age_mat-mean(age_mat)) .* (subject_UGR.Prop_Endowment-mean(subject_UGR.Prop_Endowment));
    int4 = (age_mat-mean(age_mat)) .* (subject_UGR.Block-mean(subject_UGR.Block) .* subject_UGR.Prop_Endowment-mean(subject_UGR.Prop_Endowment));
    
    X = [age_mat, subject_UGR.Prop_Endowment, subject_UGR.Block, int1, int2, int3, int4];
    %X = zscore(X);
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

data = [mean(B(1,:));  mean(B(2,:));  mean(B(3,:)); mean(B(4,:)); mean(B(5,:)); mean(B(6,:)); mean(B(7,:)); mean(B(8,:))];
x = linspace(1,8,8);
figure
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Regressors', 'FontSize', 16);
ylabel  ('Z-standardized Beta Weight', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:8, 'XTickLabels', {'Intercept', 'Age', 'Fairness', 'Social Context', 'Fairness*Context', 'Age*Context', 'Age*Fairness', 'Three-Way'});
title('Does Fairness, Age, and Social Context Predict UG-R Choices?')

hold on

% Standard Error

B1Er = se(1);
B2Er = se(2);
B3Er = se(3);
B4Er = se(4);
B5Er = se(5);
B6Er = se(6);
B7Er = se(7);
B8Er = se(8);

err = [B1Er,B2Er,B3Er,B4Er,B5Er,B6Er,B7Er, B8Er] * 2;

er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 1;
hold off

saveas(gcf,'Bar_UGR.svg')

% %% UGR High/low analysis.
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
% subs = subjects % Subject 1294 ACCEPTS almost all offers.  Subject 3125 REJECTS almost all offers. 
% for ii = 1:length(subs)
%     S = [];
%     T = [];
%     try
%         name = ['Subject_' num2str(subs(ii)) '_reject_analysis.csv']
%         input = [input_folder,name];
%         T = readtable(input);
%         subject_combined_rejections = [subject_combined_rejections;  ([T.Endowment, T.Prop_Endowment])];
%     catch
%         missing_reject = [missing_reject, subs(ii)];
%     end
%     try
%         name = ['Subject_' num2str(subs(ii)) '_accept_analysis.csv'];
%         input = [input_folder,name];
%         S = readtable(input);
%         subject_combined_acceptances = [subject_combined_acceptances; S.Endowment, S.Prop_Endowment];
%     catch
%         missing_accept = [missing_accept, subs(ii)];
%     end
%     try
%         subject_UGR = [S;T];
%         sub_p = [subs(ii), mean(T.Prop_Endowment)];
%         sub_prop = [sub_prop; sub_p]; % sub 3125 rejects high P of offers. sub 1294 rejections low P offers
%         
%         
%     catch
%         missing_subject = [missing_subject, subs(ii)];
%     end
%     try
%         Y = categorical(subject_UGR.Choice);
%     end
%     
%      
%     X = [subject_UGR.Endowment, subject_UGR.Prop_Endowment];
%     X = zscore(X);
%     save_X = [save_X; X];
%     save_Y = [save_Y; Y];
%     try
%     %[B,dev,stats] = mnrfit(X, Y); % Given the Endowment, proportion of endowment, can we predict accept/reject?
% %     b = glmfit(X,Y,'binomial','link','logit');
% %     Betas = [Betas, b];
% %     Pvals = [Pvals, stats.p];
%     catch
%         badsubject = [badsubject,values(ii)];
%     
% end
%     
%    save = [];
%    dump = [];
%    save_Y=categorical(save_Y);
%    %[B,DEV,STATS] = glmfit(X,Y,'binomial','link','logit');
%    se=STATS.se;
%    
%    data = [mean(B(1,:));  mean(B(2,:));  mean(B(3,:))];
%    x = linspace(1,3,3);
%    figure
%    bar(x,data)
%    ax = gca;
%    ax.FontSize = 12;
%    box off
%    xlabel ('Regressors', 'FontSize', 16);
%    ylabel  ('Z-standardized Beta Weight', 'FontSize', 16);
%    set(gcf,'color','w');
%    set(gca, 'XTick', 1:3, 'XTickLabels', {'Intercept', 'Endowment', 'Proportion'})
%    title('Does Endowment Predict UG-R Accept/Reject Choices?')
%    
%    hold on
%    
%    % Standard Error
%    
%    B1Er = se(1)
%    B2Er = se(2)
%    B3Er = se(3)
%    
%    err = [B1Er,B2Er,B3Er] * 2;
%    
%    er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
%    er.Color = [0 0 0];
%    er.LineStyle = 'none';
%    er.LineWidth = 1;
%    hold off
%    
%    saveas(gcf,'Bar_UGR.png')
%     
%     [R,P] = corrcoef(subject_UGR.Endowment, subject_UGR.Choice);
%     figure
%     scatter(subject_UGR.Endowment, subject_UGR.Choice,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
%     ax = gca;
%     ax.FontSize = 12;
%     title (['Subject ' num2str(subs(ii))])
%     xlabel ('Endowment', 'FontSize', 16);
%     ylabel  ('Choice', 'FontSize', 16);
%     i = lsline;
%     i.LineWidth = 5;
%     i.Color = [0 0 0];
%     set(gcf,'color','w');
%     
%     [R,P] = corrcoef(subject_UGR.Prop_Endowment, subject_UGR.Choice);
%     figure
%     scatter(subject_UGR.Prop_Endowment, subject_UGR.Choice,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
%     ax = gca;
%     ax.FontSize = 12;
%     title (['Subject ' num2str(subs(ii))])
%     xlabel ('Proportion', 'FontSize', 16);
%     ylabel  ('Choice', 'FontSize', 16);
%     i = lsline;
%     i.LineWidth = 5;
%     i.Color = [0 0 0];
%     set(gcf,'color','w');
%     
%     
% end
    
