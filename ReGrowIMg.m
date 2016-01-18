function varargout = ReGrowIMg(varargin)
% REGROWIMG MATLAB code for ReGrowIMg.fig
%      REGROWIMG, by itself, creates a new REGROWIMG or raises the existing
%      singleton*.
%
%      H = REGROWIMG returns the handle to a new REGROWIMG or the handle to
%      the existing singleton*.
%
%      REGROWIMG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGROWIMG.M with the given input arguments.
%
%      REGROWIMG('Property','Value',...) creates a new REGROWIMG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ReGrowIMg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ReGrowIMg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ReGrowIMg

% Last Modified by GUIDE v2.5 18-Jan-2016 13:58:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ReGrowIMg_OpeningFcn, ...
    'gui_OutputFcn',  @ReGrowIMg_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% TO DO 
% REVISE EXPORT TO ACCOMODATE COLOCALIZATION




% --- Executes just before ReGrowIMg is made visible.
function ReGrowIMg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ReGrowIMg (see VARARGIN)

% Choose default command line output for ReGrowIMg
handles.output = hObject;

% Start with specific Options inactivated
set(handles.optDen,'Enable','off')
set(handles.stAnaly,'Enable','off')
set(handles.expOpts,'Enable','off')
set(handles.clearIMS,'Enable','off')
set(handles.chChoice,'Visible','off');
set(handles.zi,'Visible','off')
set(handles.zo,'Visible','off')
set(handles.pan,'Visible','off')
set(handles.optDen,'checked','off')



set(handles.imDisplay,'Visible','off')
set(handles.imDisplay,'XTickLabel',[],'YTickLabel',[],...
    'XTick',[],'YTick',[]);


handles.PixelDataOut.OD = {};
handles.CaseCount = 1;



% set(handles.infoT,'String','Load Image Files');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ReGrowIMg wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ReGrowIMg_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in filelist.
function filelist_Callback(hObject, eventdata, handles)
% hObject    handle to filelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filelist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filelist

set(handles.fnameBox,'String','')

% Get choice from list
secChoice = get(hObject,'Value');
handles.section2use = handles.FileNames{secChoice};
handles.liveImage = imread(handles.section2use);

% Display image selected
axes(handles.imDisplay);
imshow(handles.liveImage);

% Set default to tricolor
set(handles.aC,'Value',1);

set(handles.fnameBox,'String',handles.FileNames{secChoice})



guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function filelist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%
% MENU ITEMS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE OPTIONS---------------------------------------------################
function fileOpts_Callback(hObject, eventdata, handles)
% hObject    handle to fileOpts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load Image Series--------------------------------------------------------
function loadIMS_Callback(hObject, eventdata, handles)
% hObject    handle to loadIMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Objectives:
% 1. Load folder location of image files into the workspace
% 2. Create a list variable of the file names
% 3. Load list into the listpanel
% 4. Load the first image into the main window

set(handles.fnameBox,'String','')

% 1. Get Folder location
handles.fileLoc = uigetdir;

% If user clicks 'x' button without selecting folder than option will
% reopen
while ~handles.fileLoc
    toDo = questdlg('Did you mean to exit without selecting a Folder?',...
        'Reselect Folder','Yes','No','No');
    
    switch toDo
        case 'Yes'
            return
        case 'No'
            handles.fileLoc = uigetdir;
    end
end

% cd to directory
cd(handles.fileLoc)
% Check for tif files
fileDir = [dir('*tif'); dir('*tiff')];
fileTypes = {fileDir.name};
% Get file extensions of files in folder location
[~,~,exts] = cellfun(@(x) fileparts(x), fileTypes, 'UniformOutput',false);
extTest = unique(exts);
% If neither TIF nor TIFF exist then the program will break
if isempty(extTest)
    warndlg('There are tif files in this location!')
    return
end
% If TIF or TIFF files are found then they will be loaded
handles.imageINFO = parseImageFiles(fileTypes,2);
% 2. Create list handle
handles.FileNames = handles.imageINFO.Image.FNames;
% 3. Load file names into list panel
set(handles.filelist,'String',handles.FileNames)
% 4. Load first image into Display
handles.liveImage = imread(handles.FileNames{1});

set(handles.fnameBox,'String',handles.FileNames{1})





