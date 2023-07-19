% mouse_list
% stimuli list

% Loop for each mouse
%   loop for each light stimuli
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

BatchID = 13;

% mouse_list
Mouse_list = {'TbxAi32_71','TbxAi32_72','TbxAi32_76','TbxAi32_77'};
% stimuli list
Stimuli_list = {'Detection_25mW','Phase_Early_25mW','One_Early_25mW','Phase_Late_25mW','One_Late_25mW','1v3_25mW','3v1_25mW'};
%% read the filenames
T0 = readtable('SP_SM_complex_string_Batch13.csv');
T = table2struct(T0);
%%
currentDir = pwd;
% Get the parent directory (one level up)
[parentDir,~,~] = fileparts(currentDir);
% Get the grandparent directory (two levels up)
[Batch_Path,~,~] = fileparts(parentDir);
%%
% Loop for each mouse
for mi = 1:length(Mouse_list)
    MouseID = Mouse_list{mi};

    %   loop for each light stimuli
    for si = 1:length(Stimuli_list)
        StimuliName = Stimuli_list{si};
        % Check if the .mat file exists before loading
        light_chopped_path = fullfile(currentDir, MouseID, 'Chopped', StimuliName, 'Light');
        light_cat_path = fullfile(currentDir, MouseID, 'Cat', StimuliName);
        odour_chopped_path = fullfile(currentDir, MouseID, 'Chopped', StimuliName, 'Odour');
        odour_cat_path = fullfile(currentDir, MouseID, 'Cat', StimuliName);


        if isfolder(light_chopped_path)
            %% light part
            mkdir(light_cat_path)

            file_list = dir(light_chopped_path);
            %       read the chopped the light files

            file_list = natsortfiles(file_list);
            % Initialize an empty cell array to store the renamed cell arrays
            C_list = {};
            for di = 3:length(file_list)
                file_name = file_list(di);
                load(fullfile(file_name.folder, file_name.name))
                % Rename C to C_i in the base workspace
                assignin('base', ['C_' num2str(di)], Behaviour_Info_Chopped);
                % Add the try-catch block to handle the case when a file is empty or cannot be loaded
                try
                    % Add C_i to the cell array
                    C_list{di} = evalin('base', ['C_' num2str(di)]);
                catch ME
                    % If an error occurs, display a warning message and add an empty cell to the array
                    warning(['Error loading file ' file_name ': ' ME.message])
                    C_list{di} = [];
                end
            end
            % Remove empty cells from the cell array
            C_list(cellfun(@isempty, C_list)) = [];
            % Check if any files were loaded
            if ~isempty(C_list)
                % Concatenate all the cell arrays along the first dimension (rows)
                Behaviour_Info_cat = cat(2, C_list{:});
                % save
                save(fullfile(light_cat_path,strcat('light','.mat')),'Behaviour_Info_cat')
            else
                % If no files were loaded, display a warning message
                warning(['No files found for stimulus ' Stimuli ' in ' mouseID])
            end

            %% odour part
            mkdir(odour_cat_path)

            file_list = dir(odour_chopped_path);
            %       read the chopped the odour files

            file_list = natsortfiles(file_list);
            % Initialize an empty cell array to store the renamed cell arrays
            C_list = {};
            for di = 3:length(file_list)
                file_name = file_list(di);
                load(fullfile(file_name.folder, file_name.name))
                % Rename C to C_i in the base workspace
                assignin('base', ['C_' num2str(di)], Behaviour_Info_Chopped);
                % Add the try-catch block to handle the case when a file is empty or cannot be loaded
                try
                    % Add C_i to the cell array
                    C_list{di} = evalin('base', ['C_' num2str(di)]);
                catch ME
                    % If an error occurs, display a warning message and add an empty cell to the array
                    warning(['Error loading file ' file_name ': ' ME.message])
                    C_list{di} = [];
                end
            end
            % Remove empty cells from the cell array
            C_list(cellfun(@isempty, C_list)) = [];
            % Check if any files were loaded
            if ~isempty(C_list)
                % Concatenate all the cell arrays along the first dimension (rows)
                Behaviour_Info_cat = cat(2, C_list{:});
                % save
                save(fullfile(odour_cat_path,strcat('odour','.mat')),'Behaviour_Info_cat')
            else
                % If no files were loaded, display a warning message
                warning(['No files found for stimulus ' Stimuli ' in ' mouseID])
            end
        end


    end
end