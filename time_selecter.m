function A = time_selecter(A,folder)
%load toi (time of interest) from exp data folder

try
    toi = csvread(fullfile(folder,'toi.csv'));
    A = time_select(A,toi);
catch    
    [A,toi] = time_select_inspect(A);
    csvwrite(fullfile(folder,'toi.csv'),toi);
    disp(['Wrote toi to: ' fullfile(folder,'toi.csv')]);
end

end