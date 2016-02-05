imtest = imread('Long Sample 5b-3.tif');

figure;
imshow(imtest)
[dim1,dim2,~] = size(imtest);

%% Extract channel of interest (to trace) 
close all
blankImage = uint16(zeros(dim1,dim2,3));
blankImage(:,:,2) = imtest(:,:,2);
chan2disp = blankImage;
figure;
imshow(chan2disp)

%% Make inverted image.
close all
image2invert = imtest(:,:,2);
invertImInterest = 65535-image2invert;

figure;
imh = imshow(invertImInterest);

%% Background box

h = imrect(gca);
pos = getPosition(h);


BW = createMask(h,imh);
delete(h);

greenIm = imtest(:,:,2);
greenImN = im2double(greenIm);
pixelInfoGr = regionprops(BW,greenImN,'MeanIntensity','MaxIntensity','PixelValues');
thresholdGr = mean(pixelInfoGr.PixelValues) + (std(pixelInfoGr.PixelValues)*2);

redIm = imtest(:,:,1);
redImN = im2double(redIm);
pixelInfoRd = regionprops(BW,redImN,'MeanIntensity','MaxIntensity','PixelValues');
thresholdRd = mean(pixelInfoRd.PixelValues) + (std(pixelInfoRd.PixelValues)*2);
        
% save('Im_LongSamp_5a-3.mat','BW','pixelInfoGr','pixelInfoRd','thresholdGr','thresholdRd');


%% Plot BOX 1
% close all
% figure;
imh = imshow(invertImInterest);

xPoints = 770;
yPoints = 330;

xstart = 740;
ystart = 600;

a = round((xPoints/2) + xstart);
b = round((yPoints/2) + ystart);

w = xPoints;
h = yPoints;
theta = 0;
X = [-w/2 w/2 w/2 -w/2 -w/2];
Y = [h/2 h/2 -h/2 -h/2 h/2];
P = [X;Y];
ct = cos(theta);
st = sin(theta);
R = [ct -st;st ct];
P = R * P;
hold on
plot(P(1,:)+a,P(2,:)+b,'r-');

PolyXC_b1 = P(1,:) + a;
PolyYC_b1 = P(2,:) + b;


wholePolymask_b1 = poly2mask(PolyXC_b1,PolyYC_b1,dim1,dim2);

% Get values for thresholded image

gRThr = graythresh(greenImN);
BWgrTh = im2bw(greenImN,gRThr);
greenN = greenImN;
greenN(~BWgrTh) = 0;

greenMeasure2_b1 = greenN;
greenMeasure2_b1(~wholePolymask_b1) = 0;
grArea_b1 = bwarea(greenMeasure2_b1);
allArea = xPoints*yPoints;

pxGr_b1 = grArea_b1/allArea;

% Get values for thresholded image

rDThr = graythresh(redImN);
BWrdTh = im2bw(redImN,rDThr);
redN = redImN;
redN(~BWrdTh) = 0;

redMeasure2_b1 = redN;
redMeasure2_b1(~wholePolymask_b1) = 0;
redArea_b1 = bwarea(redMeasure2_b1);

pxRd_b1 = redArea_b1/allArea;

%%

% Box 2
xPoints = 770;
yPoints = 330;

xstart = 570;
ystart = 930;

a = round((xPoints/2) + xstart);
b = round((yPoints/2) + ystart);

w = xPoints;
h = yPoints;
theta = 0;
X = [-w/2 w/2 w/2 -w/2 -w/2];
Y = [h/2 h/2 -h/2 -h/2 h/2];
P = [X;Y];
ct = cos(theta);
st = sin(theta);
R = [ct -st;st ct];
P = R * P;
hold on
plot(P(1,:)+a,P(2,:)+b,'r-');

%

PolyXC_b2 = P(1,:) + a;
PolyYC_b2 = P(2,:) + b;

wholePolymask_b2 = poly2mask(PolyXC_b2,PolyYC_b2,dim1,dim2);

% Get values for thresholded image
greenMeasure2_b2 = greenN;
greenMeasure2_b2(~wholePolymask_b2) = 0;
grArea_b2 = bwarea(greenMeasure2_b2);
allArea = xPoints*yPoints;

pxGr_b2 = grArea_b2/allArea;

% Get values for thresholded image

redMeasure2_b2 = redN;
redMeasure2_b2(~wholePolymask_b2) = 0;
redArea_b2 = bwarea(redMeasure2_b2);

pxRd_b2 = redArea_b2/allArea;


%

xPoints = 770;
yPoints = 330;

xstart = 450;
ystart = 1260;

a = round((xPoints/2) + xstart);
b = round((yPoints/2) + ystart);

w = xPoints;
h = yPoints;
theta = 0;
X = [-w/2 w/2 w/2 -w/2 -w/2];
Y = [h/2 h/2 -h/2 -h/2 h/2];
P = [X;Y];
ct = cos(theta);
st = sin(theta);
R = [ct -st;st ct];
P = R * P;
hold on
plot(P(1,:)+a,P(2,:)+b,'r-');
%
PolyXC_b3 = P(1,:) + a;
PolyYC_b3 = P(2,:) + b;

wholePolymask_b3 = poly2mask(PolyXC_b3,PolyYC_b3,dim1,dim2);

% Get values for thresholded image
greenMeasure2_b3 = greenN;
greenMeasure2_b3(~wholePolymask_b3) = 0;
grArea_b3 = bwarea(greenMeasure2_b3);

