clear all
close all
clc

% This file plots histograms of our EVfiles

% Daniel Sazhin
% DVS lab
% 03/29/2022

subjects = [1003, 1006, 1007, 1009, 1010, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1242, 1244, 1245, 1247, 1248, 1249, 1251, 1253, 1255, 1276, 1282, 1286, 1294, 1300, 1301, 1302, 1303, 3101, 3116, 3122, 3125, 3140, 3143, 3152, 3164, 3166, 3167, 3170, 3173, 3175, 3176, 3189, 3190, 3199, 3200, 3206, 3210, 3212, 3220];
%subjects=3200;
EVdir='/data/projects/istart-ugdg/derivatives/fsl/EVfiles/';

output = '/ugdg_GLM2_d/';

%% Open files

cue_ug_prop_pmod_pmod=[];
cue_ugp= [];
eye_corr_values = [];
eye_corr_values_eig = [];

for ii = 1:length(subjects)
    
    combined_eye = [];
    sub = ['sub-' num2str(subjects(ii))];
    
    run1 = dlmread([EVdir sub output 'run-01_cue_ug-prop_pmod_pmod.txt']);
    run2 = dlmread([EVdir sub output 'run-02_cue_ug-prop_pmod_pmod.txt']);
    
    run1_leye=dlmread([EVdir sub output 'run-01_LeftEye.txt']);
    run1_reye=dlmread([EVdir sub output 'run-01_RightEye.txt']);
    
    run2_leye=dlmread([EVdir sub output 'run-02_LeftEye.txt']);
    run2_reye=dlmread([EVdir sub output 'run-02_RightEye.txt']);
    
    run1_leye_eig=dlmread([EVdir sub output 'run-01_LeftEye_eig.txt']);
    run1_reye_eig=dlmread([EVdir sub output 'run-01_RightEye_eig.txt']);
    
    run2_leye_eig=dlmread([EVdir sub output 'run-02_LeftEye_eig.txt']);
    run2_reye_eig=dlmread([EVdir sub output 'run-02_RightEye_eig.txt']);

    combined = [run1; run2];
    combined_eye = [([run1_leye+run2_leye]), ([run1_reye+run2_reye])];
   
    [R,P] = corrcoef(combined_eye(:,1), combined_eye(:,2));
    
    eye_corr_values =  [eye_corr_values; R(1,2)];  
   
    combined_eye_eig = [([run1_leye_eig+run2_leye_eig]), ([run1_reye_eig+run2_reye_eig])];
   
    [R,P] = corrcoef(combined_eye_eig(:,1), combined_eye_eig(:,2));
    
    eye_corr_values_eig =  [eye_corr_values_eig; R(1,2)];  
    
    
    cue_ug_prop_pmod_pmod=[cue_ug_prop_pmod_pmod; combined];
    
    minmax = [min(combined(:,3)), max(combined(:,3))]; 
    update = [subjects(ii), minmax];
    cue_ugp= [cue_ugp; update];
    
end

cue_dg_prop_pmod_pmod=[];
cue_dgp= [];

for ii = 1:length(subjects)
    sub = ['sub-' num2str(subjects(ii))];
    
    run1 = dlmread([EVdir sub output 'run-01_cue_dict_pmod_pmod.txt']);
    run2 = dlmread([EVdir sub output 'run-02_cue_dict_pmod_pmod.txt']);
    
    combined = [run1; run2];
    
    cue_dg_prop_pmod_pmod=[cue_dg_prop_pmod_pmod; combined];
    
    minmax = [min(combined(:,3)), max(combined(:,3))]; 
    update = [subjects(ii), minmax];
    cue_dgp= [cue_dgp; update];
end

cue_ug_resp_pmod_pmod=[];
cue_ugr=[];

for ii = 1:length(subjects)
    sub = ['sub-' num2str(subjects(ii))];
    
    run1 = dlmread([EVdir sub output 'run-01_cue_ug-resp_pmod_pmod.txt']);
    run2 = dlmread([EVdir sub output 'run-02_cue_ug-resp_pmod_pmod.txt']);
    
    combined = [run1; run2];
    
    cue_ug_resp_pmod_pmod=[cue_ug_resp_pmod_pmod; combined];
    
    minmax = [min(combined(:,3)), max(combined(:,3))]; 
    update = [subjects(ii), minmax];
    cue_ugr= [cue_ugr; update];
    
