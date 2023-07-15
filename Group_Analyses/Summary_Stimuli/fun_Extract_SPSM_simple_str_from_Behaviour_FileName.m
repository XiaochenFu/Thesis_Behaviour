function [SPlusName, SMinusName] = fun_Extract_SPSM_simple_str_from_Behaviour_FileName(FileName)
% input: FileName of the Behaviour csv file
% output: Two strings describe the stimuli.

idcs   = strfind(FileName,'_');
Training_Date = FileName((idcs(1)-2):(idcs(1)-1));  % The number of training day is the part after the first unserscore
Training_Date =  erase( Training_Date , 'y' );
Stimuli0 = FileName(idcs(1)+1:idcs(2)-1);   % The stimuli is the part after the first unserscore
% for odour, we don't need to check the light command (and there should be no command if we run the dummy.vi)
if contains(Stimuli0,'Odour')
    Stimuli_Type = 'Odour';
    Stimuli = Stimuli0;
    OdourPairName = extractAfter(Stimuli,"Odour");
    [SPlusName, SMinusName] = Sp_SM_Odour(OdourPairName);
else
    stim0 = fun_SPSM_FileName2Struct_simple_str(FileName);
    [structure1, structure2] = fun_Stim_Struct_2_simple_str(stim0);
    SPlusName = struct2str(structure1);
    SMinusName = struct2str(structure2);
%     light_Info = parse_training_info_test(FileName);
%     Stimuli_Type = 'Light';
%     if contains(FileName,'vs0') || contains(FileName,'v0')
%         Stimuli = 'Detection';% should be odour pair or light(Light detection intensity wi/wo odour, Light discrimination wi/wo odour)
%     else
%         Stimuli = 'Discrimination';
%         %         phase_name = asManyOfPattern(digitsPattern(1))+ 'ms'+'vs'+ asManyOfPattern(digitsPattern(1));
%         %         phase_pattern = namedPattern(phase_name);
%         %         extract(Stimuli0,phase_pattern)
%         if contains(FileName,'Delay')
%             Stimuli = 'Phase';
%         end
%         if contains(FileName,'Reverse')
%             Stimuli = 'Reverse';
%         end
% 
%     end
%     if contains(FileName,'mW')
%         idcs   = strfind(FileName,'mW');
%         Stimuli = [Stimuli FileName(idcs(1)-3:idcs(1)+1)];
%         Stimuli =  erase( Stimuli , '_' );
%     else
%         Stimuli =  'noLight';
%     end
%     if contains(FileName,'MV')
%         Stimuli =  strcat(Stimuli, 'MV');
%     end
%     if contains(FileName,'MT')
%         Stimuli =  strcat(Stimuli, 'MT');
%     end
end
% Result_Title = sprintf('Day%s_%s',Training_Date, Stimuli)
end
function [SPlusName, SMinusName] = Sp_SM_Odour(OdourPairName0)
OdourPairName = str2num(OdourPairName0);
switch OdourPairName
    case(1)
        SPlusName = "Ethyl Butyrate";
        SMinusName = "Methyl Tiglate";
    case(2)
        SPlusName = "Butyl Acetate";
        SMinusName = "Acetophenone";
    case(3)
        SPlusName = "Ethyl Tiglate";
        SMinusName = "Salicylaldehyde";
    case(4)
        SPlusName = "Butyl Butyrate";
        SMinusName = "Eugenol";
    case(5)
        SPlusName = "Methyl Valerate";
        SMinusName = "Methyl Butyrate";
    case(6)
        SPlusName = "Methyl Anthranilate";
        SMinusName = "Methyl Salicylate";
end
end


function str = struct2str(s)
    fn = fieldnames(s);
    for i = 1:numel(fn)
        if ~ischar(s.(fn{i}))
            s.(fn{i}) = num2str(s.(fn{i}));
        end
        
        % Append the field name after each value
        s.(fn{i}) = [fn{i},s.(fn{i}) ];
    end
    str = strjoin(struct2cell(s), '_');
end