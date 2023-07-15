function generateTrainingScheme(schedule)
    % INPUTS:
    % schedule: A MATLAB struct array with fields: 'StimuliName', 'NumSessions', and 'Colour'
    % filename: The name of the output file (including the extension)

    % Create a figure
    figure;

    % Initialize a counter for the current day
    currentDay = 1;

    % Go through the struct array and draw squares
    for i = 1:numel(schedule)
        for j = 1:schedule(i).NumSessions
            rectangle('Position', [currentDay, 0, 1, 1], 'FaceColor', schedule(i).Colour);
            currentDay = currentDay + 1;
        end
    end

    % Set the axis limits
    xlim([0, currentDay]);
    ylim([0, 2]);

    % Make the x and y scales identical
    axis equal;

    % Remove the axis
    axis off;

%     % Save the figure
%     saveas(gcf, filename);
end
