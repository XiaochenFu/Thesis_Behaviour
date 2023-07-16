function fileList = find_raw_csv_files(TargetPath, Input_FileName)
    % This function finds and returns the names of all .csv files in the specified
    % directory that contain one of the 12-digit substrings found in the input file name.
    %
    % Inputs:
    %   TargetPath - The path to the directory containing the .csv files to be searched.
    %   Input_FileName - The name of the input file. This should contain two 
    %                    12-digit substrings.
    %
    % Outputs:
    %   fileList - A cell array containing the full names of the files that
    %              share a common 12-digit substring with the input file name.

    % Use regular expression to find all 12-digit substrings in the input file name
    matches = regexp(Input_FileName, '\d{12}', 'match');
    
    % Initialize an empty cell array to hold the file names
    fileList = {};
    
    % Get all .csv files in the target path
    files = dir(fullfile(TargetPath, '*.csv'));
    
    % Loop over all files in the directory
    for i = 1:length(files)
        % Check if the file name contains either of the 12-digit substrings
        if any(contains(files(i).name, matches))
            % If it does, add the full file name to the output list
            fileList = [fileList; fullfile(TargetPath, files(i).name)];
        end
    end
end
