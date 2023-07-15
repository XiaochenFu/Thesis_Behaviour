function [dP,c] = Dprime_Loglinear_norm50(n_HIT,n_FA, n_SPlus, n_SMinus)
% Z(0) and Z(1) is infinity. One way around it is to add 1 to each of the 4
% outcomes. For example the HR for 40 True responses out of 40 trials with
% a True stimulus, instead of being 40/40 would be 41/42. NOTE: To avoid
% bias, this procedure should be done for all conditions regardless of
% whether the rates are at extreme values (0 or 1) or not.

% UPDATE: To make this procedure consistent across experiments with
% different numbers of trials for each condition, one can first normalize
% the number of trials in each condition to 100 and then add 1. In the
% previous example, 40/40 HR would first become 100/100 and then becomes
% 101/102. This way the same z-score and hence d-prime will be obtained for
% experiments with same ratios of hits and misses but different number of
% trials.

% https://openwetware.org/wiki/Beauchamp:dprime

norm_HIT = n_HIT/n_SPlus*50;
norm_FA = n_FA/n_SMinus*50;
p_HIT = (norm_HIT+0.5)/(50+1);
p_FA = (norm_FA+0.5)/(50+1);
dP = norminv(p_HIT)-norminv(p_FA);
c = -0.5*(norminv(p_HIT)+ norminv(p_FA));