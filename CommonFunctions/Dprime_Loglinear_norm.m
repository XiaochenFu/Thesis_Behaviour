function [dP,c] = Dprime_Loglinear(n_HIT,n_FA, n_SPlus, n_SMinus)
% Calculate the D prime use loglinear approach (Hautus, 1995) Note: the
% loglinear method calls for adding 0.5 to all cells under the assumption
% that there are an equal number of signal and noise trials. If this is not
% the case, then the numbers will be different. If there are, say, 60%
% signal trials and 40% noise trials, then you would add 0.6 to the number
% of Hits, and 2x0.6 = 1.2 to the number of signal trials, and then 0.4 to
% the number of false alarms, and 2x0.4 = 0.8 to the number of noise
% trials, etc.
% https://stats.stackexchange.com/questions/134779/d-prime-with-100-hit-rate-probability-and-0-false-alarm-probability
p_SPlus = n_SPlus/(n_SPlus+s_Minus);
p_SMinus = n_SMinus/(n_SPlus+s_Minus);
p_HIT = (n_HIT+p_SPlus)/(n_SPlus+p_SPlus*2);
p_FA = (n_FA+p_SMinus)/(n_SMinus+p_SMinus*2);
dP = norminv(p_HIT)-norminv(p_FA);
c = -0.5*(norminv(h)+ norminv(fA));