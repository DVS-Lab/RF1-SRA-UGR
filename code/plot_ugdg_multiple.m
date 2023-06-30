function plot_ugdg_multiple(name, roidir, rois, models, Cope_DGP, Cope_UGP, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
    
% This function plots results in the ISTART ugdg task. It employs DVS
% plotting tool barweb_dvs2.m. This code generates the inputs to make the
% plots and scatter plots for this project.

% Daniel Sahin
% 03/31/2022
% Temple University
% DVS Lab

close all
clc

% import mlreportgen.ppt.* 
% 
% ppt = Presentation(name '.pptx');
% titleSlide = add(ppt, 'Title Slide');
% replace(titleslide, 'Title', name);
% pictureslide = add(ppt, 'Title and Picture');

    output = [roidir '/results/' name];
    
    if exist(output) == 7
        rmdir(output, 's');
        mkdir(output);
    else 
        mkdir(output); % set name
    end
    
    % Make a file for test results

    outputdir = [roidir '/results/' name '/'];
    file = ([roidir '/results/' name '/' name]);
    [L] = isfile(file);
    if L == 1
        delete(file)
    end
    
    diary(file)
    
    % loop through rois
  
    diary on
    
    Cope_DGP_use = [];
    Cope_UGP_use = [];

    for r = 1:length(rois)
        roi = rois{r};


        DGP= load(strjoin([roidir,roi,models,Cope_DGP], ''));
        UGP= load(strjoin([roidir,roi,models,Cope_UGP], ''));

        Cope_DGP_use = [Cope_DGP_use, DGP];
        Cope_UGP_use = [Cope_UGP_use, UGP];

    end

    ROI1 = [Cope_DGP_use(:,1), Cope_UGP_use(:,1)];
    ROI2 = [Cope_DGP_use(:,2), Cope_UGP_use(:,2)];
    %ROI3 = [Cope_DGP_use(:,3), Cope_UGP_use(:,3)];
    %ROI4 = [Cope_DGP_use(:,4), Cope_UGP_use(:,4)];
   

        for m = 1:length(models)
            model = models{m};
            roi = rois{1};
        
            %figure, barweb_dvs2([mean(ROI1); mean(ROI2); mean(ROI3); mean(ROI4)], [std(ROI1)/sqrt(length(ROI1)); std(ROI2)/sqrt(length(ROI2));std(ROI3)/sqrt(length(ROI3));std(ROI4)/sqrt(length(ROI4))]);
            figure, barweb_dvs2([mean(ROI1); mean(ROI2)], [std(ROI1)/sqrt(length(ROI1)); std(ROI2)/sqrt(length(ROI2))]);
            
            xlabel('Task Condition');
            xticks([0.8, 1.2, 2,2.2]);
            xticklabels({'DGP','UGP', 'DGP', 'UGP'});
            ylabel('BOLD Response');
            %legend({'DGP', 'UGP'},'Location','northeast');
            axis square;
            title([roi type]);
            outname = fullfile([outputdir roi model]);
            cmd = ['print -depsc ' outname];
            eval(cmd);
            saveas(gca, fullfile(outname), 'svg');
            
            
           
%          
%             figure
%             
%             subplot(2,3,1)
%             [R,P] = corrcoef(ID_Measure_1, DGP);
%             scatter(ID_Measure_1, DGP, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
%             ylabel (['DGP ' roi type], 'FontSize', 12);
%             xlabel  (ID_Measure_1_name, 'FontSize', 12);
%             i = lsline;
%             i.LineWidth = 3.5;
%             i.Color = [0 0 0];
%             str=sprintf([' R=%1.2f' ' P=%1.2f'], [R(1,2) P(1,2)]);
%             T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str);
%             T.FontSize = 8;
%             
%             subplot(2,3,2)
%             [R,P] = corrcoef(ID_Measure_1, UGP);
%             scatter(ID_Measure_1, UGP, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
%             ylabel (['UGP ' roi type], 'FontSize', 12);
%             xlabel  (ID_Measure_1_name, 'FontSize', 12);
%             i = lsline;
%             i.LineWidth = 3.5;
%             i.Color = [0 0 0];
%             str=sprintf([' R=%1.2f' ' P=%1.2f'], [R(1,2) P(1,2)]);
%             T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str);
%             T.FontSize = 8;
%             
%             subplot(2,3,3)
%             [R,P] = corrcoef(ID_Measure_1, UGR);
%             scatter(ID_Measure_1, UGR, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
%             ylabel (['UGR ' roi type], 'FontSize', 12);
%             xlabel  (ID_Measure_1_name, 'FontSize', 12);
%             i = lsline;
%             i.LineWidth = 3.5;
%             i.Color = [0 0 0];
%             str=sprintf([' R=%1.2f' ' P=%1.2f'], [R(1,2) P(1,2)]);
%             T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str);
%             T.FontSize = 8;
%             
%             subplot(2,3,4)
%             [R,P] = corrcoef(ID_Measure_2, DGP);
%             scatter(ID_Measure_2, DGP, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
%             ax = gca;
%             ax.FontSize = 12;
%             ylabel (['DGP ' roi type], 'FontSize', 12);
%             xlabel  (ID_Measure_2_name, 'FontSize', 12);
%             i = lsline;
%             i.LineWidth = 3.5;
%             i.Color = [0 0 0];
%             set(gcf,'color','w');
%             str=sprintf([' R=%1.2f' ' P=%1.2f'], [R(1,2) P(1,2)]);
%             T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str);
%             T.FontSize = 8;
%             
%             subplot(2,3,5)
%             [R,P] = corrcoef(ID_Measure_2, UGP);
%             scatter(ID_Measure_2, UGP, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
%             ylabel (['UGP ' roi type], 'FontSize', 12);
%             xlabel  (ID_Measure_2_name, 'FontSize', 12);
%             i = lsline;
%             i.LineWidth = 3.5;
%             i.Color = [0 0 0];
%             str=sprintf([' R=%1.2f' ' P=%1.2f'], [R(1,2) P(1,2)]);
%             T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str);
%             T.FontSize = 8;
%             
%             subplot(2,3,6)
%             [R,P] = corrcoef(ID_Measure_2, UGR);
%             scatter(ID_Measure_2, UGR, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
%             ylabel (['UGR ' roi type], 'FontSize', 12);
%             xlabel  (ID_Measure_2_name, 'FontSize', 12);
%             i = lsline;
%             i.LineWidth = 3.5;
%             i.Color = [0 0 0];
%             str=sprintf([' R=%1.2f' ' P=%1.2f'], [R(1,2) P(1,2)]);
%             T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str);
%             T.FontSize = 8;
        end   

    
    
diary off
end

