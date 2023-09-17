


zRange = [34, 40];
startpoint = [0, 0, 0];
endpoint = [4, 5, 10];

zPoints = compute_z_range0(zRange, startpoint, endpoint);
disp(zPoints);


function [zMinPoint, zMaxPoint] = compute_z_range0(zRange, startpoint, endpoint)
    % Compute the z values for the given range on the line defined by startpoint and endpoint

    % Extract the zMin and zMax values from zRange
    zMin = zRange(1);
    zMax = zRange(2);
    
    % Compute the slope of the line
    zxSlope = (endpoint(1) - startpoint(1)) / (endpoint(3) - startpoint(3));
    zySlope = (endpoint(2) - startpoint(2)) / (endpoint(3) - startpoint(3));
    % Compute the x and y values for the zMin and zMax points on the line
    xMin = (zMin - startpoint(3)) * zxSlope + startpoint(1);
    yMin = (zMin - startpoint(3)) * zySlope + startpoint(2);

    xMax = (zMax - startpoint(3)) * zxSlope + startpoint(1);
    yMax = (zMax - startpoint(3)) * zySlope + startpoint(2);

    % Create the zMin and zMax points and Return
    zMinPoint = [xMin, yMin, zMin];
    zMaxPoint = [xMax, yMax, zMax];

end

