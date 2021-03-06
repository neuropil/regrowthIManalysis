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

% Last Modified by GUIDE v2.5 23-Jan-2016 21:04:57

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

set(handles.accept,'Enable','off')



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


set(handles.dataTable,'Data',[0,0;0,0],'ColumnName',{'Red','Green'},...
    'ColumnWidth',{40 40});

cla(handles.imDisplay);
% set(handles.dataTable,'Data','');
% 3. Load file names into list panel
handles.imageNames = get(handles.filelist,'String');
% 4. Load first image into Display
handles.liveImage = imread(handles.imageNames{1});

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
            handles.choseDChan = 1;
        case 'G'
            handles.choseDChan = 2;
        case 'B'
            handles.choseDChan = 3;
    end
    
    [dim1,dim2,~] = size(handles.liveImage);
    blankImage = uint16(zeros(dim1,dim2,3));
    blankImage(:,:,handles.choseDChan) = handles.liveImage(:,:,handles.choseDChan);
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
% analyzeChan = questdlg('Choose channel to Analyze Optical Density','ANALYZE RGB','R','G','B','B');
% 
% switch analyzeChan
%     case 'R'
%         handles.choseAChan = 1;
%     case 'G'
%         handles.choseAChan = 2;
%     case 'B'
%         handles.choseAChan = 3;
% end

handles.fileNUM = 1;
% MAKE TEXT for aCCept button say START 

%%%%% PUT SOMEWHERE ELSE

% 

axes(handles.imDisplay);

set(handles.fnameBox,'String',handles.imageNames{1})

set(handles.filelist,'Value',1);

cla(handles.imDisplay);
handles.liveImage = imread(handles.imageNames{1});
[dim1,dim2,~] = size(handles.liveImage);

handles.dim1 = dim1;
handles.dim2 = dim2;

% Make inverted image
image2invert = handles.liveImage(:,:,handles.choseDChan);
invertImInterest = 65535-image2invert;


%%%%%%%%%%%%%%%%%%%%%%%%

handles.chan2disp = invertImInterest;
%     chan2disp = blankImage;
imshow(handles.chan2disp)

hold on;

handles.PolyXC = NaN;
handles.PolyYC = NaN;

% Draw NTS polygon
drawText = sprintf('Move ROI Box over junction');
set(handles.mesText,'String', drawText);

%         [~, handles.PolyXC, handles.PolyYC] = roipoly(chan2disp);

% Create box values

handles.xPoints = ceil(handles.dim1*0.8);
handles.yPoints = ceil(handles.dim2*0.2);

handles.xstart = ceil((handles.dim1 - handles.xPoints)/2);
handles.ystart = ceil(handles.dim2/2);

handles.cenX = round((handles.xPoints/2) + handles.xstart);
handles.cenY = round((handles.yPoints/2) + handles.ystart);

handles.theta = 0;

pout = computRotation(handles.xPoints,handles.yPoints,handles.theta);

handles.P = pout;

plot(handles.P(1,:) + handles.cenX, handles.P(2,:) + handles.cenY,'-r');


set(handles.accept,'Enable','on')


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
        blankImage = uint16(zeros(dim1,dim2,3));
        blankImage(:,:,1) = handles.liveImage(:,:,1);
        newChImage = blankImage;
        axes(handles.imDisplay)
        imshow(newChImage)
    case 'gC'
        [dim1,dim2,~] = size(handles.liveImage);
        blankImage = uint16(zeros(dim1,dim2,3));
        blankImage(:,:,2) = handles.liveImage(:,:,2);
        newChImage = blankImage;
        axes(handles.imDisplay)
        imshow(newChImage)
    case 'bC'
        [dim1,dim2,~] = size(handles.liveImage);
        blankImage = uint16(zeros(dim1,dim2,3));
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


% --- Executes on button press in up.
function up_Callback(hObject, eventdata, handles)
% hObject    handle to up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.yPoints = handles.yPoints - 10;

handles.cenY = round((handles.yPoints/2) + handles.ystart);

cla(handles.imDisplay);

imshow(handles.chan2disp);

plot(handles.P(1,:) + handles.cenX,handles.P(2,:) + handles.cenY,'-r');

guidata(hObject, handles);


% --- Executes on button press in down.
function down_Callback(hObject, eventdata, handles)
% hObject    handle to down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.yPoints = handles.yPoints + 10;

handles.cenY = round((handles.yPoints/2) + handles.ystart);

cla(handles.imDisplay);

imshow(handles.chan2disp);

plot(handles.P(1,:) + handles.cenX,handles.P(2,:) + handles.cenY,'-r');

guidata(hObject, handles);


% --- Executes on button press in left.
function left_Callback(hObject, eventdata, handles)
% hObject    handle to left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.xPoints = handles.xPoints - 5;

handles.cenX = round((handles.xPoints/2) + handles.xstart);

cla(handles.imDisplay);

imshow(handles.chan2disp);

plot(handles.P(1,:) + handles.cenX, handles.P(2,:) + handles.cenY,'-r');

guidata(hObject, handles);


