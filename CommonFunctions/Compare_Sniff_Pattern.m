% compare the sniff pattern of all mat files in the folder
close all
Data_Path = 'C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Group_Analyses\\Sniff_Fibre_In';
ResultPath = Data_Path;
Result_Title = 'AllMice';
searchPath = [Data_Path ,'\**\*.mat']; % Search in folder and subfolders for  *.mat
FileNames      = dir(searchPath); % Find all .mat files
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
    eval(sprintf('%s_All = [];',vv))

end
for i = 1:length(FileNames)
    FileName = FileNames(i).name;
    load(fullfile(Data_Path, FileName));


    for mmm = 1:length(vv_to_save)
        vv = vv_to_save(mmm);
        eval(sprintf('%s = Extracted_Pattern.%s;',vv,vv))
        eval(sprintf('%s_All = [%s_All, %s];',vv,vv, vv))
    end
end

%% all mice, light v.s.odour
figure('units','normalized','outerposition',[0 0 1 1])
subplot 221
d1 = [FVSniffDurationms_Light_Sp_All FVSniffDurationms_Light_Sm_All]';
d2 = [FVSniffDurationms_Odour_Sp_All FVSniffDurationms_Odour_Sm_All]';
tg1 = 'light';
tg2 = 'odour';
ttest_and_boxplot(d1, d2, tg1, tg2)
xlabel('light v.s. odour')
ylabel('Sniff duration (ms)')
title('Sniff duration when FV opens')


subplot 222
d1 = [FVMIDms_Light_Sp_All FVMIDms_Light_Sm_All]';
d2 = [FVMIDms_Odour_Sp_All FVMIDms_Odour_Sm_All]';
tg1 = 'light';
tg2 = 'odour';
ttest_and_boxplot(d1, d2, tg1, tg2)
xlabel('light v.s. odour')
ylabel('MID (ms)')
title('MID when FV opens')

subplot 223
d1 = [StimulatedSniffDuration_ms_Sp_All StimulatedSniffDuration_ms_Sm_All]';
d2 = [FVSniffDurationms_Odour_Sp_All FVSniffDurationms_Odour_Sm_All]';
tg1 = 'light';
tg2 = 'odour';
ttest_and_boxplot(d1, d2, tg1, tg2)
xlabel('light v.s. odour')
ylabel('Sniff duration (ms)')
title('Sniff duration during stimuli')


subplot 224
d1 = [StimulatedInhDuration_ms_Sp_All StimulatedInhDuration_ms_Sm_All]';
d2 = [FVMIDms_Odour_Sp_All FVMIDms_Odour_Sm_All]';
tg1 = 'light';
tg2 = 'odour';
ttest_and_boxplot(d1, d2, tg1, tg2)
xlabel('light v.s. odour')
ylabel('MID (ms)')
title('MID during stimuli')


saveimg(gcf,ResultPath,Result_Title,'Light_vs_Odour',111)
%% all mice, light S+ v.s. S-

figure('units','normalized','outerposition',[0 0 1 1])
subplot 211
d1 = [FVSniffDurationms_Light_Sp_All]';
d2 = [FVSniffDurationms_Light_Sm_All]';
tg1 = 'S+';
tg2 = 'S-';
ttest_and_boxplot(d1, d2, tg1, tg2)
xlabel('light session')
ylabel('Sniff duration (ms)')
title('Sniff duration when FV opens')


subplot 212
d1 = [FVMIDms_Light_Sp_All]';
d2 = [FVMIDms_Light_Sm_All]';
tg1 = 'S+';
tg2 = 'S-';
ttest_and_boxplot(d1, d2, tg1, tg2)
xlabel('light session')
ylabel('MID (ms)')
title('MID when FV opens')
saveimg(gcf,ResultPath,Result_Title,'Light_Sp_vs_Sm',111)
%% same mosue, odour S+ v.s. S-
figure('units','normalized','outerposition',[0 0 1 1])
subplot 211
d1 = [FVSniffDurationms_Odour_Sp_All]';
d2 = [FVSniffDurationms_Odour_Sm_All]';
tg1 = 'S+';
tg2 = 'S-';
ttest_and_boxplot(d1, d2, tg1, tg2)
xlabel('odour session')
ylabel('Sniff duration (ms)')
title('Sniff duration when FV opens')



subplot 212
d1 = [FVMIDms_Odour_Sp_All]';
d2 = [FVMIDms_Odour_Sm_All]';
tg1 = 'S+';
tg2 = 'S-';
ttest_and_boxplot(d1, d2, tg1, tg2)
xlabel('odour session')
ylabel('MID (ms)')
title('MID when FV opens')

saveimg(gcf,ResultPath,Result_Title,'Odour_Sp_vs_Sm',111)
