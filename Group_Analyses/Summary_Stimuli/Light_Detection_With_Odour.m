% 1. Find the mouse with light detection task during odour presentation
% 2. Find the cooresponding light detection task without odour presentaion
clear
clc


% Read the CSV file into a table.
T = readtable('SP_SM_complex_string.csv');

% Return the rows with non-empty values in the field D and non-zero value in field I.
light_odour_rows = T(~ismissing(T.SP_Odour) & T.SP_Intensity ~= 0, :);

%% for each row, find the corresponding task without odour presentation
for i = 1:size(light_odour_rows,1)
    %     find the find the corresponding task
    mouse_ID = light_odour_rows.MouseID(i);
    SP_Intensity = light_odour_rows.SP_Intensity(i);
    light_noodour_rows = T(strcmp(T.MouseID,mouse_ID) & ismissing(T.SP_Odour) & T.SP_Intensity == SP_Intensity, :);
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
