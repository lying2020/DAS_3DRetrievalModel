function [layerCoeffModel, layerCoeffModel_zdomain] = fitting_tanyan(layerGridModel)
%% ----------
%  input  layerGridModel griddata
%
%  output  layerCoeffModel  
%           [row,col] = size(xMat) row*col
%           cell 1*10 --- x^3,x^2*y, x*y^2,y^3,x^2,x*y,y^2,x,y,1
%     
%           layerCoeffModel_zdomain [minz,maxz]  [minz maxz].

numlayer = size(layerGridModel,1);
layerCoeffModel = cell(numlayer,1);
layerCoeffModel_zdomain = cell(numlayer,1);
for ilayer = 1:numlayer
    xMat = layerGridModel{ilayer,1};
    %yMat = layerGridModel{ilayer,2};
    zMat = layerGridModel{ilayer,3};
    inter = xMat(1,2)-xMat(1,1);
    
    %% 
    [row,col] = size(xMat);
    fitdata = zeros(row+2,col+2);
    for i = 2:row+1
        for j = 2:col+1
            fitdata(i,j) = zMat(i-1,j-1);
        end
    end
    for j = 2:col+1
        fitdata(1,j) = 2* fitdata(2,j) - fitdata(3,j);
        fitdata(row+2,j) = 2* fitdata(row+1,j) - fitdata(row,j);
    end
    for i = 1:row+2
        fitdata(i,1) = 2* fitdata(i,2) - fitdata(i,3);
        fitdata(i,col+2) = 2* fitdata(i,col+1) - fitdata(i,col);
    end

    %% 
    clear coeff;
    clear zdomain;
    coeff = cell(row-1,col-1);
    zdomain = cell(row-1,col-1);
    for i = 2:row
        for j = 2:col
            coeff{i-1,j-1} = thirdfit([fitdata(i-1,j-1) fitdata(i-1,j) fitdata(i-1,j+1) fitdata(i-1,j+2);
                                       fitdata(i,j-1)   fitdata(i,j)   fitdata(i,j+1)   fitdata(i,j+2);
                                       fitdata(i+1,j-1) fitdata(i+1,j) fitdata(i+1,j+1) fitdata(i+1,j+2);
                                       fitdata(i+2,j-1) fitdata(i+2,j) fitdata(i+2,j+1) fitdata(i+2,j+2)]',...
                                       inter);
%             func = @(x) coeff{i-1,j-1}(1) * x(1)*x(1)*x(1) + coeff{i-1,j-1}(2) * x(1)*x(1)*x(2) + ...
%                         coeff{i-1,j-1}(3) * x(1)*x(2)*x(2) + coeff{i-1,j-1}(4) * x(2)*x(2)*x(2) +...
%                         coeff{i-1,j-1}(5) * x(1)*x(1)      + coeff{i-1,j-1}(6) * x(1)*x(2)      +  coeff{i-1,j-1}(7) * x(2)*x(2) + ...
%                         coeff{i-1,j-1}(8) * x(1)           + coeff{i-1,j-1}(9) * x(2)           +  coeff{i-1,j-1}(10) * 1; 
                    %             options = optimoptions('ga','ConstraintTolerance',1e-3,'Display','off');
                    %             [~,minz] = ga(func,2,[],[],[],[],[-inter/2,-inter/2],[inter/2,inter/2],[],options);
                    %             funcn = @(x) -func(x);
                    %             [~,maxz] = ga(funcn,2,[],[],[],[],[-inter/2,-inter/2],[inter/2,inter/2],[],options);
                    %             maxz = -maxz;
                    minz = min([fitdata(i,j) fitdata(i,j+1) fitdata(i+1,j) fitdata(i+1,j+1)]);
                    maxz = max([fitdata(i,j) fitdata(i,j+1) fitdata(i+1,j) fitdata(i+1,j+1)]);                   
                    zdomain{i-1,j-1} = [minz maxz];  %
        end
    end
    layerCoeffModel{ilayer,1} = coeff;
    layerCoeffModel_zdomain{ilayer,1} = zdomain;
end
end