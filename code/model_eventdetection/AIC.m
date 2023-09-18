%
%
%
% -----------------------------------------------------------------------------------------------------
% Author: liying
% Tel: 15682070575
% Email: lying2017@126.com
% log:
% 2020-10-14: Modify the description and comments
% 2020-11-08: debug and comment
% this code is used to analyze the local minimum of the strain rate of the signal
%% -----------------------------------------------------------------------------------------------------
function [idxArray, aicMat] = AIC(partStrainMat)
% -----------------------------------------------------------------------------------------------------
% INPUT:
% partStrainMat: numSensor* m matrix, part of the strain signal.
%
% OUTPUT:
% idx: numSensor*1, the index of the local minimum of the variance of the signal under the AIC criterion
% aicMat: var  variance
%
% -----------------------------------------------------------------------------------------------------
tic
[numSensor, N] = size(partStrainMat);
% 
partStrainMat2 = partStrainMat.^2;
Fx1 = partStrainMat(:, 1);
Fx2 = partStrainMat2(:, 1);
Lx1 = sum(partStrainMat(:, 2:end), 2)./(N - 1);
Lx2 = sum(partStrainMat2(:, 2:end), 2)./(N - 1);
%% 
aicMat = zeros(numSensor, N-1);
% Dx = E(x^2) - E(x)^2;
% 
 aicMat(:, 1) = (N-2)*log(var(partStrainMat(:, 2:N), 0, 2));
% -----------------------------------------------------------------------------------------------------
for k = 2:(N -2)  % idx = idx + 1
    Fx1 = (1/k) *( (k-1).* Fx1 + partStrainMat(:, k) );
    Fx2 = (1/k) *( (k-1).* Fx2 + partStrainMat2(:, k));
    Lx1 = (1/(N - k)) *((N - k + 1).*Lx1 - partStrainMat(:, k));
    Lx2 = (1/(N - k)) *((N - k + 1).*Lx2 - partStrainMat2(:, k));
    %  aic(:, k - 1) = k.*log(k/(k-1).*(Fx2 - Fx1.^2)) + (N - k - 1).* log((N - k + 1)/(N - k).*(Lx2 - Lx1.^2));
    v1 = k/(k-1).*(Fx2 - Fx1.^2);
    v2 = (N - k + 1)/(N - k).*(Lx2 - Lx1.^2); 
    aicMat(:, k) = k.*log(v1) +(N - k - 1).* log(v2);
    % -----------------------------------------------------------------------------------------------------
    %  aicMat(:, k) = k.*log(var(partStrain(:, 1:k), 0, 2)) + (N - k - 1).*log(var(partStrainMat(:, (k + 1):N), 0, 2));
    %
end
 aicMat(:, N-1) = (N-1)*log(var(partStrainMat(:, 1:N-1), 0, 2));
%% the min number is our aim value    
aicMat = real(aicMat);
[~, idxArray] = min(aicMat, [], 2);
% idxArray = idxArray + 1;
% 
%
%  aic1 = (N-2)*log(var(partStrainMat(:, 2:N), 0, 2));
%  aic2 = (N-1)*log(var(partStrainMat(:, 1:(N-1)), 0, 2));
 aic3 = N*log(var(partStrainMat(:, 1:N), 0, 2));
%  plot3D(axes(figure), aicMat);
% aicMat = [aic1, aicMat, aicMat(:, end), aic2];
% 
aicMat = [aicMat, aic3];
% -----------------------------------------------------------------------------------------------------



% if nargout > 2
%     timeFlag = toc;
%     info = ['# the cost of AIC is: ', num2str(timeFlag), ' s.' ];
%     displaytimelog(info);
% end

end     %  function [idx, aic, timeFlag] = AIC(partStrain)



