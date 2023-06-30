clear all 
close all
clc

% This task inputs existing evfiles, goes through all of the decisions,
% outputs new EVfiles as bins of proportions of offers.

% Daniel Sazhin
% 05/05/2022
% Temple University

% Inputs

input_dir = '/data/projects/istart-ugdg/derivatives/fsl/EVfiles/';

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


% Open subject

% all_props = [];

% for ii = 1:length(subjects) 
%     subnum = subjects(ii); % ii
%     subnum = num2str(subnum);
%     open_dir = [input_dir 'sub-' subnum '/ugdg_GLM2_d/'];
%     
%     
%     dgp_r1 = 'run-01_dec_dg-prop_pmod_choice_pmod';
%     dgp_r2 = 'run-02_dec_dg-prop_pmod_choice_pmod';
%     
%     tasks = [dgp_r1; dgp_r2];
%     sub_props = [];
%     
%     for jj = 1:2
%         
%         t = importdata([open_dir tasks(jj,:) '.txt']);
%     
%         proportions = t(:,3);
%         
%         Q = prctile(proportions,[25 50 75]);
%         
%         bin1 = [];
%         bin2 = [];
%         bin3 = [];
%         bin4 = [];
%         
%         for kk = 1:length(t);
%             if proportions(kk) <  Q(1)
%                 save1 = t(kk,:);
%                 bin1 = [bin1; save1];
%             end
%             
%             if proportions(kk) >=  Q(1) && proportions(kk) < Q(2)
%                 save1 = t(kk,:);
%                 bin2 = [bin2; save1];
%             end
%             
%             if proportions(kk) >= Q(2) && proportions(kk) < Q(3)
%                 save1 = t(kk,:);
%                 bin3 = [bin3; save1];
%             end
%             
%             if proportions(kk) >= Q(3)
%                 save1 = t(kk,:);
%                 bin4 = [bin4; save1];
%             end
% 
%         end
%         
%         sub_props = [sub_props; proportions];
%             
%             bin1name = [open_dir tasks(jj,:) '_bin1.txt'];
%             fileID = fopen(bin1name,'w');
%             fprintf(fileID, '%2d %2d\t%2d\n',bin1);
%             fclose(fileID);
%             
%             bin2name = [open_dir tasks(jj,:) '_bin2.txt'];
%             fileID = fopen(bin2name,'w');
%             fprintf(fileID, '%2d %2d\t%2d\n',bin2);
%             fclose(fileID);
%             
%             bin3name = [open_dir tasks(jj,:) '_bin3.txt'];
%             fileID = fopen(bin3name,'w');
%             fprintf(fileID, '%2d %2d\t%2d\n',bin3);
%             fclose(fileID);
%             
%             bin4name = [open_dir tasks(jj,:) '_bin4.txt'];
%             fileID = fopen(bin4name,'w');
%             fprintf(fileID, '%2d %2d\t%2d\n',bin4);
%             fclose(fileID);
%             
%     end
%     all_props = [all_props; sub_props];
% end
% 
% % quantile(all_props,[.25 .5 .75]) % use to set the bins
%          
% %% UG-P 
% all_props = [];
% 
% for ii = 1:length(subjects) 
%     subnum = subjects(ii); % ii
%     subnum = num2str(subnum);
%     open_dir = [input_dir 'sub-' subnum '/ugdg_GLM2_d/'];
%   
%     ugp_r1 = 'run-01_dec_ug-prop_pmod_choice_pmod';
%     ugp_r2 = 'run-02_dec_dg-prop_pmod_choice_pmod';
%   
%     tasks = [ugp_r1; ugp_r2];
%     sub_props = [];
%     
%     for jj = 1:2
%         
%         t = importdata([open_dir tasks(jj,:) '.txt']);
%     
%         proportions = t(:,3);
%         
%         Q = prctile(proportions,[25 50 75]);
%         
%         bin1 = [];
%         bin2 = [];
%         bin3 = [];
%         bin4 = [];
%         
%         for kk = 1:length(t);
%             if proportions(kk) < Q(1)
%                 save1 = t(kk,:);
%                 bin1 = [bin1; save1];
%             end
%             
%             if proportions(kk) >= Q(1) && proportions(kk) < Q(2)
%                 save1 = t(kk,:);
%                 bin2 = [bin2; save1];
%             end
%             
%             if proportions(kk) >= Q(2) && proportions(kk) < Q(3)
%                 save1 = t(kk,:);
%                 bin3 = [bin3; save1];
%             end
%             
%             if proportions(kk) >= Q(3)
%                 save1 = t(kk,:);
%                 bin4 = [bin4; save1];
%             end
% 
%         end
%         
%         sub_props = [sub_props; proportions];
%             
%             bin1name = [open_dir tasks(jj,:) '_bin1.txt'];
%             fileID = fopen(bin1name,'w');
%             fprintf(fileID, '%2d %2d\t%2d\n',bin1);
%             fclose(fileID);
%             
%             bin2name = [open_dir tasks(jj,:) '_bin2.txt'];
%             fileID = fopen(bin2name,'w');
%             fprintf(fileID, '%2d %2d\t%2d\n',bin2);
%             fclose(fileID);
%             
%             bin3name = [open_dir tasks(jj,:) '_bin3.txt'];
%             fileID = fopen(bin3name,'w');
%             fprintf(fileID, '%2d %2d\t%2d\n',bin3);
%             fclose(fileID);
%             
%             bin4name = [open_dir tasks(jj,:) '_bin4.txt'];
%             fileID = fopen(bin4name,'w');
%             fprintf(fileID, '%2d %2d\t%2d\n',bin4);
%             fclose(fileID);
%             
%     end
%     all_props = [all_props; sub_props];
% end


%% UG-R 
        
all_props = []; 

for ii = 1:length(subjects) 
    subnum = subjects(ii); % ii
    subnum = num2str(subnum);
    open_dir = [input_dir 'sub-' subnum '/ugdg_GLM3/'];
   
    ugr_r1 = 'run-01_dec_ug-resp_pmod_choice_pmod';
    ugr_r2 = 'run-02_dec_dg-prop_pmod_choice_pmod';
    
    tasks = [ugr_r1; ugr_r2];
    sub_props = [];
    
    for jj = 1
        
        t = importdata([open_dir tasks(jj,:) '.txt']);
        %m = mean(t)
        proportions = t(:,3);
        
        Q = prctile(proportions,[33.33 66.67]);
        
        bin1 = [];
        bin2 = [];
        bin3 = [];
        
        for kk = 1:length(t);
            if proportions(kk) < Q(1)
                save1 = t(kk,:);
                bin1 = [bin1; save1];
            end
            
            if proportions(kk) >= Q(1) && proportions(kk) < Q(2)
                save1 = t(kk,:);
                bin2 = [bin2; save1];
            end
            
            if proportions(kk) >= Q(2)
                save1 = t(kk,:);
                bin3 = [bin3; save1];
            end

        end
            
            bin1name = [open_dir tasks(jj,:) '_bin1.txt'];
            fileID = fopen(bin1name,'w');
            fprintf(fileID, '%2d %2d\t%2d\n',bin1);
            fclose(fileID);
            
            bin2name = [open_dir tasks(jj,:) '_bin2.txt'];
            fileID = fopen(bin2name,'w');
            fprintf(fileID, '%2d %2d\t%2d\n',bin2);
            fclose(fileID);
            
            bin3name = [open_dir tasks(jj,:) '_bin3.txt'];
            fileID = fopen(bin3name,'w');
            fprintf(fileID, '%2d %2d\t%2d\n',bin3);
            fclose(fileID);
            
    end
   
end


         