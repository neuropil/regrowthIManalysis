function [ outCoords ] = cornerFind(yCor, ymax, xCor, xmax)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

orients = {'TL','BL','BR','TR'};

for oi = 1:4
    
    orientation = orients{oi};
    
    switch orientation
        
        case 'TL'
            outCoords.topLeft = (yCor < ymax*0.5 & xCor < xmax*0.5);
            yratio = 0.5;
            xratio = 0.5;
            
            if sum(outCoords.topLeft) ~= 1
                if sum(outCoords.topLeft) == 0
                    
                    while sum(outCoords.topLeft) ~= 1
                        yratio = yratio + 0.001;
                        yval = ymax*yratio;
                        xratio = xratio + 0.001;
                        xval = ymax*xratio;
                        if sum(yCor < yval) == 0
                            outCoords.topLeft = (yCor == min(yCor) & xCor < xval);
                        elseif sum(xCor < xval) == 0
                            outCoords.topLeft = (yCor < yval & xCor == min(xCor));
                        else
                            outCoords.topLeft = (yCor < yval & xCor < xval);
                        end
                        pause(0.05)
                    end
                    
                elseif sum(outCoords.topLeft) > 1 % too liberal
                    while sum(outCoords.topLeft) ~= 1
                        
                        yratio = yratio - 0.0001;
                        if yratio < 0
                            yratio = 0.5;
                        end
                        yval = ymax*yratio;
                        xratio = xratio - 0.0001;
                        if xratio < 0
                            xratio = 0.5;
                        end
                        xval = xmax*xratio;
                        if sum(yCor < yval) == 0
                            outCoords.topLeft = (yCor == min(yCor) & xCor < xval);
                        elseif sum(xCor < xval) == 0
                            outCoords.topLeft = (yCor < yval & xCor == min(xCor));
                        else
                            outCoords.topLeft = (yCor < yval & xCor < xval);
                        end
                    end
                end
            end
            
            
        case 'BL'
            outCoords.botLeft = (yCor > ymax*0.5 & xCor < xmax*0.5);
            yratio = 0.5;
            xratio = 0.5;
            
            if sum(outCoords.botLeft) ~= 1
                if sum(outCoords.botLeft) == 0 % too conservative
                    while sum(outCoords.botLeft) ~= 1
                        yratio = yratio - 0.001;
                        yval = ymax*yratio;
                        xratio = xratio + 0.001;
                        xval = ymax*xratio;
                        if sum(yCor > yval) == 0
                            outCoords.botLeft = (yCor == max(yCor) & xCor < xval);
                        elseif sum(xCor < xval) == 0
                            outCoords.botLeft = (yCor > yval & xCor == min(xCor));
                        else
                            outCoords.botLeft = (yCor > yval & xCor < xval);
                        end
                    end
                elseif sum(outCoords.botLeft) > 1 % too liberal
                    while sum(outCoords.botLeft) ~= 1
                        yratio = yratio + 0.001;
                        yval = ymax*yratio;
                        xratio = xratio - 0.001;
                        xval = ymax*xratio;
                        if sum(yCor > yval) == 0
                            outCoords.botLeft = (yCor == max(yCor) & xCor < xval);
                        elseif sum(xCor < xval) == 0
                            outCoords.botLeft = (yCor > yval & xCor == min(xCor));
                        else
                            outCoords.botLeft = (yCor > yval & xCor < xval);
                        end
                    end
                end
            end
            
            
            
        case 'BR'
            outCoords.botRight = (yCor > ymax*0.5 & xCor > xmax*0.5);
            yratio = 0.5;
            xratio = 0.5;
            
            brCount = 1;
            if sum(outCoords.botRight) ~= 1
                if sum(outCoords.botRight) == 0
                    while sum(outCoords.botRight) ~= 1 % too conservative
                        yratio = yratio - 0.001;
                        xratio = xratio - 0.001;
                        yval = ymax*yratio;
                        xval = xmax*xratio;
                        outCoords.botRight = (yCor > yval & xCor > xval);
                        brCount = brCount + 1;
                        if brCount > 1000;
                            warndlg('bottom right is an infinite loop')
                            break
                        end
                    end
                elseif sum(outCoords.botRight) > 1
                    while sum(outCoords.botRight) ~= 1 % too liberal
                        yratio = yratio + 0.0001;
                        yval = ymax*yratio;
                        xval = xmax*xratio;
                        
                        outCoords.botRight = (yCor > yval & xCor > xval);
                        outCoords.botRight = xCor == max(xCor(outCoords.botRight)) & yCor > yval;
                        
                        brCount = brCount + 1;
                        if brCount > 1000;
                            warndlg('bottom right is an infinite loop')
                            break
                        end
                    end
                end
            end
            
            
            
            
        case 'TR'
            outCoords.topRight = (yCor < ymax*0.5 & xCor > xmax*0.5);
            yratio = 0.5;
            xratio = 0.5;
            
            trCount = 1;
            if sum(outCoords.topRight) ~= 1
                if sum(outCoords.topRight) == 0
                    
                    if sum(yCor < ymax*0.5) == 0
                        
                        maxSortx = sort(xCor,'descend');
                        tri = 1;
                        while sum(outCoords.topRight) ~= 1 % too conservative
                            maxNow = maxSortx(1:tri);
                            xVals = ismember(xCor, maxNow);
                            yratio = yratio + 0.001;
                            yval = ymax*yratio;
                            outCoords.topRight = (xVals & yCor < yval);
                            tri = 1 + 1;
                            
                            if trCount > 1000;
                                warndlg('bottom right is an infinite loop')
                                break
                            end
                            trCount = trCount + 1;
                        end
                        
                    else
                        
                        while sum(outCoords.topRight) ~= 1 % too conservative
                            yratio = yratio + 0.001;
                            xratio = xratio - 0.001;
                            
                            yval = ymax*yratio;
                            xval = xmax*xratio;
                            
                            outCoords.topRight = (yCor < yval & xCor > xval);
                            
                            if trCount > 1000;
                                warndlg('bottom right is an infinite loop')
                                break
                            end
                            trCount = trCount + 1;
                        end
                        
                    end
                elseif sum(outCoords.topRight) > 1
                    
                    while sum(outCoords.topRight) ~= 1 % too liberal
                        yratio = yratio - 0.001;
                        xratio = xratio + 0.001;
                        
                        yval = ymax*yratio;
                        xval = xmax*xratio;
                        
                        outCoords.topRight = (yCor < yval & xCor > xval);
                        
                        if trCount > 1000;
                            warndlg('bottom right is an infinite loop')
                            break
                        end
                        trCount = trCount + 1;
                    end
                end
            end 
    end
end
























end

