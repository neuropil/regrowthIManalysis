imtest = imread('NI2 15-0528 10X.tif');

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
imshow(invertImInterest)

%% Plot box ROI

xPoints = ceil(dim1*0.8);
yPoints = ceil(dim2*0.2);

xstart = ceil((dim1 - xPoints)/2);
ystart = ceil(dim2/2);

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

%% Compute threshold and show remaining values
close all
xCoords = P(1,:)+a;
yCoords = P(2,:)+b;

wholePolymask = poly2mask(xCoords,yCoords,dim1,dim2); % Get mask

imshow(wholePolymask)

[level,em] = graythresh(image2invert);
BW = im2bw(image2invert,level);

image2invert3 = image2invert;
image2invert3(~BW) = 0;

im2dB = im2double(image2invert3);

pixelInfo = regionprops(wholePolymask,im2dB,'MeanIntensity','MaxIntensity','PixelValues','Area');


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
fracDenArea = pixelInfo.Area/polyAREA



%%





%%



