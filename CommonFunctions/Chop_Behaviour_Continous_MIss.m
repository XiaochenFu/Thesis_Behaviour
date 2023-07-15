% find the trial where mouse missed 3 times
function BehaviourInfo0 = Chop_Behaviour_Continous_MIss(BehaviourInfo)
TrialIndex = extractfield(BehaviourInfo,'index');
TrialType = extractfield(BehaviourInfo,'TrialType');
Response = extractfield(BehaviourInfo,'Response');
splus_idx = contains(TrialType,'SPlus');
Response_splus = Response(splus_idx);
% Find 3 continous misses
Response_splus_string = cell2mat(Response_splus);
Response_splus_string = replace(Response_splus_string,'HIT','HITT');
sp_index4_3miss = strfind(Response_splus_string,'MISSMISSMISS');
sp_index_3miss = (sp_index4_3miss-1)/4+1;
TrialIndex_sp = TrialIndex(splus_idx);
index_3miss = TrialIndex_sp(sp_index_3miss);

num_trial = length(TrialIndex);
index_3miss_after_last30 = index_3miss(index_3miss>(num_trial-30));
index_3miss_to_chop = min(index_3miss_after_last30);
if (num_trial-index_3miss_to_chop)<(num_trial/2)
    BehaviourInfo0 = BehaviourInfo(1:index_3miss_to_chop);
else
    BehaviourInfo0 = BehaviourInfo;
end
