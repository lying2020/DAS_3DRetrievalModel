function [best_solution,best_fit,iter] = mySa(solution,a,t0,tf,Markov)
% 模拟退化算法
% ===== 输入 ======%
% solution 初始解 
% a 温度衰减系数 0.99
% t0 初始温度 120
% tf 最终温度 1
% Markov 马尔科夫链长度 10000
% ====== 输出 =====%
% best_solution 最优解
% best_fit 最优解目标值
% iter 迭代次数
n = length(solution);
t = t0;
solution_new = solution;  % 初始解赋给最新的解
best_fit = Inf;   % 初始化最优适应度（最差的适应度）
fit = Inf;      %  初始化当前的适应度
best_solution = solution;  % 最优解
iter = 1;
% -----------------------迭代过程------------------------------------%
while t >= tf
    for j = 1:Markov
% -----------------------产生新解过程------------------------------------%
        %进行扰动,产生新的序列solution_new;
        if (rand < 0.7) % 概率小于0.7 采取交换两个数位置的方式产生新解
            ind1 = 0;  ind2 = 0;
            while(ind1 == ind2 && ind1 >= ind2)
                ind1 = ceil(rand*n);
                ind2 = ceil(rand*n);
            end
            temp = solution_new(ind1);
            solution_new(ind1) = solution_new(ind2);
            solution_new(ind2) = temp;
        else % 概率大于等于0.7 采取成组交换连续三个数位置的方式产生新解
            ind = zeros(3,1);
            L_ind = length(unique(ind));
            while (L_ind < 3)
                ind = ceil([rand*n rand*n rand*n]);
                L_ind = length(unique(ind));
            end
            ind0 = sort(ind);
            a1 = ind0(1);  b1 = ind0(2);  c1 = ind0(3);
            solution0 = solution_new;
            solution0(a1:a1+c1-b1-1) = solution_new(b1+1:c1);
            solution0(a1+c1-b1:c1) = solution_new(a1:b1);
            solution_new = solution0;
        end
% -----------------------计算适应度过程------------------------------------ %
        %计算适应度fit_new
        fit_new = myFitCal(solution_new);
% -----------------------解的更新过程------------------------------------ %
        if fit_new < fit 
            fit = fit_new;
            solution = solution_new;
            %对最优路线和距离更新
            if       fit_new < best_fit
                iter = iter + 1;
                best_fit = fit_new;
                best_solution = solution_new;
            end
        else
            if rand < exp(-(fit_new-fit)/t)
                solution = solution_new;
                fit = fit_new;
            end
        end
        solution_new = solution;
    end
    t = t*a; %降温
end
