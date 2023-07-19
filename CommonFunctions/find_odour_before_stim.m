function OdourfileNames = find_odour_before_stim(MouseID, Input_FileName, InputTable)
    % Extract the day from the input file name.
    inputDay = str2double(regexp(Input_FileName, 'Day(\d+)', 'tokens', 'once'));

    % Error handling for day extraction.
    if isempty(inputDay)
        error('Input_FileName does not contain a day segment (e.g., Day4).');
    end

    % Extract MouseID rows only once.
    MouseIDTable = InputTable(strcmp(InputTable.MouseID, MouseID), :);

    % Error handling for no matching rows.
    if isempty(MouseIDTable)
        error('No matching MouseID found in InputTable.');
    end

    % Initialize maxLowerDay to negative infinity.
    maxLowerDay = -inf;
    % Initialize OdourfileNames to empty cell array.
    OdourfileNames = {};

    % Iterate over rows in MouseIDTable.
    for i = 1:size(MouseIDTable, 1)
        fileName = MouseIDTable.FileName{i};
        % If the filename contains 'Odour':
        if contains(fileName, 'Odour')
            % Extract the day from the filename.
            fileDay = str2double(regexp(fileName, 'Day(\d+)', 'tokens', 'once'));
            % If the fileDay is less than the inputDay and greater than or equal to maxLowerDay:
            if fileDay < inputDay && fileDay >= maxLowerDay
                % If fileDay is larger than maxLowerDay, empty OdourfileNames and update maxLowerDay.
                if fileDay > maxLowerDay
                    OdourfileNames = {};
                    maxLowerDay = fileDay;
                end
                % Add the fileName to OdourfileNames.
                OdourfileNames{end+1} = fileName;
            end
        end
    end

    % If no matching day was found, raise an error.
    if isempty(OdourfileNames)
        error('No Day number in the table is smaller than the Day number in Input_FileName.');
    end
end
