function[] = exportPlot(figure,varargin)
%% function[] = exportPlot(figure,Name,Size,Path)
%
% Parameters:
% -----------
%   Required:
%       figure: Figure object
%   Optional
%       Name:   Name of plot (char array)| default = 'PdfPlot'
%   optional Paramter: (use with name: 'Size',[1 2])
%       Size: [width,height] | default: [19,7], use
%       Directory: './path/to/directory' | default: matlab-root
%       Format: default:    'default': no scaling
%
%                           'half': scales xvalue to .45 (perfect for
%                               subfigures when using default size)
%                        
%                           'subplotY': scales to a subplot with Y elements in
%                               Y-direction
%                        
%                           'subplotYX': scales to a subplot with Y.X elements
%       
% 

% Parse Inputs
    defaultName = 'PdfPlot';
    defaultDirectory = '.';
    defaultSize = [19,7];
    defaultFormat = 'default';
    p = inputParser;
    addRequired(p,'figure');
    addOptional(p,'Name',defaultName,@(x)(ischar(x)));
    addParameter(p,'Size',defaultSize,@(x)( length(x)==2 & isnumeric(x(1)) & isnumeric(x(2)) ));
    addParameter(p,'Directory',defaultDirectory,@(x)(ischar(x)));
    addParameter(p,'Format',defaultFormat,@(x)(ischar(x)));
    parse(p,figure,varargin{:});

% Make correct Path
    if p.Results.Directory(end) == '/'
        warning off
        mkdir(p.Results.Directory);
        warning on
        Name = append(p.Results.Directory,p.Results.Name,'.pdf');
    else
        warning off
        mkdir(p.Results.Directory);
        warning on
        Name = append(p.Results.Directory,'/',p.Results.Name,'.pdf');
    end
% Make size-settings
if isequal(lower(p.Results.Format),'default')
   Size = p.Results.Size; 
elseif isequal(lower(p.Results.Format),'half')
    Size = [p.Results.Size(1)*0.44 , p.Results.Size(2)];
elseif length(p.Results.Format)==9 && isequal(lower(p.Results.Format(1:7)),'subplot')
    yscale = p.Results.Format(8) - 48;
    xscale = p.Results.Format(9) - 48;
    Size = [p.Results.Size(1)*xscale, p.Results.Size(2)*yscale];
elseif length(p.Results.Format)==8 && isequal(lower(p.Results.Format(1:7)),'subplot')
    yscale = p.Results.Format(8) - 48;
    Size = [p.Results.Size(1), p.Results.Size(2)*yscale];
end

% Set figure to correct Size
    set(figure,'Units','Centimeters');
    pos = get(figure,'Position');
    figure.Position = [pos(1),pos(2),Size(1),Size(2)];
% Save
    exportgraphics(figure,Name,'ContentType','vector');
    
    % Rescale back to origin size
    figure.Position = pos;
    disp('Plot Exported!')
end