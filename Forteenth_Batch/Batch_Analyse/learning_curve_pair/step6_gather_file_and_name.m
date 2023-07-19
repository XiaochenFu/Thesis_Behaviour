% mouse_list
% stimuli list

% Loop for each light stimuli
%   loop for each mouse
%       read the chopped the light files
%       cat
%       save

%       read the chopped odour stimuli
%       cat
%       save

%% setpath
addpath('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Code\Useful_Functions')
addpath('C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Group_Analyses\Summary_Stimuli')

%%
cc
%%
BatchID = 14;
% mouse_list
Mouse_list = {'TbxAi32_74','TbxAi32_79','TbxAi32_75','TbxAi32_78'};%%,'TbxAi32_80'
% stimuli list
Stimuli_list = {'Detection_25mW','Phase_Early_25mW','One_Early_25mW','Phase_Late_25mW','One_Late_25mW'};
%% read the filenames
T0 = readtable('SP_SM_complex_string_Batch14.csv');
T = table2struct(T0);
%%
currentDir = pwd;
% Get the parent directory (one level up)
[parentDir,~,~] = fileparts(currentDir);
% Get the grandparent directory (two levels up)
[Batch_Path,~,~] = fileparts(parentDir);
%%


%   loop for each light stimuli
for si = 1:length(Stimuli_list)
    StimuliName = Stimuli_list{si};

    % Initialize the cell array to hold the file names
    Odour_Stim_Raw_FileNames = {};
    Light_Stim_Raw_FileNames = {};
    % Loop for each mouse
    for mi = 1:length(Mouse_list)
        MouseID = Mouse_list{mi};
        % Check if the .mat file exists before loading
%         light_chopped_path = fullfile(currentDir, MouseID, 'Chopped', StimuliName, 'Light');
        light_cat_path = fullfile(currentDir, MouseID, 'Cat', StimuliName);
%         odour_chopped_path = fullfile(currentDir, MouseID, 'Chopped', StimuliName, 'Odour');
        odour_cat_path = fullfile(currentDir, MouseID, 'Cat', StimuliName);


        if exist(light_cat_path)
            %% light part
            copyAndRenameMatFiles(light_cat_path)



            % Define the path to the .mat file that store the filenames
            matFilePath = fullfile(currentDir, MouseID, 'FileName',  [StimuliName, '.mat']);

            % Check if the file exists
            if isfile(matFilePath)
                % Load the file
                loadedData = load(matFilePath);

                % If the loaded data has the 'Odour_Stim_Raw_FileName' field, add it to the cell array
                if isfield(loadedData, 'Odour_Stim_Raw_FileName')
                    Odour_Stim_Raw_FileNames = [Odour_Stim_Raw_FileNames; loadedData.Odour_Stim_Raw_FileName];
                end
            end

            %% odour part
            copyAndRenameMatFiles(odour_cat_path)

            % Define the path to the .mat file that store the filenames
            matFilePath = fullfile(currentDir, MouseID, 'FileName',  [StimuliName, '.mat']);

            % Check if the file exists
            if isfile(matFilePath)
                % Load the file
                loadedData = load(matFilePath);

                % If the loaded data has the 'Light_Stim_Raw_FileName' field, add it to the cell array
                if isfield(loadedData, 'Light_Stim_Raw_FileName')
                    Light_Stim_Raw_FileNames = [Light_Stim_Raw_FileNames; loadedData.Light_Stim_Raw_FileName];
                end
            end
        end


    end
    % Define the output directory and csv file path
    outputDir = fullfile(currentDir, 'Group', StimuliName);
    csvFilePath = fullfile(outputDir, 'odour.csv');
    % Write the cell array to the csv file
    cell2csv(csvFilePath, Odour_Stim_Raw_FileNames);

    % Define the output directory and csv file path
    outputDir = fullfile(currentDir, 'Group',StimuliName);
    csvFilePath = fullfile(outputDir, 'light.csv');
    % Write the cell array to the csv file
    cell2csv(csvFilePath, Light_Stim_Raw_FileNames);

end

% Helper function to write a cell array to a csv file
function cell2csv(fileName, cellArray)
fid = fopen(fileName, 'w');
for row = 1:numel(cellArray)
    fprintf(fid, '%s\n', cellArray{row});
end
fclose(fid);
end