% mouse_list
% stimuli list

% Loop for each mouse
%   loop for each light stimuli
%       change the stimuli name to restrictions
%       find the filename in the 'recording' folder based on the restriction
%       find the filename in the buckets based on the filename in the 'recording'
%       find the name of the .mat files in the preprocessed folder

%       find the odour stimuli before the light stimuli
%       change the stimuli name to restrictions
%       find the filename in the 'recording' folder based on the restriction
%       find the filename in the buckets based on the filename in the 'recording'
%       find the name of the .mat files in the preprocessed folder

%% setpath
addpath('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Code\Useful_Functions')
addpath('C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Group_Analyses\Summary_Stimuli')

%%
cc
%%

BatchID = 13;
% mouse_list
Mouse_list = {'TbxAi32_71','TbxAi32_72','TbxAi32_76','TbxAi32_77'};
% stimuli list
Stimuli_list = {'Detection_25mW','Phase_Early_25mW','One_Early_25mW','Phase_Late_25mW','One_Late_25mW','1v3_25mW','3v1_25mW'};
buckets_path = '\\bucket.oist.jp\bucket\FukunagaU\Xiaochen\Records';

%% read the filenames
T0 = readtable('SP_SM_complex_string_Batch13.csv');
T = table2struct(T0);
%%
currentDir = pwd;
% Get the parent directory (one level up)
[parentDir,~,~] = fileparts(currentDir);
% Get the grandparent directory (two levels up)
[Batch_Path,~,~] = fileparts(parentDir);
%%
% Loop for each mouse
for mi = 1:length(Mouse_list)
    MouseID = Mouse_list{mi};

    %   loop for each light stimuli
    for si = 1:length(Stimuli_list)
        StimuliName = Stimuli_list{si};

        Light_Stim_Raw_FileName = {};
        Light_Preprecessed_Mat_FileName = {};
        Odour_Stim_Raw_FileName = {};
        Odour_Preprecessed_Mat_FileName = {};
        
        %       change the stimuli name to restrictions
        StimuliInfo0 = fun_StimuliName_2_StimuliInfo(StimuliName, BatchID);
        T_stim = struct2table(StimuliInfo0);
        S.MouseID = MouseID;
        T_animal = struct2table(S);

        % to avoid the trouble converting string to number, write the table it
        writetable( [T_animal, T_stim],'tabletemp.csv');
        StimuliInfo = readtable('tabletemp.csv');
        StimuliInfo = table2struct(StimuliInfo);
        %       find the filename in the 'recording' folder based on the restriction
        A_sub = filter_matching_rows(T , StimuliInfo);
        if ~isempty(A_sub)
            for lfi = 1:length(A_sub)
                %       find the filename in the buckets based on the filename in the 'recording'
                fileList = find_raw_csv_files(fullfile(buckets_path,MouseID), A_sub(lfi).FileName);
                Light_Stim_Raw_FileName = [Light_Stim_Raw_FileName; fileList];
                %       find the name of the .mat files in the preprocessed folder
                matchedFiles = find_mat_date(fullfile(Batch_Path,MouseID,'Behaviour_Accuracy'),  A_sub(lfi).FileName);
                Light_Preprecessed_Mat_FileName = [Light_Preprecessed_Mat_FileName; matchedFiles];
            end


            %       find the filename in the 'recording' folder
            OdourfileName = find_odour_before_stim(MouseID, A_sub(lfi).FileName, T0)
            %       find the odour stimuli before the light stimuli (maybe not)


            for lfi = 1:length(OdourfileName)
                %       find the filename in the buckets based on the filename in the 'recording'
                fileList = find_raw_csv_files(fullfile(buckets_path,MouseID), OdourfileName{lfi});
                Odour_Stim_Raw_FileName = [Odour_Stim_Raw_FileName; fileList];
                %       find the name of the .mat files in the preprocessed folder
                matchedFiles = find_mat_date(fullfile(Batch_Path,MouseID,'Behaviour_Accuracy'),  OdourfileName{lfi});
                Odour_Preprecessed_Mat_FileName = [Odour_Preprecessed_Mat_FileName; matchedFiles];
            end
            result_path = fullfile(currentDir,MouseID,'FileName');
            mkdir(result_path)
            save(fullfile(result_path, strcat(StimuliName, '.mat')), 'Light_Stim_Raw_FileName','Light_Preprecessed_Mat_FileName','Odour_Stim_Raw_FileName','Odour_Preprecessed_Mat_FileName')
        end
    end
end