% --- Executes on button press in right.
function right_Callback(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.xPoints = handles.xPoints + 5;

handles.cenX = round((handles.xPoints/2) + handles.xstart);

cla(handles.imDisplay);

imshow(handles.chan2disp);

plot(handles.P(1,:) + handles.cenX, handles.P(2,:) + handles.cenY,'-r');

guidata(hObject, handles);



% --- Executes on button press in clockwise.
function clockwise_Callback(hObject, eventdata, handles)
% hObject    handle to clockwise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.theta =  handles.theta + 0.01;

ct = cos(handles.theta);
st = sin(handles.theta);

handles.R = [ct -st;st ct];
handles.P = handles.R * handles.P;

cla(handles.imDisplay);

imshow(handles.chan2disp);

plot(handles.P(1,:) + handles.cenX, handles.P(2,:) + handles.cenY,'-r');

guidata(hObject, handles);











% --- Executes on button press in accept.
function accept_Callback(hObject, eventdata, handles)
% hObject    handle to accept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get RED and GREEN 
% Get File number

if handles.fileNUM < length(handles.filelist.String)+1
    
    handles.PolyXC = handles.P(1,:) + handles.cenX;
    handles.PolyYC = handles.P(2,:) + handles.cenY;
    
    
    for ci = 1:2
        
        % ci = 1 = Red Channel
        % ci = 2 = Green Channel

        image2analyze = handles.liveImage(:,:,ci);
        
        % Compute threshold using Otsu's method
        [level,~] = graythresh(image2analyze);
        % Apply threshold and create threshold mask
        BWim = im2bw(image2analyze,level);
        % Copy image and apply mask
        image2analyze2 = image2analyze;
        image2analyze2(~BWim) = 0;
        
        % Image is now thresholded and converted to DOUBLE
        im2dB = im2double(image2analyze2);
        
        % User choose Analyze Channel
        wholePolymask = poly2mask(handles.PolyXC,handles.PolyYC,handles.dim1,handles.dim2); % Get mask
        handles.pixelInfo = regionprops(wholePolymask,im2dB,'MeanIntensity','MaxIntensity','PixelValues','Area');
        
        polyAREA = handles.dim1*handles.dim2;
        
        
        % Calculate quadrant corners
        
        % [B,~,~,~] = bwboundaries(mNtb_mask);
        
        % TO CALCULATE QUADRANTS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % xmax = max(handles.PolyXC);
        % ymax = max(handles.PolyYC);
        
        % xCor = handles.PolyXC(2:end);
        % yCor = handles.PolyYC(2:end);
        
        % yCorR = zeros(numel(yCor),1);
        % for yi = 1:numel(yCor)
        %     yCorR(yi) = yCor(yi) + rand;
        % end
        
        % yCor = yCorR;
        
        % xCorR = zeros(numel(xCor),1);
        % for xi = 1:numel(xCor)
        %     xCorR(xi) = xCor(xi) + rand;
        % end
        
        % xCor = xCorR;
        
        % corners = cornerFind(yCor, ymax, xCor, xmax);
        
        % TO CALCULATE QUADRANTS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Calculate pixel threshold
%         pixelThreshold = mean(handles.pixelInfo.PixelValues) + (std(double(handles.pixelInfo.PixelValues))*2);
%         pixelThreshold = median(handles.pixelInfo.PixelValues)+ iqr(handles.pixelInfo.PixelValues);
        % Copy original image
%         image2thresh = image2analyze2;
        % Exclude all pixels outside polygon
%         image2thresh(~wholePolymask) = 0;
        % Create image with pixels above threshold
%         finalImage = image2thresh > pixelThreshold;
        % Calculate area of pixels above threshold
        densityArea = handles.pixelInfo.Area;
        % Calculate fraction of area occupied by pixels above threshold
        handles.pixelInfo.fracDenArea = densityArea/polyAREA;
        
        % Save data from each section
        handles.PixelDataOut.OD{handles.fileNUM,ci} = handles.pixelInfo;
        currentData = get(handles.dataTable,'Data');
        
        currentData(handles.fileNUM,ci) = ceil(handles.pixelInfo.fracDenArea*1000)/1000;
        
        set(handles.dataTable,'Data',currentData);
        
        
        
    end
    
    handles.fileNUM = handles.fileNUM + 1;
    
    % Load next image
    
    if handles.fileNUM < length(handles.filelist.String)+1
        
        axes(handles.imDisplay);
        
        set(handles.fnameBox,'String',handles.imageNames{handles.fileNUM})
        
        set(handles.filelist,'Value',handles.fileNUM);
        
        cla(handles.imDisplay);
        handles.liveImage = imread(handles.imageNames{handles.fileNUM});
        [dim1,dim2,~] = size(handles.liveImage);
        
        handles.dim1 = dim1;
        handles.dim2 = dim2;
        
        % Make inverted image
        image2invert = handles.liveImage(:,:,handles.choseDChan);
        invertImInterest = 65535-image2invert;
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%
        
        handles.chan2disp = invertImInterest;
        %     chan2disp = blankImage;
        imshow(handles.chan2disp)
        
        hold on;
        
        handles.PolyXC = NaN;
        handles.PolyYC = NaN;
        
        % Draw NTS polygon
        drawText = sprintf('Move ROI Box over junction');
        set(handles.mesText,'String', drawText);
        
        %         [~, handles.PolyXC, handles.PolyYC] = roipoly(chan2disp);
        
        % Create box values
        
        handles.xPoints = ceil(handles.dim1*0.8);
        handles.yPoints = ceil(handles.dim2*0.2);
        
        handles.xstart = ceil((handles.dim1 - handles.xPoints)/2);
        handles.ystart = ceil(handles.dim2/2);
        
        handles.cenX = round((handles.xPoints/2) + handles.xstart);
        handles.cenY = round((handles.yPoints/2) + handles.ystart);
        
        handles.theta = 0;
        
        pout = computRotation(handles.xPoints,handles.yPoints,handles.theta);
        
        handles.P = pout;
        
        plot(handles.P(1,:) + handles.cenX, handles.P(2,:) + handles.cenY,'-r');
        
        
        set(handles.accept,'Enable','on')
        
    end
    
    
    
else
    set(handles.fnameBox,'String','')
    set(handles.expOpts,'Enable','on')
    cla(handles.imDisplay)
    set(handles.mesText,'String','EXPORT YOUR DATA to EXCEL');
end


guidata(hObject, handles);