end

dec_dg_prop_pmod_choice_pmod=[];
dec_dgp=[];

for ii = 1:length(subjects)
    sub = ['sub-' num2str(subjects(ii))];
    
    run1 = dlmread([EVdir sub output 'run-01_dec_dg-prop_pmod_choice_pmod.txt']);
    run2 = dlmread([EVdir sub output 'run-02_dec_dg-prop_pmod_choice_pmod.txt']);
    
    combined = [run1; run2];
    
    dec_dg_prop_pmod_choice_pmod=[dec_dg_prop_pmod_choice_pmod; combined];
    
    minmax = [min(combined(:,3)), max(combined(:,3))]; 
    update = [subjects(ii), minmax];
    dec_dgp= [dec_dgp; update];
    
end

dec_ug_prop_pmod_choice_pmod=[];
dec_ugp=[];

for ii = 1:length(subjects)
    sub = ['sub-' num2str(subjects(ii))];
    
    run1 = dlmread([EVdir sub output 'run-01_dec_ug-prop_pmod_choice_pmod.txt']);
    run2 = dlmread([EVdir sub output 'run-02_dec_ug-prop_pmod_choice_pmod.txt']);
    
    combined = [run1; run2];
    
    dec_ug_prop_pmod_choice_pmod=[dec_ug_prop_pmod_choice_pmod; combined];
    
    minmax = [min(combined(:,3)), max(combined(:,3))]; 
    update = [subjects(ii), minmax];
    dec_ugp= [dec_ugp; update];
    
end

dec_ug_resp_pmod_choice_pmod=[];
dec_ugr=[];

for ii = 1:length(subjects)
    sub = ['sub-' num2str(subjects(ii))];
    
    run1 = dlmread([EVdir sub output 'run-01_dec_ug-resp_pmod_choice_pmod.txt']);
    run2 = dlmread([EVdir sub output 'run-02_dec_ug-resp_pmod_choice_pmod.txt']);
    
    combined = [run1; run2];
    
    dec_ug_resp_pmod_choice_pmod=[dec_ug_resp_pmod_choice_pmod; combined];
    
    minmax = [min(combined(:,3)), max(combined(:,3))]; 
    update = [subjects(ii), minmax];
    dec_ugr= [dec_ugr; update];
    
end

%% Plot distributions of EVs

figure
h = histogram(dec_dg_prop_pmod_choice_pmod(:,3));
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
xlabel ('DGP Modulated Choices','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off')
set(gcf,'color','w');

figure
h = histogram(dec_ug_prop_pmod_choice_pmod(:,3));
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
xlabel ('UGP Modulated Choices','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off')
set(gcf,'color','w');

figure
h = histogram(dec_ug_resp_pmod_choice_pmod(:,3));
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
xlabel ('UGR Modulated Choices','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off')
set(gcf,'color','w');

figure
h = histogram(cue_dg_prop_pmod_pmod(:,3));
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
xlabel ('DGP Modulated Cue','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off')
set(gcf,'color','w');

figure
h = histogram(cue_ug_prop_pmod_pmod(:,3));
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
xlabel ('UGP Modulated Cue','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off')
set(gcf,'color','w');

figure
h = histogram(cue_ug_resp_pmod_pmod(:,3));
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
xlabel ('UGR Modulated Cue','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off')
set(gcf,'color','w');

%% Plot min max values

figure

h = histogram(dec_dgp(:,3));
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;

hold on

h = histogram(dec_dgp(:,2));
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
xlabel ('DGP Min/Max Modulated Choices','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off')
set(gcf,'color','w');

hold on

h = histogram(dec_dgp(47,2),'FaceColor', 'r');
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;

hold on

h = histogram(dec_dgp(47,3),'FaceColor', 'r');
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;

figure

h = histogram(dec_ugp(:,3));
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;

hold on

