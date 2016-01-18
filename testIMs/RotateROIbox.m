imtest = imread('NI2 15-0528 10X.tif');
imshow(imtest)


[dim1,dim2,~] = size(imtest);

xPoints = ceil(dim1*0.8);
yPoints = ceil(dim2*0.2);

xstart = ceil((dim1 - xPoints)/2);
ystart = ceil(dim2/2);

% hBox = imrect(gca, [xstart, ystart, xPoints,yPoints] );

%
% roiPosition = wait(hBox);
% delete(hBox);   
xCoords = [xstart, xstart + xPoints, xstart + xPoints, xstart, xstart];
yCoords = [ystart, ystart, ystart+yPoints, ystart+yPoints, ystart];
% Plot the mask as an outline over the image.
hold on;
plot(xCoords, yCoords, 'Color','r', 'linewidth', 2);



rotationArray = [cos(rotationAngle), -sin(rotationAngle); sin(rotationAngle), cos(rotationAngle)];
	
% Rotate the diagram
rotatedArray = vertices * rotationArray;