% Show Image
set(handles.imDisplay,'Visible','on')
axes(handles.imDisplay);
imshow(handles.liveImage)
% Show Color Channel Options
set(handles.chChoice,'Visible','on');
set(handles.aC,'Value',1);
% Turn off Load Image Series
set(handles.loadIMS,'Enable','off')
% Turn on Analysis Start
set(handles.stAnaly,'Enable','on')
% Turn on toolbar
set(handles.zi,'Visible','on')
set(handles.zo,'Visible','on')
set(handles.pan,'Visible','on')

guidata(hObject, handles);

% Clear Image Series-------------------------------------------------------
function clearIMS_Callback(hObject, eventdata, handles)
% hObject    handle to clearIMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% Exit Program-------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exitquest = questdlg('Are you sure you want to EXIT the program?','Exit?',...
    'Yes','No','Yes');

switch exitquest
    case 'Yes'
        delete(handles.figure1);
    case 'No'
        return
end

% Exit And Reload----------------------------------------------------------
function exReload_Callback(hObject, eventdata, handles)
% hObject    handle to exReload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exitquest = questdlg('Are you sure you want to RESTART the program?','Restart?',...
    'Yes','No','Yes');

switch exitquest
    case 'Yes'
        delete(handles.figure1);
        SCLayers;
    case 'No'
        return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ANALYSIS OPTIONS-----------------------------------------################
function analOpts_Callback(hObject, eventdata, handles)
% hObject    handle to analOpts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Start Analysis-----------------------------------------------------------
function stAnaly_Callback(hObject, eventdata, handles)
% hObject    handle to stAnaly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

analyCheck = questdlg('Are you sure you want to start an analysis?','Analysis?',...
    'Yes','No','Yes');

