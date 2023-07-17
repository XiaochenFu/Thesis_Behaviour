% read the name of each csv file from Data_FileNames.csv, 
% extract the Name of Splus and SMinus from the file name. Splus with one
% string and SMinus with one string 
% Save
clear
addpath("C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\CommonFunctions")
addpath('C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Group_Analyses\Summary_Stimuli')
csv_read_filename = 'Data_FileNames_Batch13.csv';
csv_write_filename = 'SP_SM_complex_string_Batch13.csv';
T0 = readtable(csv_read_filename);
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
writetable(mergedTable,csv_write_filename);