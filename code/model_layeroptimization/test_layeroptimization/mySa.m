function [best_solution,best_fit,iter] = mySa(solution,a,t0,tf,Markov)
% ģ���˻��㷨
% ===== ���� ======%
% solution ��ʼ�� 
% a �¶�˥��ϵ�� 0.99
% t0 ��ʼ�¶� 120
% tf �����¶� 1
% Markov ����Ʒ������� 10000
% ====== ��� =====%
% best_solution ���Ž�
% best_fit ���Ž�Ŀ��ֵ
% iter ��������
n = length(solution);
t = t0;
solution_new = solution;  % ��ʼ�⸳�����µĽ�
best_fit = Inf;   % ��ʼ��������Ӧ�ȣ�������Ӧ�ȣ�
fit = Inf;      %  ��ʼ����ǰ����Ӧ��
best_solution = solution;  % ���Ž�
iter = 1;
% -----------------------��������------------------------------------%
while t >= tf
    for j = 1:Markov
% -----------------------�����½����------------------------------------%
        %�����Ŷ�,�����µ�����solution_new;
        if (rand < 0.7) % ����С��0.7 ��ȡ����������λ�õķ�ʽ�����½�
            ind1 = 0;  ind2 = 0;
            while(ind1 == ind2 && ind1 >= ind2)
                ind1 = ceil(rand*n);
                ind2 = ceil(rand*n);
            end
            temp = solution_new(ind1);
            solution_new(ind1) = solution_new(ind2);
            solution_new(ind2) = temp;
        else % ���ʴ��ڵ���0.7 ��ȡ���齻������������λ�õķ�ʽ�����½�
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
% -----------------------������Ӧ�ȹ���------------------------------------ %
        %������Ӧ��fit_new
        fit_new = myFitCal(solution_new);
% -----------------------��ĸ��¹���------------------------------------ %
        if fit_new < fit 
            fit = fit_new;
            solution = solution_new;
            %������·�ߺ;������
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
    t = t*a; %����
end