switch analyCheck
    case 'Yes'
        
        set(handles.stAnaly,'checked','on')
        set(handles.stAnaly,'Enable','off')
        set(handles.optDen,'Enable','on')
        set(handles.filelist,'Enable','off')
        set(handles.chChoice','Visible','off')
        set(handles.filelist,'Value',1);
        
        set(handles.mesText,'String','Choose Analysis Option From Drop Down Menu');
        
    case 'No'
        return
end

guidata(hObject, handles);

% Optical Density----------------------------------------------------------
function optDen_Callback(hObject, eventdata, handles)
% hObject    handle to optDen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% THREE Polygons per image and only the ratio of area above threshold need
% to be saved


set(handles.dataTable,'Data',0,'ColumnName',{'Superficial','Intermediate','Deep'},...
    'ColumnWidth',{50 50 50});

cla(handles.imDisplay);
set(handles.dataTable,'Data','');
% 3. Load file names into list panel
imageNames = get(handles.filelist,'String');
% 4. Load first image into Display
handles.liveImage = imread(imageNames{1});

set(handles.optDen,'checked','on')
set(handles.analOpts,'Enable','off')
set(handles.mesText,'String','Draw Polygon');

% User choose Display Channel
axes(handles.imDisplay);
chanToggle = 1;
while chanToggle
    
    dispChan = questdlg('Choose channel to trace ROI','TRACE RGB','R','G','B','B');
    
    switch dispChan
        case 'R'
            choseDChan = 1;
        case 'G'
            choseDChan = 2;
        case 'B'
            choseDChan = 3;
    end
    
    [dim1,dim2,~] = size(handles.liveImage);
    blankImage = uint8(zeros(dim1,dim2,3));
    blankImage(:,:,choseDChan) = handles.liveImage(:,:,choseDChan);
    chan2disp = blankImage;
    imshow(chan2disp)
    
    chanAccept = questdlg('Accept RGB channel for ROI trace?','Accept channel?','Yes',...
        'No','Yes');
    
    switch chanAccept
        case 'Yes'
            chanToggle = 0;
        case 'No'
            chanToggle = 1;
    end
end

% User choose Analyze Channel
analyzeChan = questdlg('Choose channel to Analyze Optical Density','ANALYZE RGB','R','G','B','B');

switch analyzeChan
    case 'R'
        choseAChan = 1;
    case 'G'
        choseAChan = 2;
    case 'B'
        choseAChan = 3;
end


axes(handles.imDisplay);
for imI = 1:length(imageNames)
    
    set(handles.mesText,'String','Draw Polygon for Superficial Layer');
    
    set(handles.fnameBox,'String',imageNames{imI})
    set(handles.filelist,'Value',imI);
    
    cla(handles.imDisplay);
    handles.liveImage = imread(imageNames{imI});
    [dim1,dim2,~] = size(handles.liveImage);
%     blankImage = uint8(zeros(dim1,dim2,3));
%     blankImage(:,:,choseDChan) = handles.liveImage(:,:,choseDChan);
    
    % Make inverted image
    image2invert = handles.liveImage(:,:,choseDChan);
    invertImInterest = 255-image2invert;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    
    chan2disp = invertImInterest;
%     chan2disp = blankImage;
    imshow(chan2disp)
    
    hold on;
    
    layerNs = {'Superficial','Intermediate','Deep'};
    
    for scLayi = 1:numel(layerNs)
        hold on;
        polyToggle = 1;
        while polyToggle
            
            % Check if section has layer
            checkText = sprintf('Does Section have %s Layer',layerNs{scLayi});
            layerQuest = questdlg(checkText,'Layer?','Yes','No','Yes');
            
            if strcmp(layerQuest, 'No')
                handles.(layerNs{scLayi}).PolyXC = NaN;
                handles.(layerNs{scLayi}).PolyYC = NaN;
                polyToggle = 0;
                continue
            end

            % Draw NTS polygon
            drawText = sprintf('Draw Polygon for %s Layer',layerNs{scLayi});
            set(handles.mesText,'String',drawText);
            [~, handles.(layerNs{scLayi}).PolyXC, handles.(layerNs{scLayi}).PolyYC] = roipoly(chan2disp);
            
            for pi = 1:scLayi
                
                if pi < scLayi
                
                    plot(handles.(layerNs{pi}).PolyXC, handles.(layerNs{pi}).PolyYC,'-r');
                
                else
                    plot(handles.(layerNs{pi}).PolyXC, handles.(layerNs{pi}).PolyYC,'-y');
                end
                
            end
            
            polyAccept = questdlg('Accept Traced ROI POLYGON?','Accept ROI?','Yes',...
                'No','Yes');
            
            switch polyAccept
                case 'Yes'
                    polyToggle = 0;
                case 'No'
                    polyToggle = 1;
            end
        end
    end
    
    image2analyze = handles.liveImage(:,:,choseAChan);
    
    for scLayi2 = 1:numel(layerNs)
        
        if isnan(handles.(layerNs{scLayi2}).PolyXC)
            
            handles.pixelInfo.(layerNs{scLayi2}).fracDenArea = NaN;
            
        else
            
            % User choose Analyze Channel
            
            wholePolymask.(layerNs{scLayi2}) = poly2mask(handles.(layerNs{scLayi2}).PolyXC,handles.(layerNs{scLayi2}).PolyYC,dim1,dim2); % Get mask
            
            versionCheck = version('-release');
            getYear = str2double(versionCheck(1:end-1));
            if getYear < 2009
                
                warndlg('Update your Matlab!');
                return
                
            else
                
                handles.pixelInfo.(layerNs{scLayi2}) = regionprops(wholePolymask.(layerNs{scLayi2}),image2analyze,'MeanIntensity','PixelValues','Area');
                
            end
            
            % Calculate quadrant corners
            
            % [B,~,~,~] = bwboundaries(mNtb_mask);


            xmax = max(handles.(layerNs{scLayi}).PolyXC);
            ymax = max(handles.(layerNs{scLayi}).PolyYC);
            
            xCor = handles.(layerNs{scLayi}).PolyXC(2:end);
            yCor = handles.(layerNs{scLayi}).PolyYC(2:end);
            
            yCorR = zeros(numel(yCor),1);
            for yi = 1:numel(yCor)
                yCorR(yi) = yCor(yi) + rand;
            end
            
            yCor = yCorR;
            
            xCorR = zeros(numel(xCor),1);
            for xi = 1:numel(xCor)
                xCorR(xi) = xCor(xi) + rand;
            end
            
            xCor = xCorR;
  
            corners.(layerNs{scLayi2}) = cornerFind(yCor, ymax, xCor, xmax);

            % Calculate pixel threshold
            pixelThreshold.(layerNs{scLayi2}) = mean(handles.pixelInfo.(layerNs{scLayi2}).PixelValues) + (std(double(handles.pixelInfo.(layerNs{scLayi2}).PixelValues))*2);
            % Copy original image
            image2thresh.(layerNs{scLayi2}) = image2analyze;
            % Exclude all pixels outside polygon
            image2thresh.(layerNs{scLayi2})(~wholePolymask.(layerNs{scLayi2})) = 0;
            % Create image with pixels above threshold
            finalImage.(layerNs{scLayi2}) = image2thresh.(layerNs{scLayi2}) > pixelThreshold.(layerNs{scLayi2});
            % Calculate area of pixels above threshold
            densityArea.(layerNs{scLayi2}) = bwarea(finalImage.(layerNs{scLayi2}));
            % Calculate fraction of area occupied by pixels above threshold
            handles.pixelInfo.(layerNs{scLayi2}).fracDenArea = densityArea.(layerNs{scLayi2})/handles.pixelInfo.(layerNs{scLayi2}).Area;
            
        end
        
    end
    
    % Save data from each section
    handles.PixelDataOut.OD{imI} = handles.pixelInfo;
    currentData = get(handles.dataTable,'Data');
    for neD = 1:numel(layerNs)
        
        if isnan(handles.pixelInfo.(layerNs{neD}).fracDenArea)
            currentData{imI,neD} = NaN;
        else
            currentData{imI,neD} = ceil(handles.pixelInfo.(layerNs{neD}).fracDenArea*1000)/1000;
        end
    end
    set(handles.dataTable,'Data',currentData);
    
end

set(handles.fnameBox,'String','')
set(handles.expOpts,'Enable','on')
cla(handles.imDisplay)
set(handles.mesText,'String','EXPORT YOUR DATA to EXCEL');

guidata(hObject, handles);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXPORT OPTIONS-------------------------------------------################
function expOpts_Callback(hObject, eventdata, handles)
% hObject    handle to expOpts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Export to Excel----------------------------------------------------------
function expExcel_Callback(hObject, eventdata, handles)
% hObject    handle to expExcel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exitquest = questdlg('Are you sure you want EXPORT to EXCEL?','Export?',...
    'Yes','No','Yes');

switch exitquest
    case 'Yes'
        
        secNames = handles.FileNames;
        
        saveDir = uigetdir;
        cd(saveDir);
        
        layerNs = {'Superficial','Intermediate','Deep'};
        
        sectionNum = cell(length(handles.PixelDataOut.OD)*3,1);
        layerID = cell(length(handles.PixelDataOut.OD)*3,1);
        fracOut = cell(length(handles.PixelDataOut.OD)*3,1);
        
        dataCount = 1;
        for i = 1:length(handles.PixelDataOut.OD)
            for dataI = 1:3
                sectionNum{dataCount} = secNames{i};
                layerID{dataCount} = layerNs{dataI};
                fracOut{dataCount} = handles.PixelDataOut.OD{i}.(layerNs{dataI}).fracDenArea;
                dataCount = dataCount + 1;
            end
        end
        
        DS = dataset(sectionNum, layerID, fracOut, 'VarNames', {'Section','Layer','FractionPixelsAboveArea'});
        
        caseID = inputdlg('Name for file','File Name', 1 , {'Case 1'});
        
        filename = strcat('SCLayer_',char(caseID),'_','.xlsx');
        
        export(DS,'XLSfile',filename);

    case 'No'
        return
end



% Export to Matlab---------------------------------------------------------
function expMatlab_Callback(hObject, eventdata, handles)
% hObject    handle to expMatlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


exitquest = questdlg('Are you sure you want EXPORT to MATLAB?','Export?',...
    'Yes','No','Yes');

switch exitquest
    case 'Yes'
        
        secNames = handles.FileNames;
        
        saveDir = uigetdir;
        cd(saveDir);
        
        layerNs = {'Superficial','Intermediate','Deep'};
        
        sectionNum = cell(length(handles.PixelDataOut.OD)*3,1);
        layerID = cell(length(handles.PixelDataOut.OD)*3,1);
        fracOut = cell(length(handles.PixelDataOut.OD)*3,1);
        
        dataCount = 1;
        for i = 1:length(handles.PixelDataOut.OD)
            for dataI = 1:3
                sectionNum{dataCount} = secNames{i};
                layerID{dataCount} = layerNs{dataI};
                fracOut{dataCount} = handles.PixelDataOut.OD{i}.(layerNs{dataI}).fracDenArea;
                dataCount = dataCount + 1;
            end
        end
        
        DS = dataset(sectionNum, layerID, fracOut, 'VarNames', {'Section','Layer','FractionPixelsAboveArea'});
        
        caseID = inputdlg('Name for file','File Name', 1 , {'Case 1'});
        
        filename = strcat('SCLayer_',char(caseID),'_','.mat');
        
        save(filename,'DS');

    case 'No'
        return
end







function chChoice_SelectionChangeFcn(hObject,eventdata, handles)

newVal = get(eventdata.NewValue,'Tag');

switch newVal % Get Tag of selected object.
    case 'rC'
        [dim1,dim2,~] = size(handles.liveImage);
        blankImage = uint8(zeros(dim1,dim2,3));
        blankImage(:,:,1) = handles.liveImage(:,:,1);
        newChImage = blankImage;
        axes(handles.imDisplay)
        imshow(newChImage)
    case 'gC'
        [dim1,dim2,~] = size(handles.liveImage);
        blankImage = uint8(zeros(dim1,dim2,3));
        blankImage(:,:,2) = handles.liveImage(:,:,2);
        newChImage = blankImage;
        axes(handles.imDisplay)
        imshow(newChImage)
    case 'bC'
        [dim1,dim2,~] = size(handles.liveImage);
        blankImage = uint8(zeros(dim1,dim2,3));
        blankImage(:,:,3) = handles.liveImage(:,:,3);
        newChImage = blankImage;
        axes(handles.imDisplay)
        imshow(newChImage)
    case 'aC'
        axes(handles.imDisplay)
        imshow(handles.liveImage)
    otherwise
        % Code for when there is no match.
end
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOOLBAR OPTIONS------------------------------------------################

% Zoom In On---------------------------------------------------------------
function zi_OnCallback(hObject, eventdata, handles)
% hObject    handle to zi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.mesText,'String','');

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.coloc,'checked'),'on')
    set(handles.mesText,'String','Click on Zoom In again to DRAW POLYGON');
