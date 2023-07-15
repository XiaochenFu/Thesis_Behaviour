function generateTrainingSchemeWithName(schedule)
% INPUTS:
% schedule: A MATLAB struct array with fields: 'StimuliName', 'NumSessions', 'Colour', 'NumPulse', and 'Phase'

% Create a figure
figure;

% Initialize a counter for the current day and the current vertical position for the text
currentDay = 1;
currentPos = -1;  % Start a bit lower to avoid overlap

% Go through the struct array and draw squares
for i = 1:numel(schedule)
    % Draw the dashed line and the text
    line([currentDay currentDay], [-2-numel(schedule), 2], 'LineStyle', '--', 'Color', 'k');
    text(currentDay, currentPos, schedule(i).StimuliName, 'HorizontalAlignment', 'left','FontSize',round(100/numel(schedule)));

    % Adjust the vertical position for the next text
    currentPos = currentPos - 0.5;

    % Draw squares for each session
    for j = 1:schedule(i).NumSessions
        rectangle('Position', [currentDay, 0, 1, 1], 'FaceColor', schedule(i).Colour);
        axis equal;
        % Add pattern if NumPulse and Phase are defined
        if isfield(schedule(i), 'NumPulse') && isfield(schedule(i), 'Phase') && ~isempty(schedule(i).NumPulse)
            % Determine the angle based on the Phase
            %                 if strcmp(schedule(i).Phase, 'Early')
            %                     % stripes from upper right to bottom left
            %                     for k = 1:schedule(i).NumPulse
            %                         line([currentDay + (1 - 1/(schedule(i).NumPulse + 1) * k), currentDay], [0, (1 - 1/(schedule(i).NumPulse + 1) * k)], 'Color', 'k', 'LineWidth', 1);
            %                     end
            %                 else  % Assume 'Late'
            %                     % stripes from upper left to bottom right
            %                     for k = 1:schedule(i).NumPulse
            %                         line([currentDay + 1/(schedule(i).NumPulse + 1) * k, 0], [1, currentDay + (1 - 1/(schedule(i).NumPulse + 1) * k)], 'Color', 'k', 'LineWidth', 1);
            %                     end
            %                 end
            A = patch([currentDay currentDay+1 currentDay+1 currentDay], [0 0 1 1], schedule(i).Colour);
            if strcmp(schedule(i).Phase, 'Early')
                hatchfill(A, 'single', -45, 15/schedule(i).NumPulse, schedule(i).Colour);
            elseif strcmp(schedule(i).Phase, 'Late')
                hatchfill(A, 'single', 45, 15/schedule(i).NumPulse, schedule(i).Colour);
            else
                hatchfill(A, 'cross', 45, 15/schedule(i).NumPulse, schedule(i).Colour);
            end

        end

        currentDay = currentDay + 1;
    end
end

% Set the axis limits
xlim([0, currentDay]);
ylim([-numel(schedule)-1, 2]);  % Lower the bottom limit to include the text

% Make the x and y scales identical
axis equal;

% Remove the axis
axis off;
end
