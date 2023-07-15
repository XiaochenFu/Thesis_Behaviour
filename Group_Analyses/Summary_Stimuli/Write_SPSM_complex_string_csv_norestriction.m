% read the name of each csv file from Data_FileNames.csv,
% extract the Name of Splus and SMinus from the file name. Splus with one
% string and SMinus with one string
% Save
clear
addpath("C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\CommonFunctions")
T0 = readtable('Data_FileNames_no_restriction.csv');
T = table2struct(T0);

% thirdColumn = T{:,3};
thirdColumn = extractfield(T,'FileName');
for i = 1:size(T,1)
    fname = thirdColumn{i};
    % Instead of returning a string, here we need a table with all
    % necesssary information

        SPSMStruct = fun_Extract_SPSM_complex_Structure_from_Behaviour_FileName(fname);
        TT(i) = SPSMStruct;

end
TT0 = struct2table(TT);
mergedTable = [T0, TT0];
writetable(mergedTable,'SP_SM_complex_string_no_restriction.csv');