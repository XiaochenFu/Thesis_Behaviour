% mouse_list
% stimuli list

% Loop for each mouse
%   loop for each light stimuli
%       read the name of the light files
%       copy the .mat file of light

%       read the name of the odour files
%       copy the .mat file of odour

%% setpath
addpath('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Code\Useful_Functions')
addpath('C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Group_Analyses\Summary_Stimuli')

%%
cc
%%

BatchID = 14;
% mouse_list
Mouse_list = {'TbxAi32_74','TbxAi32_79','TbxAi32_75','TbxAi32_78','TbxAi32_80'};
% stimuli list
Stimuli_list = {'Detection_25mW','Phase_Early_25mW','One_Early_25mW','Phase_Late_25mW','One_Late_25mW','1v3_25mW','3v1_25mW'};
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
% Loop for each mouse
for mi = 1:length(Mouse_list)
    MouseID = Mouse_list{mi};

    %   loop for each light stimuli
    for si = 1:length(Stimuli_list)
        StimuliName = Stimuli_list{si};
        %       read the name of the light files, if the filename exists
        filename_path = fullfile(currentDir, MouseID, 'FileName');
        
        % Check if the .mat file exists before loading
        mat_file_path = fullfile(filename_path, strcat(StimuliName, '.mat'));
        if isfile(mat_file_path)
            load(mat_file_path, 'Light_Stim_Raw_FileName','Light_Preprecessed_Mat_FileName','Odour_Stim_Raw_FileName','Odour_Preprecessed_Mat_FileName')
            
            % Create directory for output files if it does not exist
            light_chopped_path = fullfile(currentDir, MouseID, 'Chopped', StimuliName, 'Light');
            if ~exist(light_chopped_path, 'dir')
                mkdir(light_chopped_path);
            end
            
            odour_chopped_path = fullfile(currentDir, MouseID, 'Chopped', StimuliName, 'Odour');
            if ~exist(odour_chopped_path, 'dir')
                mkdir(odour_chopped_path);
            end
            
            % Load and process light .mat files
            for di = 1:length(Light_Preprecessed_Mat_FileName)
                file_name = Light_Preprecessed_Mat_FileName{di};
                [~,lightfilename,~] = fileparts(file_name);
                load(file_name);
                Behaviour_Info_Chopped = Chop_Behaviour_Continous_MIss(Behaviour_Info);
                save(fullfile(light_chopped_path, strcat(lightfilename,'_light.mat')), 'Behaviour_Info_Chopped');
                clear Behaviour_Info
            end
            
            % Load and process odour .mat files
            for di = 1:length(Odour_Preprecessed_Mat_FileName)
                file_name = Odour_Preprecessed_Mat_FileName{di};
                [~,odourfilename,~] = fileparts(file_name);
                load(file_name);
                Behaviour_Info_Chopped = Chop_Behaviour_Continous_MIss(Behaviour_Info);
                save(fullfile(odour_chopped_path, strcat(odourfilename,'_odour.mat')), 'Behaviour_Info_Chopped');
                clear Behaviour_Info
            end
        else
            warning('Mat file %s does not exist.', mat_file_path);
        end
    end
end