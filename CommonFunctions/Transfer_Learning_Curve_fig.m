%% OIST laptop
% addpath('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Code\Basic_Settings')
% addpath('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Code\Useful_Functions')
% addpath('C:\Users\yycxx\Dropbox (OIST)\Fukunaga_Lab_Joined\Code\Useful_Functions\Sniff')
% addpath(genpath('C:\Users\yycxx\OneDrive - OIST\Ephys_Code\spikes-master'));
% startup

%% 
Destination_Path = 'C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Group_Analyses\Learning_Curve_All';
%%
% find the file called xxx id learning.fig
figname = strcat(strrep(currD,'_',' '),' learning.fig');
copyfile(figname,Destination_Path)
