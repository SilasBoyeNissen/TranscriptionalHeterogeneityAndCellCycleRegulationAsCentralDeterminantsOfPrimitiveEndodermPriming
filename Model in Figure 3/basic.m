clc; clear; close all;

G = 6;
A = 0;
D = 17;
N = 20;

PARAM = [0.1 0.1 0.2 0.5; ... % t_12 t_32 t2 t4
    0.1 0.5 0.3 1/3];

for p = 1:size(PARAM, 1)
    
    rng(1);
    t_12 = PARAM(p, 1);
    t_32 = PARAM(p, 2);
    t_2 = PARAM(p, 3);
    t_23 = PARAM(p, 4);
    
    F = zeros(0, 6);
    for k = 1:N
        if rand < 1/3
            S = [1 1 0 0]; % ID; Generation; Type; Parent
        else
            if rand < 0.5
                S = [1 1 1 0];
            else
                S = [1 1 2 0];
            end
        end
        i = 2;
        for g = 1:G
            c = S(S(:, 2) == g, :);
            for j = sort([1:size(c, 1) 1:size(c, 1)])
                if rand() > A
                    if c(j, 3) == 0 && rand() < t_12
                        S(end+1, :) = [i g+1 1 c(j, 1)];
                    elseif c(j, 3) == 2 && rand() < t_32
                        S(end+1, :) = [i g+1 1 c(j, 1)];
                    elseif c(j, 3) == 1 && rand() < t_2
                        if rand() > t_23
                            S(end+1, :) = [i g+1 0 c(j, 1)];
                        else
                            S(end+1, :) = [i g+1 2 c(j, 1)];
                        end
                    else
                        S(end+1, :) = [i g+1 c(j, 3) c(j, 1)];
                    end
                    i = i + 1;
                end
            end
        end
        S = calculate(S);
        S(S(:, 2) == G+1, :) = [];
        F = [F; S k*ones(size(S, 1), 1)];
    end
    
    stat = zeros(G-1, 5);
    for g = 1:G-1
        stat(g, :) = [g size(F(F(:, 2) == g, 1), 1) sum(F(F(:, 2) == g, 3) == 0) sum(F(F(:, 2) == g, 3) == 1) sum(F(F(:, 2) == g, 3) == 2)];
    end
    
    figure(1); clf;
    set(figure(1), 'color', 'w');
    plot(stat(:, 1)*D/24+0.35, stat(:, 5), '--b.', 'Color', [48  131  84]/255, 'LineWidth', 2, ...
        'MarkerSize', 50, 'MarkerEdgeColor', [48  131  84]/255, 'MarkerFaceColor', [48  131  84]/255); hold on;
    plot(stat(:, 1)*D/24+0.35, stat(:, 4), '--b.', 'Color', [149 200 130]/255, 'LineWidth', 2, ...
        'MarkerSize', 50, 'MarkerEdgeColor', [149 200 130]/255, 'MarkerFaceColor', [149 200 130]/255);
    plot(stat(:, 1)*D/24+0.35, stat(:, 3), '--rs', 'Color', [135 200 255]/255, 'LineWidth', 2, ...
        'MarkerSize', 15, 'MarkerEdgeColor', [135 200 255]/255, 'MarkerFaceColor', [135 200 255]/255);
    set(gca, 'Box', 'on', 'FontSize', 20, 'YTick', 0:50:150);
    xlabel('Days');
    ylabel('Cell count');
    title(['t_{12} = ' num2str(t_12) '; t_{32} = ' num2str(t_32) '; t_2 = ' num2str(t_2) '; t_{23} = ' num2str(round(t_23, 2))])
    axis([.4 G*D/24 0 150]);
    f = gcf; f.PaperSize = [f.PaperPosition(3) f.PaperPosition(4)];
    print(['_PDF/t12=' num2str(t_12) ' t32=' num2str(t_32) ' t2=' num2str(t_2) ' t23=' num2str(round(t_23, 2)) '.pdf'], '-dpdf');
    saveas(figure(1), ['_PNG/t12=' num2str(t_12) ' t32=' num2str(t_32) ' t2=' num2str(t_2) ' t23=' num2str(round(t_23, 2)) '.png']);
    writetable(array2table(stat, 'VariableNames', {'Generation', '#TotalCells', '#CellType1', '#CellType2', '#CellType3'}), ...
        ['_XLS/t12=' num2str(t_12) ' t32=' num2str(t_32) ' t3=' num2str(t_2) ' t4=' num2str(round(t_23, 2)) '.xls']);
    
    T = readtable('../Data output/Single Cell data.xls');
    Singlecelldata = table2array(T);
    Snacl = Singlecelldata(Singlecelldata(:, 1) == 1, [13 15]); % 1 for NACL
    Spd03 = Singlecelldata(Singlecelldata(:, 1) == 1, [13 15]); % 2 for PD03
    Snacl(Snacl(:, 1) == 0, :) = [];
    Spd03(Spd03(:, 1) == 0, :) = [];
    Snacl(Snacl(:, 2) < 0.1926, 3) = 1;
    Spd03(Spd03(:, 2) < 0.1926, 3) = 1;
    Snacl(Snacl(:, 2) > 0.2307, 3) = 3;
    Spd03(Spd03(:, 2) > 0.2307, 3) = 3;
    Snacl(Snacl(:, 3) == 0, 3) = 2;
    Spd03(Spd03(:, 3) == 0, 3) = 2;
    Snacl1 = Snacl(Snacl(:, 3) == 1, 1);
    Snacl2 = Snacl(Snacl(:, 3) == 2, 1);
    Snacl3 = Snacl(Snacl(:, 3) == 3, 1);
    Spd031 = Spd03(Spd03(:, 3) == 1, 1);
    Spd032 = Spd03(Spd03(:, 3) == 2, 1);
    Spd033 = Spd03(Spd03(:, 3) == 3, 1);
    
    if p == 1
        SnaclD = [randsample(Snacl1, stat(end, 3), 'true'); randsample(Snacl2, stat(end, 4), 'true'); randsample(Snacl3, stat(end, 5), 'true')];
    else
        Spd03D = [randsample(Spd031, stat(end, 3), 'true'); randsample(Spd032, stat(end, 4), 'true'); randsample(Spd033, stat(end, 5), 'true')];
    end
