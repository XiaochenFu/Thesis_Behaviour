cc
addpath('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Code\Useful_Functions')
addpath('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Code\Useful_Functions\folderfile\natsortfiles')
% 1. a list of animals. for example, 1spot, fibre in, Tbx
% read a table from an excel sheet
Behaviour_Home_Path = 'C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour';
TT = readtable(fullfile(Behaviour_Home_Path,'\Group_Analyses\Behaviour_Summary.xlsx'),'VariableNamingRule','preserve'); % change the file name as needed

% Define the groups to process as a struct array
grps = struct('NumCellGroup', {'1spot', '1spot', '1spot', '3spot', '3spot', '3spot', 'Ai32', 'Ai32', '3spot_long', '2spot'}, 'background', {'lbhd', 'tbx', 'cck', 'lbhd', 'tbx', 'cck', 'tbx', 'lbhd', 'lbhd', 'lbhd'});

% Initialize the output table
outputTable = table('Size', [0 3], 'VariableTypes', {'string', 'string', 'string'}, 'VariableNames', {'BatchName', 'MouseID', 'FileName'});
% Process each group
for gg = 1:length(grps)
    NumCellGroup = grps(gg).NumCellGroup;
    bkground = grps(gg).background;
    grp_name = strcat(NumCellGroup,'_',bkground);

    %% Restriction
    % find the cell rows matches '1spot' in column AS, the value in column AT smaller than 0.5
    condition = strcmp(TT.NumCellGroup,NumCellGroup) & TT.CalculatedDistance < 0.5 & strcmp(TT.background,bkground); % create a logical array for the condition
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

        % Get all the JPG files in the current subfolder
        csvFiles = dir(fullfile(currentSubFolder, '*.csv'));

        % sort the filenames
        %         csvTables = struct2table(csvFiles); % convert the struct array to a table.
        %         sortedT = sortrows(csvTables, 'name'); % sort the table by 'Day' field.
        %         sortedS = table2struct(sortedT); % convert the sorted table back to a struct array.
        csvFiles = natsortfiles(csvFiles);




        % Loop through each JPG file in the current subfolder
        for j = 1:length(csvFiles)
            % Get the current JPG file name
            currentJpgFile = csvFiles(j).name;

            % Add a new row to the output table with the folder name, subfolder name, and JPG file name
            newRow = {mouseBatch, mouseID, currentJpgFile};
            outputTable = [outputTable; newRow];
        end


        % Write the output table to a CSV file
        writetable(outputTable, 'C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Group_Analyses\Summary_Stimuli\Data_FileNames.csv');
    end
end
cd('C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Group_Analyses\Summary_Stimuli')