pxGr_b3 = grArea_b3/allArea;

% Get values for thresholded image

redMeasure2_b3 = redN;
redMeasure2_b3(~wholePolymask_b3) = 0;
redArea_b3 = bwarea(redMeasure2_b3);

pxRd_b3 = redArea_b3/allArea;

%

xPoints = 770;
yPoints = 330;

xstart = 370;
ystart = 1590;

a = round((xPoints/2) + xstart);
b = round((yPoints/2) + ystart);

w = xPoints;
h = yPoints;
theta = 0;
X = [-w/2 w/2 w/2 -w/2 -w/2];
Y = [h/2 h/2 -h/2 -h/2 h/2];
P = [X;Y];
ct = cos(theta);
st = sin(theta);
R = [ct -st;st ct];
P = R * P;
hold on
plot(P(1,:)+a,P(2,:)+b,'r-');

PolyXC_b4 = P(1,:) + a;
PolyYC_b4 = P(2,:) + b;

wholePolymask_b4 = poly2mask(PolyXC_b4,PolyYC_b4,dim1,dim2);

% Get values for thresholded image
greenMeasure2_b4 = greenN;
greenMeasure2_b4(~wholePolymask_b4) = 0;
grArea_b4 = bwarea(greenMeasure2_b4);

pxGr_b4 = grArea_b4/allArea;

% Get values for thresholded image

redMeasure2_b4 = redN;
redMeasure2_b4(~wholePolymask_b4) = 0;
redArea_b4 = bwarea(redMeasure2_b4);

pxRd_b4 = redArea_b4/allArea;

%

xPoints = 770;
yPoints = 330;

xstart = 340;
ystart = 1920;

a = round((xPoints/2) + xstart);
b = round((yPoints/2) + ystart);

w = xPoints;
h = yPoints;
theta = 0;
X = [-w/2 w/2 w/2 -w/2 -w/2];
Y = [h/2 h/2 -h/2 -h/2 h/2];
P = [X;Y];
ct = cos(theta);
st = sin(theta);
R = [ct -st;st ct];
P = R * P;
hold on
plot(P(1,:)+a,P(2,:)+b,'r-');

PolyXC_b5 = P(1,:) + a;
PolyYC_b5 = P(2,:) + b;

wholePolymask_b5 = poly2mask(PolyXC_b5,PolyYC_b5,dim1,dim2);

% Get values for thresholded image
greenMeasure2_b5 = greenN;
greenMeasure2_b5(~wholePolymask_b5) = 0;
grArea_b5 = bwarea(greenMeasure2_b5);

pxGr_b5 = grArea_b5/allArea;

% Get values for thresholded image

redMeasure2_b5 = redN;
redMeasure2_b5(~wholePolymask_b5) = 0;
redArea_b5 = bwarea(redMeasure2_b5);

pxRd_b5 = redArea_b5/allArea;

%

%%%%%%

xPoints = 770;
yPoints = 330;

xstart = 320;
ystart = 2250;

a = round((xPoints/2) + xstart);
b = round((yPoints/2) + ystart);

w = xPoints;
h = yPoints;
theta = 0;
X = [-w/2 w/2 w/2 -w/2 -w/2];
Y = [h/2 h/2 -h/2 -h/2 h/2];
P = [X;Y];
ct = cos(theta);
st = sin(theta);
R = [ct -st;st ct];
P = R * P;
hold on
plot(P(1,:)+a,P(2,:)+b,'r-');

PolyXC_b6 = P(1,:) + a;
PolyYC_b6 = P(2,:) + b;

wholePolymask_b6 = poly2mask(PolyXC_b6,PolyYC_b6,dim1,dim2);

% Threshold entire image

% Get values for thresholded image
greenMeasure2_b6 = greenN;
greenMeasure2_b6(~wholePolymask_b6) = 0;
grArea_b6 = bwarea(greenMeasure2_b6);

pxGr_b6 = grArea_b6/allArea;

% Get values for thresholded image

redMeasure2_b6 = redN;
redMeasure2_b6(~wholePolymask_b6) = 0;
redArea_b6 = bwarea(redMeasure2_b6);

pxRd_b6 = redArea_b6/allArea;


%% Compute threshold and show remaining values
% close all
% xCoords = P(1,:)+a;
% yCoords = P(2,:)+b;
% 
% wholePolymask = poly2mask(xCoords,yCoords,dim1,dim2); % Get mask
% 
% imshow(wholePolymask)

[level,em] = graythresh(image2invert);
BW = im2bw(image2invert,level);

image2invert3 = image2invert;
image2invert3(~BW) = 0;

im2dB = im2double(image2invert3);

pixelInfoGr = regionprops(wholePolymask,im2dB,'MeanIntensity','MaxIntensity','PixelValues','Area');


%%

polyAREA = dim1*dim2;

% Copy original image
image2thresh = image2invert3;
% Exclude all pixels outside polygon
image2thresh(~wholePolymask) = 0;

imshow(image2thresh);

%%
close all
% Create image with pixels above threshold
binaryImage = BW;
binaryImage(~wholePolymask) = 0;
imshow(binaryImage);




%%

densityArea = round(bwarea(binaryImage));
% Calculate fraction of area occupied by pixels above threshold
fracDenArea = pixelInfoGr.Area/polyAREA



%%





%%



