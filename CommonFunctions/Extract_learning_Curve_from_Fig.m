clear
addpath('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Code\Basic_Settings')
addpath('C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\CommonFunctions')
startup
close all
Colours
c_odour1 = c_ctg1_green;
c_odour2 = c_ctg2_yellow;
c_odour3 = c_ctg3_purple;
c_odour4 = c_ctg6_orange;
c_odour5 = c_ctg7_brown;
c_odour6 = c_ctg5_pink;
%%
Data_Path = 'C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Group_Analyses\Learning_Curve_Fibre_In';
cd(Data_Path)
ResultPath = Data_Path;
Result_Title = 'Fibre_notOut';
searchPath = [Data_Path ,'\**\*.fig']; % Search in folder and subfolders for  *.mat
FileNames      = dir(searchPath); % Find all .mat files
%%
for l = 1:6
    eval(sprintf('Odour%d_cummulated = {};',l));
end
light_setps = {12,25,50,75,100};
for l = 1:length(light_setps)

    light_intensity = light_setps{l};
    c_map = cbrewer2('Blues', 100);

    c = c_map(round(light_intensity),:);
    eval(sprintf('c_light%d = c;',light_intensity))
    eval(sprintf('Light%d_cummulated = {};',light_intensity));
end
%%
for i = 1:length(FileNames)
    %     figname = strcat(strrep(currD,'_',' '),' learning.fig');
    figname = FileNames(i).name;
    open(figname);
    a = get(gca,'Children');
    xdata = get(a, 'XData');
    ydata = get(a, 'YData');
    cdata = get(a, 'color');
    for l = 1:6
        eval(sprintf('Odour%d_indivial = [];',l));
    end
    light_setps = {12,25,50,75,100};
    for l = 1:length(light_setps)

        light_intensity = light_setps{l};

        eval(sprintf('Light%d_indivial = [];',light_intensity));
    end
    % nans are for ploting the legend. Remove
    for iii = 1:length(ydata)
        iiinverse = length(ydata)-iii+1;
        if isnan(ydata{iiinverse})
        else
            % get trail type from the colour
            cc = cdata{iiinverse};
            for l = 1:6
                eval(sprintf('c_diff = c_odour%d-cc;',l));
                if sum(abs(c_diff))<0.0001
                    eval(sprintf('Odour%d_indivial =[Odour%d_indivial ydata{iiinverse}];',l, l));
                else
                end
            end
            for l = 1:length(light_setps)
                light_intensity = light_setps{l};
                eval(sprintf('c_diff = c_light%d-cc;',light_intensity));
                if sum(abs(c_diff))<0.0001
                    eval(sprintf('Light%d_indivial = [ Light%d_indivial ydata{iiinverse}];',light_intensity, light_intensity));
                else
                end
            end
        end
    end



    close
    for l = 1:6

        eval(sprintf('Odour%d_cummulated{end+1} =Odour%d_indivial;',l, l));

    end

    for l = 1:length(light_setps)
        light_intensity = light_setps{l};

        eval(sprintf('Light%d_cummulated{end+1} = Light%d_indivial;',light_intensity, light_intensity));

    end
end
%% plot the odour part
cumulated_session = 0;
session_interval = 2;
for l = 1:6

    eval(sprintf('a = Odour%d_cummulated;',l));
    maxNumCol = max(cellfun(@(c) size(c,2), a));  % max number of columns
    aMat = cell2mat(cellfun(@(c){padarray(c,[0,maxNumCol-size(c,2)],NaN,'Post')}, a)');
    Dp = mean(aMat,1,'omitnan');

    %     eval(sprintf('Dp = cellfun(@(x)mean(x,"omitnan"),Odour%d_cummulated);',l));
    eval(sprintf('c = c_odour%d;',l));
    Session = 1:length(Dp);
    plot((Session+cumulated_session),Dp,'-o','Color',c,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor',c)
    hold on
    cumulated_session = cumulated_session+ max(Session)+session_interval;
end

for i = 1:6
    eval(sprintf('p%d = plot(NaN, "DisplayName", "Odour %d", "Color", c_odour%d);',i,i,i))
end
legend([p1 p2 p3 p4 p5 p6],'Location', 'bestoutside','NumColumns',1);
title('learning curve for odours')
ylabel('D prime')
ylim([-5 5])
saveimg(gcf,ResultPath,Result_Title,'Odour_group_learning',111)
%% plot the Light part
figure
cumulated_session = 0;
session_interval = 2;
for l = 1:length(light_setps)
    light_intensity = light_setps{l};
    eval(sprintf('a = Light%d_cummulated;',light_intensity));
    maxNumCol = max(cellfun(@(c) size(c,2), a));  % max number of columns
    aMat = cell2mat(cellfun(@(c){padarray(c,[0,maxNumCol-size(c,2)],NaN,'Post')}, a)');
    Dp = mean(aMat,1,'omitnan');

    %     eval(sprintf('Dp = cellfun(@(x)mean(x,"omitnan"),Odour%d_cummulated);',l));
    eval(sprintf('c = c_light%d;',light_intensity));
    Session = 1:length(Dp);
    plot((Session+cumulated_session),Dp,'-o','Color',c,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor',c)
    hold on
    cumulated_session = cumulated_session+ max(Session)+session_interval;
end

for i = 1:length(light_setps)
    light_intensity = light_setps{i};
    eval(sprintf('p%d = plot(NaN, "DisplayName", "Light %dmW", "Color", c_light%d);',light_intensity,light_intensity,light_intensity))
end
ylim([-5 5])
legend([p12 p25 p50 p75 p100],'Location', 'bestoutside','NumColumns',1);
title('learning curve for light')
ylabel('D prime')

saveimg(gcf,ResultPath,Result_Title,'Light_group_learning',111)