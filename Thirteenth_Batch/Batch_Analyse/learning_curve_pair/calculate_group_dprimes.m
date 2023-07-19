% Function to calculate dprime
function [mean_dprimes, std_dprimes] = calculate_group_dprimes(Behaviour_Infos)
n_inputs = length(Behaviour_Infos);
% mean_dprimes = zeros(1, n_inputs);
% std_dprimes = zeros(1, n_inputs);

dprime_all = {};
for j = 1:n_inputs
    Behaviour_Info = Behaviour_Infos{j};

    if ~isempty(Behaviour_Info)
        % Define the labels for the signal and noise stimuli
        signal_label = 'HIT';
        noise_label = 'FA';

        % Extract the Behaviour_Info_cat labels from the Behaviour_Info structure
        labels = {Behaviour_Info.Response};


        % Calculate the hit and false alarm counts for each window
        hit_idx = strcmp(labels, signal_label);
        miss_idx = strcmp(labels, 'MISS');
        fa_idx = strcmp(labels, noise_label);
        cr_idx = strcmp(labels, 'CR');



        % Calculate the dprime for every window_size trials
        total_length = length(labels);
        window_steps = 5;
        window_width = 20;
        n_windows = length(1:window_steps:(total_length - window_width + 1));
        dprimes = zeros(1,n_windows);
        Session = 1:window_steps:(total_length - window_width + 1);
        k = 1;
        for i = 1:window_steps:(total_length - window_width + 1)
            window_indices = i:(i + window_width - 1);
            n_hit = sum(hit_idx(window_indices));
            n_miss = sum(miss_idx(window_indices));
            n_fa = sum(fa_idx(window_indices));
            n_cr = sum(cr_idx(window_indices));
            n_splus = n_hit + n_miss;
            n_sminus = n_fa + n_cr;
            dprimes(k) = Dprime_Loglinear_norm50(n_hit, n_fa, n_splus, n_sminus);
            k = k+1;
        end

    end
    %     % Store mean and std dprime for current Behaviour_Info_cat
    %     mean_dprimes(j) = mean(dprimes);
    %     std_dprimes(j) = std(dprimes);
    dprime_all = [dprime_all dprimes];

end


maxNumCol = max(cellfun(@(c) size(c,2), dprime_all));  % max number of columns
aMat = cell2mat(cellfun(@(c){padarray(c,[0,maxNumCol-size(c,2)],NaN,'Post')}, dprime_all)');
mean_dprimes = mean(aMat,1,'omitnan');
std_dprimes =  std(aMat,1,'omitnan');
if length(std_dprimes) ==1
    std_dprimes = 0;
end
end