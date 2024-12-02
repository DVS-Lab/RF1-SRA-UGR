clear all
close all
clc

%% Behavioral Data analysis

% 06/02/2023
% Daniel Sazhin
% Temple University
% RF1 Project

% This script takes a participant's responses from log files in RF1 and collapses them into a
% dollar amount for analysis. 

currentdir = pwd;
maindir = '/ZPOOL/data/projects/rf1-sra/stimuli/Scan-Lets_Make_A_Deal'; % set on computer doing the analysis
%maindir = 'A:/Data/rf1-sra/stimuli/Scan-Lets_Make_A_Deal'

output_folder = [currentdir '/output/'];
subjects_all = readtable('sublist_all.txt');
subjects = table2array(subjects_all);

% subjects = [10317
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

%% Extract data

% I need to parse the data into the separate games.

for ii= 1:length(subjects)
    subj = subjects(ii);
    
    UG_R_accept_2 = [];
    UG_R_reject_2 = [];
    DG_P_2 = [];
    UG_P_2 = [];
    UG_R_accept = [];
    UG_R_reject = [];
    DG_P = [];
    UG_P = [];

try

r1 = 1; % Run 1
r2 = 1;

% if subj == 1010
%     r2 = 0;
% end
% 
% if subj == 3199
%     r2 = 0;
% end
% 
% if subj == 3223
%     r2 = 0;
% end

% Select 1 if you want to use the run. Zero if not.

%% Run 1

if r1 > 0
    
    for r = 0
        
        % sub-101_task-ultimatum_run-0_raw.csv sub-102_task-ultimatum_run-1_raw.csv
        fname = fullfile(maindir,'logs',num2str(subj),sprintf('sub-%04d_task-ultimatum_run-%d_raw.csv',subj,r)); % Psychopy taken out from Logs to make work for now.
        if exist(fname,'file')
            fid = fopen(fname,'r');
        else
            fprintf('sub-%d -- Let''s Make a Deal Game, Run %d: No data found.\n', subj, r+1)
            continue;
        end
        C = textscan(fid,repmat('%f',1,23),'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
        fclose(fid);
        
        
        % "Feedback" is the offer value (out of $20)
        
        Trial = C{1};
        Block = C{3};
        Endowment = C{4};
        response = C{17};
        response = round(response);
        L_Option = C{7};
        R_Option = C{8};
        
    end
    
    
    % Distribute games per responses
    
    % Block 1 = UG Prop
    % Block 2 = DG prop
    % Block 3 = UG Resp
    
     for t = 1:length(Endowment)
        
        if Block(t) == 3 % If UG Recipient
            if response(t) == 1 % If selected left option
                if round(L_Option(t)) > 0 % This means that the L Option is the offer.
                    update = [Trial(t), Block(t), Endowment(t), L_Option(t), 1, L_Option(t), L_Option(t)/Endowment(t)]; %, Endowment(t)/L_Option(t)];
                    UG_R_accept = [UG_R_accept; update];
                else
                    update = [Trial(t), Block(t), Endowment(t), L_Option(t), 0, R_Option(t), R_Option(t)/Endowment(t)]; %, R_Option(t), Endowment(t)/R_Option(t)];
                    UG_R_reject = [UG_R_reject; update];
                end
            end
        end
        
        if Block(t) == 3
            if response(t) == 2
                if round(R_Option(t)) > 0
                    update = [Trial(t), Block(t), Endowment(t), R_Option(t), 1, R_Option(t), R_Option(t)/Endowment(t)]; % Trial number, Endowment, Choice, Accept, More_Proportion, Less_Proportion
                    UG_R_accept = [UG_R_accept; update];
                else
                    update = [Trial(t), Block(t), Endowment(t), R_Option(t), 0, L_Option(t), L_Option(t)/Endowment(t)];
                    UG_R_reject = [UG_R_reject; update];
                end
            end
        end

         if Block(t) == 2 % If UG Recipient
            if response(t) == 1 % If selected left option
                if round(L_Option(t)) > 0 % This means that the L Option is the offer.
                    update = [Trial(t), Block(t), Endowment(t), L_Option(t), 1, L_Option(t), L_Option(t)/Endowment(t)]; %, Endowment(t)/L_Option(t)];
                    UG_R_accept = [UG_R_accept; update];
                else
                    update = [Trial(t), Block(t), Endowment(t), L_Option(t), 0, R_Option(t), R_Option(t)/Endowment(t)]; %, R_Option(t), Endowment(t)/R_Option(t)];
                    UG_R_reject = [UG_R_reject; update];
                end
            end
        end
        
        if Block(t) == 2
            if response(t) == 2
                if round(R_Option(t)) > 0
                    update = [Trial(t), Block(t), Endowment(t), R_Option(t), 1, R_Option(t), R_Option(t)/Endowment(t)]; % Trial number, Endowment, Choice, Accept, More_Proportion, Less_Proportion
                    UG_R_accept = [UG_R_accept; update];
                else
                    update = [Trial(t), Block(t), Endowment(t), R_Option(t), 0, L_Option(t), L_Option(t)/Endowment(t)];
                    UG_R_reject = [UG_R_reject; update];
                end
            end
        end
     
        
     end
