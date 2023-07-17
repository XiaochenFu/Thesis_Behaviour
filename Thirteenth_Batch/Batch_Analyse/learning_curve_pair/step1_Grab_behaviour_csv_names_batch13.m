cc
addpath('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Code\Useful_Functions')
addpath('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Code\Useful_Functions\folderfile\natsortfiles')
% 1. a list of animals. for example, 1spot, fibre in, Tbx
% read a table from an excel sheet
Behaviour_Home_Path = 'C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour';
TT = readtable(fullfile(Behaviour_Home_Path,'\Group_Analyses\Behaviour_Summary.xlsx'),'VariableNamingRule','preserve'); % change the file name as needed

output_path = pwd;

% Define the groups to process as a struct array
grps = struct('NumCellGroup', {'1spot', '1spot', '1spot', '3spot', '3spot', '3spot', 'Ai32', 'Ai32', '3spot_long', '2spot'}, 'background', {'lbhd', 'tbx', 'cck', 'lbhd', 'tbx', 'cck', 'tbx', 'lbhd', 'lbhd', 'lbhd'});

target_batch = 'Thirteenth';
csv_filename = 'Data_FileNames_Batch13.csv';

% Initialize the output table
outputTable = table('Size', [0 3], 'VariableTypes', {'string', 'string', 'string'}, 'VariableNames', {'BatchName', 'MouseID', 'FileName'});
% Process each group

%

%% Restriction
condition = strcmp(TT.Batch,target_batch);
rst = TT(condition,:); % extract the rows that satisfy the condition

% Process each animal
for i = 1:height(rst)
    mouseID = rst.Name_Behaviour{i};

    % Get the batch name and folder
    mouseBatch = rst.Batch{i};
    batchname = append(mouseBatch,'_Batch');
    Behaviour_Accuracy_Folder = fullfile(Behaviour_Home_Path,batchname,mouseID,'Recording');
    cd(Behaviour_Accuracy_Folder)

    % Define the folder path
    folderPath = Behaviour_Accuracy_Folder;

    % Get all the subfolders
    subFolders = genpath(folderPath);

    % Split the subfolders into separate strings
    subFolders = split(subFolders, ';');

    % Loop through each subfolder

    % Get the current subfolder path
    currentSubFolder = subFolders{1};

    % Get all the csv files in the current subfolder
    csvFiles = dir(fullfile(currentSubFolder, '*.csv'));

    % sort the filenames
    %         csvTables = struct2table(csvFiles); % convert the struct array to a table.
    %         sortedT = sortrows(csvTables, 'name'); % sort the table by 'Day' field.
    %         sortedS = table2struct(sortedT); % convert the sorted table back to a struct array.
    csvFiles = natsortfiles(csvFiles);




    % Loop through each csv file in the current subfolder
    for j = 1:length(csvFiles)
        % Get the current csv file name
        currentJpgFile = csvFiles(j).name;
        % Add a new row to the output table with the folder name, subfolder name, and csv file name
        newRow = {mouseBatch, mouseID, currentJpgFile};
        outputTable = [outputTable; newRow];
    end


    % Write the output table to a CSV file

end


writetable(outputTable, fullfile(output_path,csv_filename));