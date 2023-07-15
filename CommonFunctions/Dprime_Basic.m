function [dP,c] = Dprime_Basic(n_HIT,n_FA, n_SPlus, n_SMinus)
% Dprime, basic version

p_HIT = n_HIT/n_SPlus;
p_FA = n_FA/n_SMinus;
dP = norminv(p_HIT)-norminv(p_FA);
c = -0.5*(norminv(h)+ norminv(fA));