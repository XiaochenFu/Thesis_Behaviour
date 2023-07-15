% 1. Find the mouse with long light pulse train 
% 2. Find the cooresponding light detection task with short pulse train
clear
clc


% Read the CSV file into a table.
T = readtable('SP_SM_complex_string.csv');

% Return the rows with more than 5 in the field D and non-zero value in field I.
light_long = T(ismissing(T.SP_Odour) & T.SP_NumPulse >8, :);

%% for each row, find the corresponding task without odour presentation
for i = 1:size(light_long,1)
    %     find the find the corresponding task
    mouse_ID = light_long.MouseID(i);
    SP_Intensity = light_long.SP_Intensity(i);
    light_short_rows = T(strcmp(T.MouseID,mouse_ID) & ismissing(T.SP_Odour) & T.SP_Intensity == SP_Intensity & T.SP_NumPulse <=8 &T.SM_NumPulse ==0, :)
    % compare the accuracy and the sniff pattern wi/wo odour
end
%%
% % Find rows with the same value in field I but different value in field D compared to the first row
%   % Get the value of field I from the first row
% 
% matchingRows = filteredData(ismember(filteredData.D, differentD) & filteredData.I == sameI, :);
% 
% % Display the matching rows
% disp(matchingRows);
