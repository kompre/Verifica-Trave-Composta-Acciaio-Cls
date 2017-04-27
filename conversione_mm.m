function [ tab ] = conversione_mm( tab )
%CONVERSIONE_MM converte le misure in cm in mm
%   Detailed explanation goes here

varunits = tab.Properties.VariableUnits;

for i = 1:length(varunits)
    if ~isempty(regexp(varunits{i}, 'cm', 'match'))
        magnitudine = regexp(varunits{i}, '\d', 'match');
        if isempty(magnitudine)
            magnitudine = {'1'};
        end
        tab{:, i} = tab{:, i}*10^str2double(magnitudine{1});
        varunits{i} = regexprep(varunits{i}, 'cm', 'mm');
    end
end

tab.Properties.VariableUnits = varunits;

end

