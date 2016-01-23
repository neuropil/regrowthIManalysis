[dim1,dim2,~] = size(imtest)
512*0.8
[dim1,dim2,~] = size(imtest);
xPoints = ceil(dim1*0.8);
yPoints = ceil(dim2*0.2);
start = dim1 - xPoints
ystart = dim2 - yPoints
imtest = imread('NI2 15-0528 10X.tif');
imshow(imtest)
[dim1,dim2,~] = size(imtest);
xPoints = ceil(dim1*0.8);
yPoints = ceil(dim2*0.2);
hBox = imrect(gca, [10, 10, xPoints,yPoints] )
roiPosition = wait(hBox);
delete(hBox);
xCoords = [roiPosition(1), roiPosition(1)+roiPosition(3), roiPosition(1)+roiPosition(3), roiPosition(1), roiPosition(1)];
yCoords = [roiPosition(2), roiPosition(2), roiPosition(2)+roiPosition(4), roiPosition(2)+roiPosition(4), roiPosition(2)];
hold on;
plot(xCoords, yCoords, 'Color','r', 'linewidth', 2);
xCoords = [xstart, xstart + xPoints, xstart + xPoints, xstart, xstart]
clc
clear