h = histogram(dec_ugp(:,2));
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
xlabel ('UGP Min/Max Modulated Choices','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off')
set(gcf,'color','w');

hold on

h = histogram(dec_ugp(47,2),'FaceColor', 'r');
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;

hold on

h = histogram(dec_ugp(47,3),'FaceColor', 'r');
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;

figure 

h = histogram(dec_ugr(:,3));
counts = h.Values;
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;

hold on

h = histogram(dec_ugr(:,2));
h.NumBins = 12;
xlabel ('UGR Min/Max Modulated Choices','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off')
set(gcf,'color','w');

hold on

h = histogram(dec_ugr(47,2),'FaceColor', 'r');
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;

hold on

h = histogram(dec_ugr(47,3),'FaceColor', 'r');
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
%% 
figure

h = histogram(cue_dgp(:,3));
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;

hold on

h = histogram(cue_dgp(:,2));
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
xlabel ('DGP Min/Max Modulated Cues','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off')
set(gcf,'color','w');

hold on

h = histogram(cue_dgp(47,2),'FaceColor', 'r');
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;

hold on

h = histogram(cue_dgp(47,3),'FaceColor', 'r');
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;

figure

h = histogram(cue_ugp(:,3));
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;

hold 

h = histogram(cue_ugp(:,2));
h.NumBins = 2;
ax = gca;
ax.FontSize = 12;
xlabel ('UGP Min/Max Modulated Cues','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off')
set(gcf,'color','w');

hold on

h = histogram(cue_ugp(47,2),'FaceColor', 'r');
h.NumBins = 2;
ax = gca;
ax.FontSize = 12;

hold on

h = histogram(cue_ugp(47,3),'FaceColor', 'r');
h.NumBins = 2;
ax = gca;
ax.FontSize = 12;

figure

h = histogram(cue_ugr(:,3));
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;

hold on

h = histogram(cue_ugr(:,2));
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
xlabel ('UGR Min/Max Modulated Cues','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off')
set(gcf,'color','w');

hold on

h = histogram(cue_ugr(47,2),'FaceColor', 'r');
h.NumBins = 2;
ax = gca;
ax.FontSize = 12;

hold on

h = histogram(cue_ugr(47,3),'FaceColor', 'r');
h.NumBins = 2;
ax = gca;
ax.FontSize = 12;

%% Plot correlations between eyes.


[R,P] = corrcoef(combined_eye(:,1), combined_eye(:,2));
figure
scatter(combined_eye(:,1), combined_eye(:,2), 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
ax = gca;
ax.FontSize = 12;
xlabel ('L eye', 'FontSize', 16);
ylabel  ('R eye', 'FontSize', 16);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

%% hist of eye corr values.

figure

h = histogram(eye_corr_values);
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
title('Uncorrected')
xlabel ('R Values', 'FontSize', 16);
ylabel  ('Frequency', 'FontSize', 16)

%% hist of eye corr values eig.

figure

h = histogram(eye_corr_values_eig);
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
title('Eigen Corrected')
xlabel ('R Values', 'FontSize', 16);
ylabel  ('Frequency', 'FontSize', 16)

%% diff hist of eye corr values eig.

figure

diff=eye_corr_values_eig-eye_corr_values;
h = histogram(diff);
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
title('Delta R')
xlabel ('R Values', 'FontSize', 16);
ylabel  ('Frequency', 'FontSize', 16)

%% Bar plot


data = [mean(eye_corr_values_eig), mean(eye_corr_values)]; %, B(4), B(5)];
x = linspace(1,2,2);
figure
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Regressors', 'FontSize', 16);
ylabel  ('R Values', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:2, 'XTickLabels', {'Eigen Variate', 'Uncorrected'})
title('What is the relation between eye covariates?')

hold on

% Standard Error

B1Er = std(eye_corr_values_eig(:,1)) / sqrt(length((eye_corr_values_eig(:,1))));
B2Er = std(eye_corr_values(:,1)) / sqrt(length((eye_corr_values(:,1))));
%B3Er = se(3);
%B4Er = se(4);
%B5Er = se(5);

err = [B1Er,B2Er] * 2;

er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 1;
hold off

saveas(gcf,'Bar_eye.png')
