function [saveName] = saveDatawithTime(varargin)
%% function [name] = saveDatawithTime(Name,Directory)
%   Saves data from base-workspace with time stamp in format
%           Name_DD-Month-YYYY-HH-MM.mat
% Parameter:
% ----------
% optional: 
%   Name: character-array for Name of .mat file
%   Directory: './path/to/directory' | default: matlab-root           
%   Variables: default: Saves all data to workspace
%              else:   saves given variables, input as ["var1";"var2";...]
%
% Return
% ------
%
% name of file (incl. directory)
%
% Examples: 
% ---------
%   without Name:   22-Jan-2022-17-3.mat
%   with Name:      saveForTest_22-Jan-2022-17-3.mat
%
defaultName = '';
defaultDirectory = '.';
defaultVariables = [''];
p = inputParser;
p.KeepUnmatched = true;
addOptional(p,'Name',defaultName,@(x)(ischar(x)));
addParameter(p,'Directory',defaultDirectory,@(x)(ischar(x)));
addParameter(p,'Variables',defaultVariables,@(x)(isstring(x)));
parse(p,varargin{:});

% Get correct date
saveName = date;
c = clock;
if isequal(p.Results.Name,defaultName)
    Name = p.Results.Name;
else
    Name = append(p.Results.Name,'_');
end

% Make correct Path
if p.Results.Directory(end) == '/'
    warning off
    mkdir(p.Results.Directory);
    warning on
    Name = append(p.Results.Directory,Name);
else
    warning off
    mkdir(p.Results.Directory);
    warning on
    Name = append(p.Results.Directory,'/',Name);
end

% Save date from Base-Workspace
saveName = append(Name,saveName,'-',num2str(c(4)),'-',num2str(c(5)));

% Add all variables to save
command = append('save(','''',saveName,'''');
for i = 1:length(p.Results.Variables)
    command = append(command,',','''',p.Results.Variables(i),'''');
end
command = append(command,')');
evalin('base',command);


disp("Data saved!");
end

