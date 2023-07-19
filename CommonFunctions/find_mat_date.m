function matchedFiles = find_mat_date(TargetPath, Input_FileName)
    % This function looks for .mat files in TargetPath that contain the day
    % segment (e.g., 'Day4') of the Input_FileName.
    %
    % Inputs:
    %   TargetPath - The path of the directory to look for .mat files.
    %   Input_FileName - The file name from which the day segment is extracted.
    %
    % Outputs:
    %   matchedFiles - A cell array containing the names of the .mat files that
    %                  contain the day segment of Input_FileName.

    % Extract day segment from the Input_FileName using regex
    daySegment = regexp(Input_FileName, 'Day\d+', 'match', 'once');

    if isempty(daySegment)
        error('Input_FileName does not contain a day segment (e.g., Day4).');
    end

    % Append an underscore to the day segment to avoid matching longer strings
    daySegment = [daySegment, '_'];

    % Get a list of .mat files in the TargetPath
    matFiles = dir(fullfile(TargetPath, '*.mat'));

    % Initialize a cell array to store the names of matched files
    matchedFiles = {};

    % Loop over each .mat file
    for i = 1:numel(matFiles)
        % If the file name contains the day segment, add it to matchedFiles
        if contains(matFiles(i).name, daySegment)
            matchedFiles{end+1} = fullfile(TargetPath, matFiles(i).name);  % append the file name to the cell array
        end
    end
end