end

figure(2); clf;
histogram(SnaclD, 0:2:50, 'Normalization', 'probability'); hold on;
histogram(Spd03D, 0:2:50, 'Normalization', 'probability');
set(gca, 'FontSize', 20, 'XTick', 0:10:50, 'YTick', 0:0.1:0.4);
title('Raw data', 'FontSize', 20);
legend('NACL', 'NACL + PD03', 'FontSize', 20);
xlabel('Doubling time [h]', 'FontSize', 20);
ylabel('Normalized histogram', 'FontSize', 20);
axis([0 50 0 0.4]);

f = gcf; f.PaperSize = [f.PaperPosition(3) f.PaperPosition(4)];
print('../Results/DoublingModelRawNaclDiv.pdf', '-dpdf');

m1 = bootstrp(100, @mean, SnaclD);
m2 = bootstrp(100, @mean, Spd03D);

figure(3); clf;
histogram(m1, 14:0.2:19, 'Normalization', 'probability'); hold on;
histogram(m2, 14:0.2:19, 'Normalization', 'probability');
set(gca, 'FontSize', 20, 'XTick', 14:1:19, 'YTick', 0:0.1:0.4);
title('Mean bootstrapped 100 times', 'FontSize', 20);
legend('NACL', 'NACL + PD03', 'FontSize', 20);
xlabel('Doubling time [h]', 'FontSize', 20);
ylabel('Normalized histogram', 'FontSize', 20);
axis([14 19 0 0.4]);

f = gcf; f.PaperSize = [f.PaperPosition(3) f.PaperPosition(4)];
print('../Results/DoublingModelBootstrappedNaclDiv.pdf', '-dpdf');