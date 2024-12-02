

accept_input = readtable('accept.csv')
reject_input = readtable('reject.csv')

accept = [];
reject = [];

for ii = 1:length(subj)
    sub = num2str(subj(ii));
    indices = contains(accept_input.Var2,sub);
    indices = +indices; % convert
    vals = find(indices==1);
    row = sum(accept_input.Var1(vals));
    
    saverow = [subj(ii),row];
    
    accept = [accept;saverow]
  
end

for ii = 1:length(subj)
    sub = num2str(subj(ii));
    indices = contains(reject_input.Var2,sub);
    indices = +indices; % convert
    vals = find(indices==1);
    row = sum(reject_input.Var1(vals));
    
    saverow = [subj(ii),row];
    
    reject = [reject;saverow]
  
end


            % I need to deal with the stupid rows of runs.
