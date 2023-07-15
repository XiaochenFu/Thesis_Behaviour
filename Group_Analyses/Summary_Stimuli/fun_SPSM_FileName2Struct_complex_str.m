
function light_Info = fun_SPSM_FileName2Struct_complex_str(input_string)
% Convert the input to a string object
input_str = string(input_string);

% Split the input string into parts
parts = split(input_str, '_');

% Initialize the variables
TrainingDays = NaN;
NumPulse = 0;
Intensity = 0;
PulseWidth = 0;
PulseFrequency = 0;
TrainingDate = 0;
DelayLatency = 0;
ReverseStimuli = 0;
Latency_stated = 0;

Latency_Pattern = digitsPattern+"msvs"+ digitsPattern+"ms";
NumPulse_Pattern0 = digitsPattern+"vs"+ digitsPattern;
NumPulse_Pattern1 = digitsPattern+"v"+ digitsPattern;

% Loop through parts and assign values based on their content
for i = 1:length(parts)
    part = parts(i);
    if startsWith(part, "Day")
        TrainingDays = str2double(extractAfter(part, 'Day'));
    elseif contains(part, "mW")
        Intensity = str2double(extractBetween(part, '', 'mW'));
        if length(Intensity)>1
            Intensity = sprintf('%dvs%d',Intensity(1),Intensity(2));
        end
    elseif contains(part, "ms") && ~contains(part, "vs")
        PulseWidth = str2double(extractBetween(part, '', 'ms'));
    elseif contains(part, "Hz")
        PulseFrequency = str2double(extractBetween(part, '', 'Hz'));
    elseif count(part, digitsPattern(12)) > 0
        TrainingDate = extractBefore(part, strlength(part) - 5);
    elseif contains(part, Latency_Pattern)
        DelayLatency = part;
        Latency_stated = 1;
    elseif contains(part, NumPulse_Pattern0) || contains(part, NumPulse_Pattern1)
        NumPulse = part;

    elseif contains(part, "Reverse")
        % For reverse learning
        ReverseStimuli = 1;
    end
end
if ~ReverseStimuli && ~Latency_stated && all(Intensity(:)==0)
    %     DelayLatency = "20msvs120ms";
    %     DelayLatency = "80msvs80ms";
    DelayLatency = "20msvs20ms";
end
% create structure
light_Info = struct('TrainingDate', TrainingDate, 'TrainingDays', TrainingDays, 'NumPulse', NumPulse, 'Intensity', Intensity, 'PulseWidth', PulseWidth, 'PulseFrequency', PulseFrequency, 'DelayLatency', DelayLatency, 'ReverseStimuli', ReverseStimuli);
% TrainingDate = extractfield(light_Info, 'TrainingDate');
% TrainingDays = extractfield(light_Info, 'TrainingDays');
% NumPulse = extractfield(light_Info, 'NumPulse');
% Intensity = extractfield(light_Info, 'Intensity');
% PulseWidth = extractfield(light_Info, 'PulseWidth');
% PulseFrequency = extractfield(light_Info, 'PulseFrequency');
% DelayLatency = extractfield(light_Info, 'DelayLatency');
% ReverseStimuli = extractfield(light_Info, 'ReverseStimuli');