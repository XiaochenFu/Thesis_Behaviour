function [structure1, structure2] = Stim_Struct_2_SPSM(inputStructure)
    % Initialize the output structures
    structure1 = struct();
    structure2 = struct();

    % Iterate over each field in the input structure
    fields = fieldnames(inputStructure);
    for i = 1:numel(fields)
        fieldName = fields{i};
        fieldValue = inputStructure.(fieldName);
        if ~isstring(fieldValue)
            fieldValue = num2str(fieldValue);
        end
        % Check if the field value contains 'v' or 'vs'
        if contains(fieldValue, 'v') || contains(fieldValue, 'vs')
            % Split the string and assign the parts to the corresponding output structures
            splitValues = strsplit(fieldValue, {'v', 'vs'});

            structure1.(fieldName) = cell2mat(extract(splitValues{1},digitsPattern));
            structure2.(fieldName) = cell2mat(extract(splitValues{2},digitsPattern));
        else
            % Assign the value directly to both output structures
            structure1.(fieldName) = fieldValue;
            structure2.(fieldName) = fieldValue;
        end
    end
end