end
  
   

%% Run 2

if r2 > 0
    for r = 1
        
           % sub-101_task-ultimatum_run-0_raw.csv sub-102_task-ultimatum_run-1_raw.csv
        fname = fullfile(maindir,'logs',num2str(subj),sprintf('sub-%04d_task-ultimatum_run-%d_raw.csv',subj,r)); % Psychopy taken out from Logs to make work for now.
        if exist(fname,'file')
            fid = fopen(fname,'r');
        else
            fprintf('sub-%d -- Let''s Make a Deal Game, Run %d: No data found.\n', subj, r+1)
            continue;
        end
        C = textscan(fid,repmat('%f',1,23),'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
        fclose(fid);
        
        
        % "Feedback" is the offer value (out of $20)
        
        Trial = C{1};
        Block = C{3};
        Endowment = C{4};
        response = C{17};
        response = round(response);
        L_Option = C{7};
        R_Option = C{8};
        
    end
    
    
   % Distribute games per responses
    
    % Block 1 = UG Prop
    % Block 2 = DG prop
    % Block 3 = UG Resp
    
     for t = 1:length(Endowment)
        
        if Block(t) == 3 % If UG Recipient
            if response(t) == 1 % If selected left option
                if round(L_Option(t)) > 0 % This means that the L Option is the offer.
                    update = [Trial(t), Block(t), Endowment(t), L_Option(t), 1, L_Option(t), L_Option(t)/Endowment(t)]; %, Endowment(t)/L_Option(t)];
                    UG_R_accept_2 = [UG_R_accept_2; update];
                else
                    update = [Trial(t), Block(t), Endowment(t), L_Option(t), 0, R_Option(t), R_Option(t)/Endowment(t)]; %, R_Option(t), Endowment(t)/R_Option(t)];
                    UG_R_reject_2 = [UG_R_reject_2; update];
                end
            end
        end
        
        if Block(t) == 3 % If UG Recipient
            if response(t) == 2 % If selected left option
                if round(L_Option(t)) > 0 % This means that the L Option is the offer.
                    update = [Trial(t), Block(t), Endowment(t), L_Option(t), 1, L_Option(t), L_Option(t)/Endowment(t)]; %, Endowment(t)/L_Option(t)];
                    UG_R_accept_2 = [UG_R_accept_2; update];
                else
                    update = [Trial(t), Block(t), Endowment(t), L_Option(t), 0, R_Option(t), R_Option(t)/Endowment(t)]; %, R_Option(t), Endowment(t)/R_Option(t)];
                    UG_R_reject_2 = [UG_R_reject_2; update];
                end
            end
        end

        if Block(t) == 2 % If UG Recipient
            if response(t) == 1 % If selected left option
                if round(L_Option(t)) > 0 % This means that the L Option is the offer.
                    update = [Trial(t), Block(t), Endowment(t), L_Option(t), 1, L_Option(t), L_Option(t)/Endowment(t)]; %, Endowment(t)/L_Option(t)];
                    UG_R_accept_2 = [UG_R_accept_2; update];
                else
                    update = [Trial(t), Block(t), Endowment(t), L_Option(t), 0, R_Option(t), R_Option(t)/Endowment(t)]; %, R_Option(t), Endowment(t)/R_Option(t)];
                    UG_R_reject_2 = [UG_R_reject_2; update];
                end
            end
        end
        
        if Block(t) == 2 % If UG Recipient
            if response(t) == 2 % If selected left option
                if round(L_Option(t)) > 0 % This means that the L Option is the offer.
                    update = [Trial(t), Block(t), Endowment(t), L_Option(t), 1, L_Option(t), L_Option(t)/Endowment(t)]; %, Endowment(t)/L_Option(t)];
                    UG_R_accept_2 = [UG_R_accept_2; update];
                else
                    update = [Trial(t), Block(t), Endowment(t), L_Option(t), 0, R_Option(t), R_Option(t)/Endowment(t)]; %, R_Option(t), Endowment(t)/R_Option(t)];
                    UG_R_reject_2 = [UG_R_reject_2; update];
                end
            end
        end
     
       
     end
