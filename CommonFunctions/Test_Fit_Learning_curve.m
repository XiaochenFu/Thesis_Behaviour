cc
cd('C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\CommonFunctions')
%% read the result from the go/nogo
% load('C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Tenth_Batch\LBHD_268\Behaviour_Accuracy\Day6_Odour3_BehaviourResult.mat')
% load('C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Tenth_Batch\LBHD_268\Behaviour_Accuracy\Day7_Detection38mW_BehaviourResult.mat')
load('C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Seventh_Batch\TbxAi32_67\Behaviour_Accuracy\Day6_Detection50mW_BehaviourResult.mat')
% load('C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Seventh_Batch\TbxAi32_67\Behaviour_Accuracy\Day5_Detection50mW_BehaviourResult.mat')
% load('C:\Users\yycxx\OneDrive - OIST\Thesis\Behaviour\Seventh_Batch\TbxAi32_67\Behaviour_Accuracy\Day4_Detection25mW_BehaviourResult.mat')
%%

Behaviour_Info0 = Chop_Behaviour_Continous_MIss(Behaviour_Info);
cumulated_session = 0;
session_interval = 2;
figure
Response = extractfield(Behaviour_Info0 , 'Response');
TrialType = extractfield(Behaviour_Info0 , 'TrialType');
splus_index = strcmp('SPlus',TrialType);
HIT = strcmp('HIT',Response);
FA = strcmp('FA',Response);
Session = [];
Dp = [];
% if isempty(num_session)
    num_session = length(Behaviour_Info0)/10;
% end
for session = 1:num_session
    n = 1:10;
    n10 = (session-1)*10+n;
    s_HIT = sum(HIT(n10));
    s_FA = sum(FA(n10));
    s_Plus = sum(splus_index(n10));
    s_Minus = 10-s_Plus;
    dP = Dprime_Loglinear_norm50(s_HIT,s_FA, s_Plus, s_Minus);
    Session = [Session session];
    Dp = [Dp dP];
end
% [ Qpre, p, sm, varcov] = fit_logistic(Session,Dp)

% plot((Session+cumulated_session),Dp,'-o','Color',c,...
%     'MarkerEdgeColor','k',...
%     'MarkerFaceColor',c)
% hold on 
%%
A = [0.5 0.2 1];
% 定义sigmoid函数
sigfunc = @ (A, x) (A (1) ./ (1 + exp (-A (2)*(x- A(3)))));

% 使用nlinfit进行非线性回归
A0 = ones (size (A)); % 初始参数
% A_fit = nlinfit (Session, Dp, sigfunc, A0)
% define the lower bound
lb = [0 1 []];
ub = [5,[],[]];
A_fit = lsqcurvefit(sigfunc,A0,Session,Dp,lb,ub)

% 绘制数据和拟合曲线
plot (Session, Dp, 'o')
hold on
plot (Session, sigfunc (A_fit, Session), 'r')
hold off
legend ('Data', 'Fit')
xlabel ('x')
ylabel ('y')
title ('Sigmoid curve fitting using logistic function')
