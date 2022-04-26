function[] = savePlot(figure,varargin)
    %% function[] = savePlot(figure,Name,Size,varargin)
    % Saves Figure <figure> named <Name>, with size <Size> as pdf
    %
    % Input Parameter:
    % ----------------
    %   Required:
    %       figure: Figure to save,
    %
    %   Optional:
    %       Name:   Name of saved plot, default value PdfPlot
    %
    %   Additional:
    %       Size:   PaperSize of Plot, default value: [13,10] (cm)
    %       Directory:  you can input a Directory with 'path/to/folder' and save
    %                   the file there.
    %
    %       'Painters': default: 'no' -> does not use '-painter' to print plot
    %                            'yes' -> uses '-painter' to print plot
    %                            (carries more detail and also more data)...
    %                            for 3d plots 'high' is adviced to ged
    %                            vector-pdf
    %
    % Examples:
    % ---------
    %   savePlot(f1) -> saves f1 named PdfPlot with Size [13,10]cm at
    %                           root
    %
    %
    %   savePlot(f1,'Plot1','Size',[20,20],'Directory','plots') -> Will save figure f1 in
    %           directory plots/Plot1.pdf with width of 20x20cm
    %
    %
    %   TODO: maybe make automatic scaling for subplot-arrays such that a input parameter "AutoScaling" exists which determines the best size 
    %           for the pdf-size depending on the number of subplots (linear
    %           scaling..?)
    %
    
    % Parse Inputs
    defaultName = 'PdfPlot';
    defaultSize = [13,10];
    defaultDirectory = '.';
    defaultDetail = 'low';
    p = inputParser;
    addRequired(p,'figure');
    addOptional(p,'Name',defaultName,@(x)(ischar(x)));
    addParameter(p,'Size',defaultSize,@(x)( length(x)==2 & isnumeric(x(1)) & isnumeric(x(2)) ));
    addParameter(p,'Directory',defaultDirectory,@(x)(ischar(x)));
    addParameter(p,'Detail',defaultDetail,@(x)(ischar(x) || isstring(x)));
    parse(p,figure,varargin{:});
    
    % Make correct Path
    if p.Results.Directory(end) == '/'
        Name = append(p.Results.Directory,p.Results.Name);
    else
        Name = append(p.Results.Directory,'/',p.Results.Name);
    end
    
    
    %save Plot
    set(figure,'PaperUnits','centimeter','PaperSize',p.Results.Size)
    % plot in defined detail
    if isequal('high',lower(p.Results.Detail))
        print(figure','-dpdf','-painters','-bestfit',Name) %prettier
     else
        print(figure,Name,'-dpdf','-bestfit') % less data intensive
     end
    
    disp('Plot Saved!');
    end
    
    