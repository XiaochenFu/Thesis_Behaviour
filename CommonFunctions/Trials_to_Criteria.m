% find the number of trails to reach a criterion
function [num_trial_to_criterion] = Trials_to_Criteria(Behaviour_Info_cat,criteria)
% %% load the test data
% 
% cc
% load('C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Group_Analyses\Learning_Curve_Injection_Strain\1spot_cck\BehaviourData_Cat\CCK_168\Odour1.mat')
% 
% criteria.test_method = "dprime";
% criteria.test_threshold = 2.5;
% % criteria.test_method = "accuracy";
% % criteria.test_threshold = 0.8;
% criteria.num_trials_for_test = 40;
% criteria.num_trials_steps = 5;
% % [num_trial_to_criterion] = Trials_to_Criteria(criteria)
%%
Response = extractfield(Behaviour_Info_cat , 'Response');
TrialType = extractfield(Behaviour_Info_cat , 'TrialType');
splus_index = strcmp('SPlus',TrialType);
HIT = strcmp('HIT',Response);
FA = strcmp('FA',Response);
%%
test_method = getOr(criteria, "test_method", "dprime");
num_trials_for_test = getOr(criteria, "num_trials_for_test", 40);
num_trials_steps = getOr(criteria, "num_trials_steps", 10);
switch test_method
    case "accuracy"
        test_threshold = getOr(criteria, "test_threshold", 80);
    case "dprime"
        test_threshold = getOr(criteria, "test_threshold", 2.5);
end
% loop for every x trials
% for each interation, first extract the trials needed
% then, calculate the accuracy or the dprime
% if the value is higher than the threshold, then return the trial index
total_length = length(Behaviour_Info_cat);
window_width = num_trials_for_test;
window_steps = num_trials_steps;

for i = 1:window_steps:(total_length - window_width + 1)
    window_indices = i:(i + window_width - 1);

    s_HIT = sum(HIT(window_indices));
    s_FA = sum(FA(window_indices));
    s_Plus = sum(splus_index(window_indices));
    s_Minus = sum(~splus_index(window_indices));
    switch test_method
        case "accuracy"
            [Overall_Accuracy, ~, ~] = Accuracy_Cal(s_HIT,s_FA, s_Plus, s_Minus);
            if Overall_Accuracy>=test_threshold
                num_trial_to_criterion = (i + window_width - 1);
                break
            end
        case "dprime"
            dP = Dprime_Loglinear_norm50(s_HIT,s_FA, s_Plus, s_Minus);
            if dP>=test_threshold
                num_trial_to_criterion = (i + window_width - 1);
                break
            end
    end
end
if ~exist("num_trial_to_criterion","var")
    num_trial_to_criterion = -total_length;
end


