% Function to plot learning curves pairs
function plot_learning_curve_pair(mean_dprimes1, std_dprimes1, mean_dprimes2, std_dprimes2, colour1, colour2, ylim_range)
    % Create a figure
    figure;
    hold on;

    % Create an offset for the x-axis
    offset = length(mean_dprimes1) + 5; % Adjust as necessary to bring the curves closer together

    % Plot the first learning curve with std as shade
    x1 = 1:length(mean_dprimes1);
    y1 = mean_dprimes1;
    y1_std = std_dprimes1;
    fill([x1 fliplr(x1)], [y1+y1_std fliplr(y1-y1_std)], colour1, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    p1 = plot(x1, y1, 'Color', colour1, 'LineWidth', 2);

    % Plot the second learning curve with std as shade
    x2 = offset+(1:length(mean_dprimes2));
    y2 = mean_dprimes2;
    y2_std = std_dprimes2;
    fill([x2 fliplr(x2)], [y2+y2_std fliplr(y2-y2_std)], colour2, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    p2 = plot(x2, y2, 'Color', colour2, 'LineWidth', 2);
    
    % Configure plot
%     xlabel('Number of Trials'); % Set x-label
    ylabel('Mean dprime'); % Set y-label
%     title('Learning Curve for Stimulus 1 and 2'); % Set title
    ylim(ylim_range); % Set y-axis limits
    xlim([0, max(x2) + 30]); % Set x-axis limits to include a small margin after the second curve
    box off; % Remove box

        % yline
    yline(2.5,'--')

    % Add scale bars
%     plot([offset; offset], [ylim_range(1)+10; ylim_range(1)+20], '-k', 'LineWidth', 2); % y-scale bar
    plot([max(x2); max(x2)+10], [ylim_range(1); ylim_range(1)], '-k', 'LineWidth', 2); % x-scale bar

    % Add scale bar labels
%     text(offset-1, ylim_range(1)+15, '10 Units', 'HorizontalAlignment', 'right'); % y-scale bar label
    text(max(x2)+10, 3, "d' = 2.5", 'HorizontalAlignment', 'center'); % x-scale bar label
text(max(x2)+5, ylim_range(1)+1, '50 Trials', 'HorizontalAlignment', 'center'); % x-scale bar label
    ax = gca;
    ax.XAxisLocation = 'origin';

    % Legend
    legend([p1 p2], {'odour', 'Light'});



%     hold off;
    set(gca,'xtick',[])
end
