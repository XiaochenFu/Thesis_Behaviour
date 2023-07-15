cc
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
% Data_Path = 'C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Group_Analyses\Learning_Curve_Fibre_In';
Data_Path = 'C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Ninth_Batch\Batch_Analyse\learning_curve';
cd(Data_Path)
ResultPath = 'C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Ninth_Batch\Batch_Analyse\learning_curve_group';
Result_Title = 'Fibre_notOut';
searchPath = [Data_Path ,'\**\*.fig']; % Search in folder and subfolders for  *.mat
FileNames      = dir(searchPath); % Find all .mat files
%%
% odour
for l = 1:6
    eval(sprintf('Odour%d_cummulated = {};',l));
end

% light detection
% light_setps = {12,25,38, 50,75,100};
light_setps = {25,38, 50, 75,100};
for l = 1:length(light_setps)
    light_intensity = light_setps{l};
    c_map = cbrewer2('Blues', 100);
    c_map_replot = cbrewer2('PuBu', 100);
    c = c_map(round(light_intensity),:);
    c_replot = c_map_replot(round(light_intensity),:);
    eval(sprintf('c_light%d = c;',light_intensity))
    eval(sprintf('c_light_replot%d = c_replot;',light_intensity))
    eval(sprintf('Light%d_cummulated = {};',light_intensity));
end

% light phase
light_setps_phase = {38,50};
for l = 1:length(light_setps_phase)
    light_intensity = light_setps_phase{l};
    c_map = cbrewer2('Greys', 100);

    c = c_map(round(light_intensity),:);
    eval(sprintf('c_phase%d = c;',light_intensity))
    eval(sprintf('Phase%d_cummulated = {};',light_intensity));
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

    for l = 1:length(light_setps)
        light_intensity = light_setps{l};
        eval(sprintf('Light%d_indivial = [];',light_intensity));
    end

    for l = 1:length(light_setps_phase)
        light_intensity = light_setps_phase{l};
        eval(sprintf('Phase%d_indivial = [];',light_intensity));
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
            for l = 1:length(light_setps_phase)
                light_intensity = light_setps_phase{l};
                eval(sprintf('c_diff = c_phase%d-cc;',light_intensity));
                if sum(abs(c_diff))<0.0001
                    eval(sprintf('Phase%d_indivial = [ Phase%d_indivial ydata{iiinverse}];',light_intensity, light_intensity));
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

    for l = 1:length(light_setps_phase)
        light_intensity = light_setps_phase{l};
        eval(sprintf('Phase%d_cummulated{end+1} = Phase%d_indivial;',light_intensity, light_intensity));
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
    %     errorbar((Session+cumulated_session),Dp,std(aMat,1,'omitnan'))
    curve1 = Dp + std(aMat,1,'omitnan');
    curve2 =  Dp - std(aMat,1,'omitnan');
    x2 = [(Session+cumulated_session),fliplr((Session+cumulated_session))];
    inBetween = [curve1, fliplr(curve2)];
    fill(x2, inBetween,c, 'FaceAlpha', 0.2,'HandleVisibility','off','LineStyle','none');


    cumulated_session = cumulated_session+ max(Session)+session_interval;
end

for i = 1:6
    eval(sprintf('p%d = plot(NaN, "DisplayName", "Odour %d", "Color", c_odour%d);',i,i,i))
end
legend([p1 p2 p3 p4],'Location', 'bestoutside','NumColumns',1);
title('learning curve for odours')
ylabel('D prime')
box off
xlabel('x10 trials')
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
    eval(sprintf('c_replot = c_light_replot%d;',light_intensity));
    Session = 1:length(Dp);
    plot((Session+cumulated_session),Dp,'-o','Color',c_replot,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor',c_replot)
    hold on
    curve1 = Dp + std(aMat,1,'omitnan');
    curve2 =  Dp - std(aMat,1,'omitnan');
    x2 = [(Session+cumulated_session),fliplr((Session+cumulated_session))];
    inBetween = [curve1, fliplr(curve2)];
    fill(x2, inBetween,c_replot, 'FaceAlpha', 0.2,'HandleVisibility','off','LineStyle','none');
    cumulated_session = cumulated_session+ max(Session)+session_interval;
end

for l = 1:length(light_setps_phase)
    light_intensity = light_setps_phase{l};
    eval(sprintf('a = Phase%d_cummulated;',light_intensity));
    maxNumCol = max(cellfun(@(c) size(c,2), a));  % max number of columns
    aMat = cell2mat(cellfun(@(c){padarray(c,[0,maxNumCol-size(c,2)],NaN,'Post')}, a)');
    Dp = mean(aMat,1,'omitnan');

    %     eval(sprintf('Dp = cellfun(@(x)mean(x,"omitnan"),Odour%d_cummulated);',l));
    eval(sprintf('c = c_phase%d;',light_intensity));
    Session = 1:length(Dp);
    plot((Session+cumulated_session),Dp,'-o','Color',c,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor',c)
    hold on
    curve1 = Dp + std(aMat,1,'omitnan');
    curve2 =  Dp - std(aMat,1,'omitnan');
    x2 = [(Session+cumulated_session),fliplr((Session+cumulated_session))];
    inBetween = [curve1, fliplr(curve2)];
    fill(x2, inBetween,c, 'FaceAlpha', 0.2,'HandleVisibility','off','LineStyle','none');
    cumulated_session = cumulated_session+ max(Session)+session_interval;
end


for i = 1:length(light_setps)
    light_intensity = light_setps{i};
    eval(sprintf('p%d = plot(NaN, "DisplayName", "Light %dmW", "Color", c_light%d);',light_intensity,light_intensity,light_intensity))
end
ylim([-5 5])
%%
for i = 1:length(light_setps_phase)
light_intensity = light_setps_phase{i};
c_map = cbrewer2('Greys', 100);
c = c_map(round(light_intensity),:);
eval(sprintf('c_phase%d = c;',light_intensity))
eval(sprintf('p%d00 = plot(NaN, "DisplayName", "Light %dmW", "Color", c_light%d);',light_intensity,light_intensity,light_intensity))
% p3800 = plot(NaN, "DisplayName", "Phase 38mW", "Color", c_phase38);
end
%%
legend([p25 p38 p50 p75 p100 p3800 p5000],'Location', 'bestoutside','NumColumns',1);
title('learning curve for light')
ylabel('D prime')

xlabel('x10 trials')
box off
saveimg(gcf,ResultPath,Result_Title,'Light_group_learning',111)