end
  
   




%% UG_R Earnings

% UG_R_Earnings is easy... simply add the accept behavior.

for ii = 1
    
    try
        
        a = size(UG_R_accept);
        b = size(UG_R_accept_2);
        a = a(1);
        b = b(1);
          
 
    if a>0 || b==0
        
        UG_R_Earnings = sum(UG_R_accept(:,3));
    end
    
    if b>0 || a==0
        
        UG_R_Earnings = sum(UG_R_accept_2(:,3));
        
    end
    
    if a>0 || b>0
        
        UG_R_Earnings = (sum(UG_R_accept_2(:,3)) + sum(UG_R_accept(:,3)))/2 ;
         
    end
    end
    
end



%% UG_R_Rejection behavior

% Proportion of rejection and acceptances

try
    Accepted = UG_R_accept_2(:,3) ./ UG_R_accept_2(:,2);  
end
try
    Accepted = [Accepted; UG_R_accept(:,3) ./ UG_R_accept(:,2)];
end
try
    Rejected = UG_R_reject_2(:,3) ./ UG_R_reject_2(:,2);
end
try
    Rejected = [Rejected; UG_R_reject(:,3) ./ UG_R_reject(:,2)];
end
    


%% Save

try
    UG_R_Behavior_Accepted = array2table(Accepted(1:end,:),'VariableNames', {'Accept',});
    UG_R_Behavior_Rejected = array2table(Rejected(1:end,:),'VariableNames', {'Reject',});
    output = ['Subject_' num2str(subj) '_accepted.csv'];
    name = [output_folder,output];
    writetable(UG_R_Behavior_Accepted, name); % Save as csv file
    output = ['Subject_' num2str(subj) '_rejected.csv'];
    name = [output_folder,output];
    writetable(UG_R_Behavior_Rejected, name); % Save as csv file
    
end

Total = [UG_R_Earnings];
UG_R_earnings = array2table(Total(1:end,:),'VariableNames', {'UG_R_Earnings'});
output = ['Subject_' num2str(subj) '_Earnings.csv'];
name = [output_folder,output];
writetable(UG_R_earnings , name); % Save as csv file



%% Save recipient with all info

try
    
UG_R_accept_save = [UG_R_accept;UG_R_accept_2];
UG_R_reject_save = [UG_R_reject;UG_R_reject_2];

UG_R_accept_save_table = array2table(UG_R_accept_save(1:end,:),'VariableNames', {'Trial','Block','Endowment','Earned', 'Choice','Offer','Prop_Endowment'});
output = ['Subject_' num2str(subj) '_accept_analysis.csv'];
name = [output_folder,output];
writetable(UG_R_accept_save_table, name); % Save as csv file

UG_R_reject_save_table = array2table(UG_R_reject_save(1:end,:),'VariableNames', {'Trial','Block','Endowment','Earned', 'Choice', 'Offer','Prop_Endowment'});
output = ['Subject_' num2str(subj) '_reject_analysis.csv'];
name = [output_folder,output];
writetable(UG_R_reject_save_table, name); % Save as csv file

end


end
end