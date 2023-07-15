% read the name of each csv file from Data_FileNames.csv, 
% extract the Name of Splus and SMinus from the file name. Splus with one
% string and SMinus with one string 
% Save
clear
addpath("C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\CommonFunctions")
T0 = readtable('Data_FileNames.csv');
T = table2struct(T0);
% TT  = [T, array2table(ones(size(T,1),2), 'VariableNames', {'Splus', 'SMinus'})];
TT.Splus = [];
TT.Sminus = [];
% thirdColumn = T{:,3};
thirdColumn = extractfield(T,'FileName');
for i = 1:size(T,1)
    fname = thirdColumn{i};
    [SPlusName, SMinusName] = fun_Extract_SPSM_simple_str_from_Behaviour_FileName(fname);
    TT(i).Splus = SPlusName;
    TT(i).Sminus  = SMinusName;
end
TT0 = struct2table(TT);
mergedTable = [T0, TT0];
writetable(mergedTable,'SP_SM_simple_string.csv');