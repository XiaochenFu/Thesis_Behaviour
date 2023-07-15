% Compare the sniff pattern

% Use the following parameters
% 1. MID when FV on or when light is on
% 2. Sniff duration when FV on or when light is on
% 3. MID only
% 4. Sniff duration only

% compare:
% same mouse, change with session, different colour for odour and light
% same mouse, light v.s.odour
% same mouse, light S+ v.s. S-
% same mosue, odour S+ v.s. S-

% For each day, load stimuli data and Behaviour data
% Calculate the mean and std of the 4 parameters, all trials, S+, S-
% Use 4 arrays to put 4 parameters, all trials



%% Environment

%% OIST laptop
addpath('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Code\Basic_Settings')
addpath('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Code\Useful_Functions')
addpath('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Code\Useful_Functions\Sniff')
addpath(genpath('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\spikes-master'));
startup
Colours
%% Set Path

mydir  = pwd;
idcs   = strfind(mydir,'\');
newdir = mydir(1:idcs(end)-1);
StimuliDataPath = fullfile(newdir,'Sniff_Analysis');
BehaviourDataPath = fullfile(newdir,'Behaviour_Accuracy');
ResultPath = fullfile(newdir,'Sniff_Analysis');
DataPath = fullfile(newdir,'Recording');
Result_Title = mydir(idcs(end-1)+1:idcs(end)-1)
%% Array for saving result
FVMIDms_all_sessions = [];
FVSniffDurationms_all_sessions = [];
StimulatedInhDuration_ms_all_sessions = [];
StimulatedSniffDuration_ms_all_sessions = [];

FVMIDms_Odour_Sp = [];
FVMIDms_Odour_Sm = [];
FVSniffDurationms_Odour_Sp = [];
FVSniffDurationms_Odour_Sm = [];

FVMIDms_Light_Sp = [];
FVMIDms_Light_Sm = [];
FVSniffDurationms_Light_Sp = [];
FVSniffDurationms_Light_Sm = [];

StimulatedInhDuration_ms_Sp = [];
StimulatedInhDuration_ms_Sm = [];
StimulatedSniffDuration_ms_Sp = [];
StimulatedSniffDuration_ms_Sm = [];

odour_session_idx = [];
light_session_idx = [];

%%
searchPath = [DataPath ,'\**\*.csv']; % Search in folder and subfolders for  *.csv
FileNames      = dir(searchPath); % Find all .csv files
for i = 1:length(FileNames)
    FileName = FileNames(i).name;
    if ~contains(FileName,'Day')
    else
        close all
        %         clearvars -except showplot mydir idcs newdir DataPath BehaviourDataPath StimuliDataPath ResultPath searchPath FileNames FileName i Result_Title...
        %             FVMIDms_all_sessions ...
        %             FVSniffDurationms_all_sessions ...
        %             StimulatedInhDuration_ms_all_sessions ...
        %             StimulatedSniffDuration_ms_all_sessions ...
        %             FVMIDms_Odour_Sp ...
        %             FVMIDms_Odour_Sm ...
        %             FVSniffDurationms_Odour_Sp ...
        %             FVSniffDurationms_Odour_Sm ...
        %             FVMIDms_Light_Sp ...
        %             FVMIDms_Light_Sm ...
        %             FVSniffDurationms_Light_Sp ...
        %             FVSniffDurationms_Light_Sm ...
        %             StimulatedInhDuration_ms_Sp ...
        %             StimulatedInhDuration_ms_Sm ...
        %             StimulatedSniffDuration_ms_Sp ...
        %             StimulatedSniffDuration_ms_Sm...
        %             odour_session_idx...
        %             light_session_idx
        startup
        Colours
        idcs   = strfind(FileName,'_');
        Training_Date = FileName((idcs(1)-2):(idcs(1)-1));  % The number of training day is the part after the first unserscore
        Training_Date =  erase( Training_Date , 'y' );
        Training_Date_idx = round(str2num(Training_Date));
        Stimuli0 = FileName(idcs(1)+1:idcs(2)-1);   % The stimuli is the part after the first unserscore
        % for odour, we don't need to check the light command (and there should be no command if we run the dummy.vi)
        if contains(Stimuli0,'Odour')
            Stimuli_Type = 'Odour';
            Stimuli = Stimuli0;
        else
            Stimuli_Type = 'Light';
            if contains(FileName,'vs0')|| contains(FileName,'v0')
                Stimuli = 'Detection';% should be odour pair or light(Light detection intensity wi/wo odour, Light discrimination wi/wo odour)
            else
                Stimuli = 'Discrimination';
            end
            if contains(FileName,'mW')
                idcs   = strfind(FileName,'mW');
                Stimuli = [Stimuli FileName(idcs(1)-3:idcs(1)+1)];
                Stimuli =  erase( Stimuli , '_' );
            else
                Stimuli =  'noLight';
            end
            if contains(FileName,'MV')
                Stimuli =  strcat(Stimuli, 'MV');
            end
            if contains(FileName,'MT')
                Stimuli =  strcat(Stimuli, 'MT');
            end
        end
        Result_Title0 = sprintf('Day%s_%s',Training_Date, Stimuli)

        %% for a defined day, load the data
        % get file name from recording filename
        % load stimuli
        DataFile = [Result_Title0,'.mat'];
        load(fullfile(StimuliDataPath,DataFile))

        % load the behaviour data
        DataFile = [Result_Title0,'_BehaviourResult.mat'];
        load(fullfile(BehaviourDataPath,DataFile))
        %% Get TrialType
        TrialType = extractfield(Behaviour_Info,'TrialType');
        Sp_idx = strcmp(TrialType,'SPlus');
        Sm_idx = ~Sp_idx;
        %% for all sessions, get parameter 1 & 2
        FVMIDms = extractfield(Stimuli_Info,'FVMIDms');
        FVSniffDurationms = extractfield(Stimuli_Info,'FVSniffDurationms');
        FVMIDms_all_sessions(1,Training_Date_idx) = mean(FVMIDms,'omitnan');
        FVMIDms_all_sessions(2,Training_Date_idx) = std(FVMIDms,'omitnan');
        FVSniffDurationms_all_sessions(1,Training_Date_idx) = mean(FVSniffDurationms,'omitnan');
        FVSniffDurationms_all_sessions(2,Training_Date_idx) = std(FVSniffDurationms,'omitnan');

        %%
        if contains(Stimuli_Type,'Light') % for light session
            if contains(Stimuli_Type,'noLight') %exclude session without light
            else

                % convert [] to nan to avoid error
                for FF = 1:length(Stimuli_Info)
                    if isempty(Stimuli_Info(FF).StimulatedInhDuration_ms)
                        Stimuli_Info(FF).StimulatedInhDuration_ms = nan;
                        Stimuli_Info(FF).StimulatedSniffDuration_ms = nan;

                    end
                    if isempty(Stimuli_Info(FF).StimulatedInhDuration_ms)
                        Stimuli_Info(FF).StimulatedInhDuration_ms = nan;
                        Stimuli_Info(FF).StimulatedSniffDuration_ms = nan;

                    end
                end

                StimulatedInhDuration_ms = extractfield(Stimuli_Info,'StimulatedInhDuration_ms');
                StimulatedSniffDuration_ms = extractfield(Stimuli_Info,'StimulatedSniffDuration_ms');


                StimulatedInhDuration_ms_all_sessions(1,Training_Date_idx) = mean(StimulatedInhDuration_ms,'omitnan');
                StimulatedInhDuration_ms_all_sessions(2,Training_Date_idx) = std(StimulatedInhDuration_ms,'omitnan');
                StimulatedSniffDuration_ms_all_sessions(1,Training_Date_idx) = mean(StimulatedSniffDuration_ms,'omitnan');
                StimulatedSniffDuration_ms_all_sessions(2,Training_Date_idx) = std(StimulatedSniffDuration_ms,'omitnan');
                % trials put together
                FVMIDms_Light_Sp = cat(2,FVMIDms_Light_Sp,FVMIDms(Sp_idx));
                FVMIDms_Light_Sm = cat(2,FVMIDms_Light_Sm,FVMIDms(Sm_idx));
                FVSniffDurationms_Light_Sp = cat(2,FVSniffDurationms_Light_Sp,FVSniffDurationms(Sp_idx));
                FVSniffDurationms_Light_Sm = cat(2,FVSniffDurationms_Light_Sm,FVSniffDurationms(Sm_idx));

                StimulatedInhDuration_ms_Sp = cat(2,StimulatedInhDuration_ms_Sp,StimulatedInhDuration_ms(Sp_idx));
                StimulatedInhDuration_ms_Sm = cat(2,StimulatedInhDuration_ms_Sm,StimulatedInhDuration_ms(Sm_idx));
                StimulatedSniffDuration_ms_Sp = cat(2,StimulatedSniffDuration_ms_Sp,StimulatedSniffDuration_ms(Sp_idx));
                StimulatedSniffDuration_ms_Sm = cat(2,StimulatedSniffDuration_ms_Sm,StimulatedSniffDuration_ms(Sm_idx));
                light_session_idx(Training_Date_idx) = Training_Date_idx;
            end
        else
            odour_session_idx(Training_Date_idx) = Training_Date_idx;
            FVMIDms_Odour_Sp = cat(2,FVMIDms_Odour_Sp,FVMIDms(Sp_idx));
            FVMIDms_Odour_Sm = cat(2,FVMIDms_Odour_Sm,FVMIDms(Sm_idx));
            FVSniffDurationms_Odour_Sp = cat(2,FVSniffDurationms_Odour_Sp,FVSniffDurationms(Sp_idx));
            FVSniffDurationms_Odour_Sm = cat(2,FVSniffDurationms_Odour_Sm,FVSniffDurationms(Sm_idx));



        end
    end
end
if length(light_session_idx) ==length(FVMIDms_all_sessions)
else
    light_session_idx(length(FVMIDms_all_sessions)) = nan;
end
light_session_idx(light_session_idx==0) = nan;

if length(odour_session_idx) ==length(FVMIDms_all_sessions)
else
    odour_session_idx(length(FVMIDms_all_sessions)) = nan;
end
odour_session_idx(odour_session_idx==0) = nan;

if length(StimulatedInhDuration_ms_all_sessions) ==length(FVMIDms_all_sessions)
else
    StimulatedInhDuration_ms_all_sessions(2, ...
        length(FVMIDms_all_sessions)) = nan;
end
StimulatedInhDuration_ms_all_sessions(StimulatedInhDuration_ms_all_sessions==0) = nan;

if length(StimulatedSniffDuration_ms_all_sessions) ==length(FVMIDms_all_sessions)
else
    StimulatedSniffDuration_ms_all_sessions(2,length(FVMIDms_all_sessions)) = nan;
end
StimulatedSniffDuration_ms_all_sessions(StimulatedSniffDuration_ms_all_sessions==0) = nan;
% %% same mouse, change with session, different colour for odour and light
%
% figure
% errorbar(light_session_idx,FVMIDms_all_sessions(1,:),FVMIDms_all_sessions(2,:),'LineStyle','none','Color', 'g')
% hold on
% errorbar(odour_session_idx,FVMIDms_all_sessions(1,:),FVMIDms_all_sessions(2,:),'LineStyle','none','Color', 'r')
% x = 1:length(FVMIDms_all_sessions);
% y = FVMIDms_all_sessions(1,:);
% plot(x,y,'k')
% xlabel('session')
% ylabel('MID (ms)')
% title('MID when FV opens')
% legend('light session','odour session')
% saveimg(gcf,ResultPath,Result_Title,'FVMID',1)
%
% figure
% errorbar(light_session_idx,FVSniffDurationms_all_sessions(1,:),FVSniffDurationms_all_sessions(2,:),'LineStyle','none','Color', 'g')
% hold on
% errorbar(odour_session_idx,FVSniffDurationms_all_sessions(1,:),FVSniffDurationms_all_sessions(2,:),'LineStyle','none','Color', 'r')
% x = 1:length(FVSniffDurationms_all_sessions);
% y = FVSniffDurationms_all_sessions(1,:);
% plot(x,y,'k')
% xlabel('session')
% ylabel('Sniff duration (ms)')
% title('Sniff duration when FV opens')
% legend('light session','odour session')
% saveimg(gcf,ResultPath,Result_Title,'FVSniff',1)
%%
% figure
% errorbar(light_session_idx,StimulatedInhDuration_ms_all_sessions(1,:),StimulatedInhDuration_ms_all_sessions(2,:),'LineStyle','none','Color', 'g')
% hold on
% errorbar(odour_session_idx,FVMIDms_all_sessions(1,:),FVMIDms_all_sessions(2,:),'LineStyle','none','Color', 'r')
% x = 1:length(FVMIDms_all_sessions);
% y = FVMIDms_all_sessions(1,:);
% y(isnan (odour_session_idx)) = StimulatedInhDuration_ms_all_sessions(1,isnan (odour_session_idx));
% plot(x,y,'k')
% xlabel('session')
% ylabel('MID (ms)')
% title('MID during stimuli')
% legend('light session','odour session')
% saveimg(gcf,ResultPath,Result_Title,'StimulatedMID',1)
%
% figure
% errorbar(light_session_idx,StimulatedSniffDuration_ms_all_sessions(1,:),StimulatedSniffDuration_ms_all_sessions(2,:),'LineStyle','none','Color', 'g')
% hold on
% errorbar(odour_session_idx,FVSniffDurationms_all_sessions(1,:),FVSniffDurationms_all_sessions(2,:),'LineStyle','none','Color', 'r')
% x = 1:length(FVSniffDurationms_all_sessions);
% y = FVSniffDurationms_all_sessions(1,:);
% y(isnan (odour_session_idx)) = StimulatedSniffDuration_ms_all_sessions(1,isnan (odour_session_idx));
% plot(x,y,'k')
% xlabel('session')
% ylabel('Sniff duration (ms)')
% title('Sniff duration during stimuli')
% legend('light session','odour session')
% saveimg(gcf,ResultPath,Result_Title,'StimulatedSniff',1)
% %% same mouse, light v.s.odour
% figure('units','normalized','outerposition',[0 0 1 1])
% subplot 221
% d1 = [FVSniffDurationms_Light_Sp FVSniffDurationms_Light_Sm]';
% d2 = [FVSniffDurationms_Odour_Sp FVSniffDurationms_Odour_Sm]';
% group = [repmat({'light'},size(d1));
%          repmat({'odour'},size(d2))];
% % group = [    ones(size(abs_single));
% %          2 * ones(size(abs_group))];
% boxplot([d1; d2],group)
% xlabel('light v.s. odour')
% ylabel('Sniff duration (ms)')
% title('Sniff duration when FV opens')
%
% yt = get(gca, 'YTick');
% axis([xlim    0  ceil(max(yt)*1.2)])
% xt = get(gca, 'XTick');
% hold on
% plot(xt([1 2]), [1 1]*max(yt)*1.1, '-k',  mean(xt([1 2])), max(yt)*0.9, 'k')
% tttt = ttest2(d1,d2)
% if tttt
%     text(1.5, max(yt)*0.9, '*')
% else
%     text(1.5, max(yt)*0.9, 'n.s.')
% end
% hold off
%
% subplot 222
% d1 = [FVMIDms_Light_Sp FVMIDms_Light_Sm]';
% d2 = [FVMIDms_Odour_Sp FVMIDms_Odour_Sm]';
% group = [repmat({'light'},size(d1));
%          repmat({'odour'},size(d2))];
% % group = [    ones(size(abs_single));
% %          2 * ones(size(abs_group))];
% boxplot([d1; d2],group)
% xlabel('light v.s. odour')
% ylabel('MID (ms)')
% title('MID when FV opens')
%
% yt = get(gca, 'YTick');
% axis([xlim    0  ceil(max(yt)*1.2)])
% xt = get(gca, 'XTick');
% hold on
% plot(xt([1 2]), [1 1]*max(yt)*1.1, '-k',  mean(xt([1 2])), max(yt)*0.9, 'k')
% tttt = ttest2(d1,d2)
% if tttt
%     text(1.5, max(yt)*0.9, '*')
% else
%     text(1.5, max(yt)*0.9, 'n.s.')
% end
% hold off
%
% subplot 223
% d1 = [StimulatedSniffDuration_ms_Sp StimulatedSniffDuration_ms_Sm]';
% d2 = [FVSniffDurationms_Odour_Sp FVSniffDurationms_Odour_Sm]';
% group = [repmat({'light'},size(d1));
%          repmat({'odour'},size(d2))];
% boxplot([d1; d2],group)
% xlabel('light v.s. odour')
% ylabel('Sniff duration (ms)')
% title('Sniff duration during stimuli')
%
% yt = get(gca, 'YTick');
% axis([xlim    0  ceil(max(yt)*1.2)])
% xt = get(gca, 'XTick');
% hold on
% plot(xt([1 2]), [1 1]*max(yt)*1.1, '-k',  mean(xt([1 2])), max(yt)*0.9, 'k')
% tttt = ttest2(d1,d2)
% if tttt
%     text(1.5, max(yt)*0.9, '*')
% else
%     text(1.5, max(yt)*0.9, 'n.s.')
% end
% hold off
%
% subplot 224
% d1 = [StimulatedInhDuration_ms_Sp StimulatedInhDuration_ms_Sm]';
% d2 = [FVMIDms_Odour_Sp FVMIDms_Odour_Sm]';
% group = [repmat({'light'},size(d1));
%          repmat({'odour'},size(d2))];
% boxplot([d1; d2],group)
% xlabel('light v.s. odour')
% ylabel('MID (ms)')
% title('MID during stimuli')
%
% yt = get(gca, 'YTick');
% axis([xlim    0  ceil(max(yt)*1.2)])
% xt = get(gca, 'XTick');
% hold on
% plot(xt([1 2]), [1 1]*max(yt)*1.1, '-k',  mean(xt([1 2])), max(yt)*0.9, 'k')
% tttt = ttest2(d1,d2)
% if tttt
%     text(1.5, max(yt)*0.9, '*')
% else
%     text(1.5, max(yt)*0.9, 'n.s.')
% end
% hold off
%
% saveimg(gcf,ResultPath,Result_Title,'Light_vs_Odour',1)
% %% same mouse, light S+ v.s. S-
%
% figure('units','normalized','outerposition',[0 0 1 1])
% subplot 211
% d1 = [FVSniffDurationms_Light_Sp ]';
% d2 = [FVSniffDurationms_Light_Sm]';
% group = [repmat({'S+'},size(d1));
%          repmat({'S-'},size(d2))];
% % group = [    ones(size(abs_single));
% %          2 * ones(size(abs_group))];
% boxplot([d1; d2],group)
% xlabel('light session')
% ylabel('Sniff duration (ms)')
% title('Sniff duration when FV opens')
%
% yt = get(gca, 'YTick');
% axis([xlim    0  ceil(max(yt)*1.2)])
% xt = get(gca, 'XTick');
% hold on
% plot(xt([1 2]), [1 1]*max(yt)*1.1, '-k',  mean(xt([1 2])), max(yt)*0.9, 'k')
% tttt = ttest2(d1,d2)
% if tttt
%     text(1.5, max(yt)*0.9, '*')
% else
%     text(1.5, max(yt)*0.9, 'n.s.')
% end
% hold off
%
% subplot 212
% d1 = [FVMIDms_Light_Sp ]';
% d2 = [FVMIDms_Light_Sm ]';
% group = [repmat({'S+'},size(d1));
%          repmat({'S-'},size(d2))];
% % group = [    ones(size(abs_single));
% %          2 * ones(size(abs_group))];
% boxplot([d1; d2],group)
% xlabel('light session')
% ylabel('MID (ms)')
% title('MID when FV opens')
%
% yt = get(gca, 'YTick');
% axis([xlim    0  ceil(max(yt)*1.2)])
% xt = get(gca, 'XTick');
% hold on
% plot(xt([1 2]), [1 1]*max(yt)*1.1, '-k',  mean(xt([1 2])), max(yt)*0.9, 'k')
% tttt = ttest2(d1,d2)
% if tttt
%     text(1.5, max(yt)*0.9, '*')
% else
%     text(1.5, max(yt)*0.9, 'n.s.')
% end
% hold off
%
%
%
% saveimg(gcf,ResultPath,Result_Title,'Light_Sp_vs_Sm',1)
% %% same mosue, odour S+ v.s. S-
% figure('units','normalized','outerposition',[0 0 1 1])
% subplot 211
% d1 = [FVSniffDurationms_Odour_Sp ]';
% d2 = [FVSniffDurationms_Odour_Sm]';
% group = [repmat({'S+'},size(d1));
%          repmat({'S-'},size(d2))];
% % group = [    ones(size(abs_single));
% %          2 * ones(size(abs_group))];
% boxplot([d1; d2],group)
% xlabel('odour session')
% ylabel('Sniff duration (ms)')
% title('Sniff duration when FV opens')
%
% yt = get(gca, 'YTick');
% axis([xlim    0  ceil(max(yt)*1.2)])
% xt = get(gca, 'XTick');
% hold on
% plot(xt([1 2]), [1 1]*max(yt)*1.1, '-k',  mean(xt([1 2])), max(yt)*0.9, 'k')
% tttt = ttest2(d1,d2)
% if tttt
%     text(1.5, max(yt)*0.9, '*')
% else
%     text(1.5, max(yt)*0.9, 'n.s.')
% end
% hold off
%
% subplot 212
% d1 = [FVMIDms_Odour_Sp ]';
% d2 = [FVMIDms_Odour_Sm ]';
% group = [repmat({'S+'},size(d1));
%          repmat({'S-'},size(d2))];
% % group = [    ones(size(abs_single));
% %          2 * ones(size(abs_group))];
% boxplot([d1; d2],group)
% xlabel('odour session')
% ylabel('MID (ms)')
% title('MID when FV opens')
%
% yt = get(gca, 'YTick');
% axis([xlim    0  ceil(max(yt)*1.2)])
% xt = get(gca, 'XTick');
% hold on
% plot(xt([1 2]), [1 1]*max(yt)*1.1, '-k',  mean(xt([1 2])), max(yt)*0.9, 'k')
% tttt = ttest2(d1,d2)
% if tttt
%     text(1.5, max(yt)*0.9, '*')
% else
%     text(1.5, max(yt)*0.9, 'n.s.')
% end
% hold off
%
%
%
% saveimg(gcf,ResultPath,Result_Title,'Odour_Sp_vs_Sm',1)
%

vv_to_save = ["FVMIDms_Odour_Sp",...
    "FVMIDms_Odour_Sm",...
    "FVSniffDurationms_Odour_Sp",...
    "FVSniffDurationms_Odour_Sm",...
    "FVMIDms_Light_Sp",...
    "FVMIDms_Light_Sm",...
    "FVSniffDurationms_Light_Sp",...
    "FVSniffDurationms_Light_Sm",...
    "StimulatedInhDuration_ms_Sp",...
    "StimulatedInhDuration_ms_Sm",...
    "StimulatedSniffDuration_ms_Sp",...
    "StimulatedSniffDuration_ms_Sm"...
    ];

for mmm = 1:length(vv_to_save)
    vv = vv_to_save(mmm);
    eval(sprintf('Extracted_Pattern.%s = mean(%s,"omitnan");',vv,vv))
end

cd(home_path)
save(sprintf('%s.mat',currD),'Extracted_Pattern')

