elseif strcmp(get(handles.stAnaly,'checked'),'off')
    set(handles.mesText,'String','Choose Analysis START From Options');
else
    set(handles.mesText,'String','Choose Analysis Option From Drop Down Menu');
end

% Zoom In Off--------------------------------------------------------------
function zi_OffCallback(hObject, eventdata, handles)
% hObject    handle to zi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.mesText,'String','');

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.coloc,'checked'),'on')
    set(handles.mesText,'String','Draw Polygon');
elseif strcmp(get(handles.stAnaly,'checked'),'off')
    set(handles.mesText,'String','Choose Analysis START From Options');
else
    set(handles.mesText,'String','Choose Analysis Option From Drop Down Menu');
end

% Zoom Out On--------------------------------------------------------------
function zo_OnCallback(hObject, eventdata, handles)
% hObject    handle to zo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.mesText,'String','');

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.coloc,'checked'),'on')
    set(handles.mesText,'String','Click on Zoom In again to DRAW POLYGON');
elseif strcmp(get(handles.stAnaly,'checked'),'off')
    set(handles.mesText,'String','Choose Analysis START From Options');
else
    set(handles.mesText,'String','Choose Analysis Option From Drop Down Menu');
end

% Zoom Out Off-------------------------------------------------------------
function zo_OffCallback(hObject, eventdata, handles)
% hObject    handle to zo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.mesText,'String','');

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.coloc,'checked'),'on')
    set(handles.mesText,'String','Draw Polygon');
elseif strcmp(get(handles.stAnaly,'checked'),'off')
    set(handles.mesText,'String','Choose Analysis START From Options');
else
    set(handles.mesText,'String','Choose Analysis Option From Drop Down Menu');
end

% Pan On-------------------------------------------------------------------
function pan_OnCallback(hObject, eventdata, handles)
% hObject    handle to pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.mesText,'String','');

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.coloc,'checked'),'on')
    set(handles.mesText,'String','Draw Polygon');
elseif strcmp(get(handles.stAnaly,'checked'),'off')
    set(handles.mesText,'String','Choose Analysis START From Options');
else
    set(handles.mesText,'String','Choose Analysis Option From Drop Down Menu');
end

% Pan Off-------------------------------------------------------------------
function pan_OffCallback(hObject, eventdata, handles)
% hObject    handle to pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.mesText,'String','');

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.coloc,'checked'),'on')
    set(handles.mesText,'String','Draw Polygon');
elseif strcmp(get(handles.stAnaly,'checked'),'off')
    set(handles.mesText,'String','Choose Analysis START From Options');
else
    set(handles.mesText,'String','Choose Analysis Option From Drop Down Menu');
end
