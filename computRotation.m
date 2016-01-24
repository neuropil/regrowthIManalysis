function Pout = computRotation(xPoints,yPoints,theta)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here




X = [-xPoints/2 xPoints/2 xPoints/2 -xPoints/2 -xPoints/2];
Y = [yPoints/2 yPoints/2 -yPoints/2 -yPoints/2 yPoints/2];
P = [X;Y];

ct = cos(theta);
st = sin(theta);

R = [ct -st;st ct];
Pout = R * P;













end

