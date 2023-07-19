function copyAndRenameMatFiles(InputPath)
% Parse InputPath to get mouse id and stimuli name
splitPath = strsplit(InputPath, filesep);
MouseID = splitPath{end-2}; % the MouseID is two levels up from the last directory in InputPath
StimuliName = splitPath{end}; % the StimuliName is the last directory in InputPath

% Define source file paths
lightSourcePath = fullfile(InputPath, 'light.mat');
odourSourcePath = fullfile(InputPath, 'odour.mat');

% Error handling for missing .mat files
if ~isfile(lightSourcePath)
    error('light.mat file does not exist in the InputPath.');
end
if ~isfile(odourSourcePath)
    error('odour.mat file does not exist in the InputPath.');
end

% Define destination directories
parentPath = fullfile(splitPath{1:end-3}); % The parent directory is three levels up from the last directory in InputPath
lightDestDir = fullfile(parentPath, 'Group', StimuliName, 'light');
odourDestDir = fullfile(parentPath, 'Group', StimuliName, 'odour');

% Create destination directories if they do not exist
if ~exist(lightDestDir, 'dir')
    mkdir(lightDestDir);
end
if ~exist(odourDestDir, 'dir')
    mkdir(odourDestDir);
end

% Define destination file paths (with new names)
lightDestPath = fullfile(lightDestDir, [MouseID, '.mat']);
odourDestPath = fullfile(odourDestDir, [MouseID, '.mat']);

% Copy files to new locations and rename
copyfile(lightSourcePath, lightDestPath);
copyfile(odourSourcePath, odourDestPath);

% fprintf('Files have been copied and renamed successfully.\n');
end
