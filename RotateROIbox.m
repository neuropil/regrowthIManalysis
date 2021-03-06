imtest = imread('NI2 15-0528 10X.tif');
imshow(imtest)


[dim1,dim2,~] = size(imtest);

xPoints = ceil(dim1*0.8);
yPoints = ceil(dim2*0.2);

xstart = ceil((dim1 - xPoints)/2);
ystart = ceil(dim2/2);

% hBox = imrect(gca, [xstart, ystart, xPoints,yPoints] );

% x 254, y 302

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


xCoords = P(1,:)+a;
yCoords = P(2,:)+b;

ptest = poly2mask(xCoords,yCoords,dim1,dim2);

%%


%
% roiPosition = wait(hBox);
% delete(hBox);   
xCoords = [xstart, xstart + xPoints, xstart + xPoints, xstart, xstart];
yCoords = [ystart, ystart, ystart+yPoints, ystart+yPoints, ystart];
% Plot the mask as an outline over the image.
hold on;
plot(xCoords, yCoords, 'Color','r', 'linewidth', 2);



vertices = [xCoords; yCoords]'

rotationAngle = 10 * pi/100

rotationArray = [cos(rotationAngle), -sin(rotationAngle); sin(rotationAngle), cos(rotationAngle)];
	
% Rotate the diagram
rotatedArray = vertices * rotationArray;


% Plot the mask as an outline over the image.
hold on;
plot(rotatedArray(:,1), rotatedArray(:,2), 'Color','r', 'linewidth', 2);