DataFile = [training_day,'_',pair,'_BehaviourResult.mat'];
load(fullfile(DataPath,DataFile))
if isempty(num_session)
    num_session = length(Behaviour_Info)/10;
end
switch pair
    case 'Odour1'
        c = c_odour1;
        odour_list = [odour_list, 1];
    case 'Odour2'
        c = c_odour2;
        odour_list = [odour_list, 2];
    case 'Odour3'
        c = c_odour3;
        odour_list = [odour_list, 3];
    case 'Odour4'
        c = c_odour4;
        odour_list = [odour_list, 4];
    case 'Odour5'
        c = c_odour5;
        odour_list = [odour_list, 5];
    case 'Odour6'
        c = c_odour6;
        odour_list = [odour_list, 6];
    otherwise
        if contains(pair,'mW')
            if contains(pair,'Detection','IgnoreCase',true)
                light_intensity = extract(pair,digitsPattern);
                light_intensity = str2num(light_intensity{1});
                c_map = cbrewer2('Blues', 100);

                c = c_map(round(light_intensity),:);
                eval(sprintf('c_light%d = c;',light_intensity))
                light_list = [light_list, light_intensity];
            elseif contains(pair,'Phase','IgnoreCase',true)
                light_intensity = extract(pair,digitsPattern);
                light_intensity = str2num(light_intensity{1});
                c_map = cbrewer2('Greys', 100);

                c = c_map(round(light_intensity),:);
                eval(sprintf('c_phase%d = c;',light_intensity))
                light_list = [light_list, light_intensity];
            end
        
        end

end

Response = extractfield(Behaviour_Info , 'Response');
TrialType = extractfield(Behaviour_Info , 'TrialType');
splus_index = strcmp('SPlus',TrialType);
HIT = strcmp('HIT',Response);
FA = strcmp('FA',Response);
Session = [];
Dp = [];
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

plot((Session+cumulated_session),Dp,'-o','Color',c,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',c)
hold on 
%     'LineWidth',2,...
% 'MarkerSize',10,...

cumulated_session = cumulated_session+ max(Session)+session_interval;