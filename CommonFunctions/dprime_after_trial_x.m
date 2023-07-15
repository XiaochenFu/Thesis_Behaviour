function [dP] = dprime_after_trial_x(Behaviour_Info_cat, trialX)
    % Extract Response and TrialType
    Response = extractfield(Behaviour_Info_cat , 'Response');
    TrialType = extractfield(Behaviour_Info_cat , 'TrialType');
    splus_index = strcmp('SPlus',TrialType);
    HIT = strcmp('HIT',Response);
    FA = strcmp('FA',Response);
    
    % Get index after the specified trialX
    if trialX > length(Response)
        dP = nan;
    end
    indexAfterTrialX = trialX+1:length(Response);
    
    % Calculate d-prime for trials after trialX
    s_HIT = sum(HIT(indexAfterTrialX));
    s_FA = sum(FA(indexAfterTrialX));
    s_Plus = sum(splus_index(indexAfterTrialX));
    s_Minus = sum(~splus_index(indexAfterTrialX));
    
    % Assuming you have a function called Dprime_Loglinear_norm50 to calculate d-prime
    dP = Dprime_Loglinear_norm50(s_HIT, s_FA, s_Plus, s_Minus);
end
