function [fileStruct, SP_structure, SM_structure] = fun_Stim_Struct_2_complex_str(inputStructure0)
% Initialize the output structures
SP_structure = struct();
SM_structure = struct();



lightStructure = rmfield(inputStructure0, setdiff(fieldnames(inputStructure0), {'NumPulse', 'Intensity', 'PulseWidth', 'PulseFrequency', 'DelayLatency', 'ReverseStimuli'}));
fileStruct = rmfield(inputStructure0, {'NumPulse', 'Intensity', 'PulseWidth', 'PulseFrequency', 'DelayLatency', 'ReverseStimuli'});
% Iterate over each field in the input structure
fields = fieldnames(lightStructure);
for i = 1:numel(fields)
    fieldName = fields{i};
    fieldValue = lightStructure.(fieldName);
    if ~isstring(fieldValue)
        fieldValue = num2str(fieldValue);
    end
    % Check if the field value contains 'v' or 'vs'
    if contains(fieldValue, 'v') || contains(fieldValue, 'vs')
        % Split the string and assign the parts to the corresponding output structures
        splitValues = strsplit(fieldValue, {'v', 'vs'});

        SP_structure.(fieldName) = cell2mat(extract(splitValues{1},digitsPattern));
        SM_structure.(fieldName) = cell2mat(extract(splitValues{2},digitsPattern));
    else
        % Assign the value directly to both output structures
        SP_structure.(fieldName) = fieldValue;
        SM_structure.(fieldName) = fieldValue;
    end
end
end