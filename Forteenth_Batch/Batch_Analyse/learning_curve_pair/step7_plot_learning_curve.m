%% setpath
addpath('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Code\Useful_Functions')
addpath('C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Group_Analyses\Summary_Stimuli')

%%
cc
%%
% stimuli list
Stimuli_list = {'Detection_25mW','Phase_Early_25mW','One_Early_25mW','Phase_Late_25mW','One_Late_25mW'};
%%
currentDir = pwd;
% Get the parent directory (one level up)
[parentDir,~,~] = fileparts(currentDir);
% Get the grandparent directory (two levels up)
[Batch_Path,~,~] = fileparts(parentDir);
batchid = 14;
%%   loop for each light stimuli
for si = 1:length(Stimuli_list)
    StimuliName = Stimuli_list{si};
    stimuli_path = fullfile(currentDir,'\Group\',StimuliName);
    [mean_dp1, std_dprimes1, mean_dp2, std_dprimes2] = process_behaviour_info(stimuli_path, stimuli_path, 'k', 'b');
    title(replace(StimuliName,'_',' '))
    saveimg(gcf,stimuli_path, strcat('batch',num2str(batchid)),StimuliName,'111')
    save(fullfile(stimuli_path,strcat(StimuliName,'.mat')),'mean_dp1', 'std_dprimes1', 'mean_dp2', 'std_dprimes2')
end

%%



function [mean_dp1, std_dprimes1, mean_dp2, std_dprimes2] = process_behaviour_info(DirA, DirB, colour1, colour2)
    % Subfolders for different stimuli
    subfolder1 = 'odour';
    subfolder2 = 'light'; % Replace with your actual subfolder name
    
    % Get a list of all .mat files in the subfolders
    filesA = dir(fullfile(DirA, subfolder1, '*.mat'));
    filesB = dir(fullfile(DirB, subfolder2, '*.mat'));
    
    % Process each .mat file in subfolder1
    dprimes1 = {};
    for i = 1:length(filesA)
        dt = load(fullfile(filesA(i).folder, filesA(i).name));
        dprimes1 = [dprimes1 dt.Behaviour_Info_cat];
%         mean_dprimes1 = [mean_dprimes1; mean_dp];
    end
    [mean_dp1, std_dprimes1] = calculate_group_dprimes(dprimes1);

    % Process each .mat file in subfolder2
    dprimes2 = {};
    for i = 1:length(filesB)
        dt = load(fullfile(filesB(i).folder, filesB(i).name));
        dprimes2 = [dprimes2 dt.Behaviour_Info_cat];
%         mean_dprimes1 = [mean_dprimes1; mean_dp];
    end
    [mean_dp2, std_dprimes2] = calculate_group_dprimes(dprimes2);
    
    % Plot the learning curves
    ylim_range = [-5 5];
    plot_learning_curve_pair(mean_dp1, std_dprimes1, mean_dp2, std_dprimes2, colour1, colour2, ylim_range);

end
