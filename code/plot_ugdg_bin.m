function plot_ugdg_bin(name, roidir, rois, models, cope_DGP_bin1, cope_DGP_bin2, cope_DGP_bin3, cope_UGP_bin1, cope_UGP_bin2, cope_UGP_bin3, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
    
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
    
    for r = 1:length(rois)
        roi = rois{r} ;
        for m = 1:length(models)
            model = models{m};
           
            DGP_b1= load(strjoin([roidir,roi,model,cope_DGP_bin1,], ''));
            DGP_b2= load(strjoin([roidir,roi,model,cope_DGP_bin2,], ''));
            DGP_b3= load(strjoin([roidir,roi,model,cope_DGP_bin3,], ''));
            UGP_b1= load(strjoin([roidir,roi,model,cope_UGP_bin1,], ''));
            UGP_b2= load(strjoin([roidir,roi,model,cope_UGP_bin2,], ''));
            UGP_b3= load(strjoin([roidir,roi,model,cope_UGP_bin3,], ''));

            bin1= [DGP_b1(:,1), UGP_b1(:,1)];
            bin2= [DGP_b2(:,1), UGP_b2(:,1)];
            bin3= [DGP_b3(:,1), UGP_b3(:,1)];
            

            figure, barweb_dvs2([mean(bin1); mean(bin2); mean(bin3)], [std(bin1)/sqrt(length(bin1)); std(bin2)/sqrt(length(bin2)); std(bin3)/sqrt(length(bin3))]);
            xlabel('Task Condition');
            xticks([0.75, 1.25, 1.75,2.25, 2.75, 3.25]);
            xticklabels({'DG-b1','UG-b1', 'DG-b2','UG-b2','DG-b3','UG-b3'});
            ylabel('BOLD Response');
            %legend({'DGP', 'UGP', 'UGR'},'Location','northeast');
            axis square;
            title([roi type]);
            outname = fullfile([outputdir roi model 'binned']);
            cmd = ['print -depsc ' outname];
            eval(cmd);

            saveas(gca, fullfile(outname), 'svg');

            DGP = [];
            UGP = [];

            for ii = 1:length(bin1)
                val1 = mean([bin1(ii,1),bin2(ii,1), bin3(ii,1)]);
                val2 = mean([bin1(ii,2),bin2(ii,2), bin3(ii,2)]);
                DGP=[DGP,val1];
                UGP=[UGP,val2];
            end

            figure, barweb_dvs2([mean(DGP); mean(UGP)], [std(DGP)/sqrt(length(DGP)); std(UGP)/sqrt(length(UGP))]);
            xlabel('Task Condition');
            xticks([0.75, 1.25, 1.75,2.25, 2.75, 3.25]);
            xticklabels({'DG-b1','UG-b1', 'DG-b2','UG-b2','DG-b3','UG-b3'});
            ylabel('BOLD Response');
            %legend({'DGP', 'UGP', 'UGR'},'Location','northeast');
            axis square;
            title([roi type]);
            outname = fullfile([outputdir roi model]);
            cmd = ['print -depsc ' outname];
            eval(cmd);


            saveas(gca,fullfile(outname), 'svg');
         
            % make figure for high/low strat

            % Tag bins with the ID measure

            bin1_ID=[bin1, ID_Measure_1]
            bin2_ID=[bin2, ID_Measure_1];
            bin3_ID=[bin3, ID_Measure_1];

            [~,idx]=sort(bin1_ID(:,3)); % sort third column
            sortedbin1_ID = bin1_ID(idx,:)

            low_bin1=sortedbin1_ID(1:27,1:2);
            high_bin1=sortedbin1_ID(28:54,1:2);

             [~,idx]=sort(bin2_ID(:,3)); % sort third column
            sortedbin2_ID = bin2_ID(idx,:)

            low_bin2=sortedbin2_ID(1:27,1:2);
            high_bin2=sortedbin2_ID(28:54,1:2);

            [~,idx]=sort(bin3_ID(:,3)); % sort third column
            sortedbin3_ID = bin3_ID(idx,:);

            low_bin3=sortedbin3_ID(1:27,1:2);
            high_bin3=sortedbin3_ID(28:54,1:2);

            figure, barweb_dvs2([mean(low_bin1); mean(low_bin2); mean(low_bin3)], [std(low_bin1)/sqrt(length(low_bin1)); std(low_bin2)/sqrt(length(low_bin2)); std(low_bin3)/sqrt(length(low_bin3))]);
            xlabel('Task Condition');
            xticks([0.75, 1.25, 1.75,2.25, 2.75, 3.25]);
            xticklabels({'DG-b1','UG-b1', 'DG-b2','UG-b2','DG-b3','UG-b3'});
            ylabel('BOLD Response');
            %legend({'DGP', 'UGP', 'UGR'},'Location','northeast');
            axis square;
            title(['Low Strat']);
            outname = fullfile([outputdir roi model]);
            cmd = ['print -depsc ' outname];
            eval(cmd);
            saveas(gca, fullfile(outname), 'svg');

            figure, barweb_dvs2([mean(high_bin1); mean(high_bin2); mean(high_bin3)], [std(high_bin1)/sqrt(length(high_bin1)); std(high_bin2)/sqrt(length(high_bin2)); std(high_bin3)/sqrt(length(high_bin3))]);
            xlabel('Task Condition');
            xticks([0.75, 1.25, 1.75,2.25, 2.75, 3.25]);
            xticklabels({'DG-b1','UG-b1', 'DG-b2','UG-b2','DG-b3','UG-b3'});
            ylabel('BOLD Response');
            %legend({'DGP', 'UGP', 'UGR'},'Location','northeast');
            axis square;
            title(['High strat']);
            outname = fullfile([outputdir roi model]);
            cmd = ['print -depsc ' outname];
            eval(cmd);
            saveas(gca, fullfile(outname), 'svg');

            figure, barweb_dvs2([mean(low_bin1(:,2)-low_bin1(:,1)); mean(low_bin2(:,2)-low_bin2(:,1)); mean(low_bin3(:,2)-low_bin3(:,1))], [std(low_bin1(:,2)-low_bin1(:,1))/sqrt(length(low_bin1(:,2)-low_bin1(:,1))); std(low_bin2(:,2)-low_bin2(:,1))/sqrt(length(low_bin2(:,2)-low_bin2(:,1)));  std(low_bin3(:,2)-low_bin3(:,1))/sqrt(length(low_bin3(:,2)-low_bin3(:,1)));]);
            xlabel('Task Condition');
            xticks([0.75, 1, 1.25]);
            xticklabels({'b1', 'b2','b3'});
            ylabel('BOLD Response');
            %legend({'DGP', 'UGP', 'UGR'},'Location','northeast');
            axis square;
            title(['Low Strat (UG-DG)']);
            outname = fullfile([outputdir roi model]);
            cmd = ['print -depsc ' outname];
            eval(cmd);
            saveas(gca, fullfile(outname), 'svg');

            figure, barweb_dvs2([mean(high_bin1(:,2)-high_bin1(:,1)); mean(high_bin2(:,2)-high_bin2(:,1)); mean(high_bin3(:,2)-high_bin3(:,1))], [std(high_bin1(:,2)-high_bin1(:,1))/sqrt(length(high_bin1(:,2)-high_bin1(:,1))); std(high_bin2(:,2)-low_bin2(:,1))/sqrt(length(low_bin2(:,2)-high_bin2(:,1)));  std(high_bin3(:,1)-high_bin3(:,2))/sqrt(length(high_bin3(:,2)-high_bin3(:,1)));]);
            xlabel('Task Condition');
            xticks([0.75, 1, 1.25]);
            xticklabels({'b1', 'b2','b3'});
            ylabel('BOLD Response');
            %legend({'DGP', 'UGP', 'UGR'},'Location','northeast');
            axis square;
            title(['High strat (UG-DG)']);
            outname = fullfile([outputdir roi model]);
            cmd = ['print -depsc ' outname];
            eval(cmd);
            saveas(gca, fullfile(outname), 'svg');





            
            %Delta = DGP - UGP
            %[R,P] = corr(Delta, ID_Measure_2)

            %DGgUG=DGP-UGP;
            %UGgDG=UGP-DGP;

            %output_this=[DGgUG,UGgDG];

            %ones_output = array2table(output_this(1:end,:),'VariableNames', {'DGUG','UGDG'});
            %name = ('Insula_UGDG.xls');
            %writetable(ones_output, name); % Save as csv file

%             figure
% 
%             [R,P] = corrcoef(ID_Measure_1, (DGP-UGP));
%             scatter(ID_Measure_1, (DGP-UGP), 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
%             ylabel (['DG-UG ' roi type], 'FontSize', 12);
%             xlabel  (ID_Measure_1_name, 'FontSize', 12);
%             i = lsline;
%             i.LineWidth = 3.5;
%             i.Color = [0 0 0];
%             str=sprintf([' R=%1.2f' ' P=%1.2f'], [R(1,2) P(1,2)]);
%             T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str);
%             T.FontSize = 8;
%             outname3='IFG_strat'
%             saveas(gca, fullfile(outname3), 'svg');
 
        end  
    end
    
diary off
end

