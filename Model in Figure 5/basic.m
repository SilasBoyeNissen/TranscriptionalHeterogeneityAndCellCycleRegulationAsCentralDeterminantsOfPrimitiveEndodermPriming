clc; clear; close all;

PARAM = [17 8 30 0.5 1 0.1; ... % D G N s1 s2 t
         17 7 30 1   1 0.1; ...
    17 8 60 0.73*0.8 0.83*0.95 0.12];

for p = 1:size(PARAM, 1)
    rng(1);
    D = PARAM(p, 1); % division time in hours
    G = PARAM(p, 2); % number of generations to run
    N = PARAM(p, 3); % number of cells in generation 1
    s_1 = PARAM(p, 4); % survival rate for cell type 1
    s_2 = PARAM(p, 5); % survival rate for cell type 2
    t_12 = PARAM(p, 6); % transition rate from cell type 1 to cell type 2
    F = zeros(0, 6);
    for k = 1:N
        S = [1 1 0 0]; % ID; Generation; Cell type; Parent
        i = 2;
        for g = 1:G
            c = S(S(:, 2) == g, :);
            for j = sort([1:size(c, 1) 1:size(c, 1)])
                if rand() > s_1 && c(j, 3) == 0
                elseif rand() > s_2 && c(j, 3) == 1
                else
                    if c(j, 3) == 0 && rand() < t_12
                        S(end+1, :) = [i g+1 1 c(j, 1)];
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
    
    stat = zeros(G-1, 4);
    for g = 1:G-1
        stat(g, 1:3) = [g size(F(F(:, 2) == g, 1), 1) sum(F(F(:, 2) == g, 3))];
        stat(g, 4) = stat(g, 2) - stat(g, 3);
    end
    
    figure(1); clf;
    set(figure(1), 'color', 'w');
    plot(stat(:, 1)*D/24+0.25, stat(:, 4), '--b.', 'LineWidth', 2, 'MarkerSize', 50, 'MarkerEdgeColor', [0  0.4470 0.7410], 'MarkerFaceColor', [0  0.4470 0.7410]); hold on;
    plot(stat(:, 1)*D/24+0.25, stat(:, 3), '--rs', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor', [0.85 0.325 0.098], 'MarkerFaceColor', [0.85 0.325 0.098]);
    set(gca, 'Box', 'on', 'FontSize', 20, 'YTick', 0:100:600);
    xlabel('Days');
    ylabel('Cell count');
    axis([.4 8*D/24 0 600]);
    title(['N = ' num2str(N) '; t_{12} = ' num2str(t_12) '; s_1 = ' num2str(round(s_1, 2)) '; s_2 = ' num2str(round(s_2, 2))])
    f = gcf; f.PaperSize = [f.PaperPosition(3) f.PaperPosition(4)];
    print(['_PDF/N=' num2str(N) ' t=' num2str(t_12) ' s1=' num2str(round(s_1, 2)) ' s2=' num2str(round(s_2, 2)) '.pdf'], '-dpdf');
    saveas(figure(1), ['_PNG/N=' num2str(N) ' t=' num2str(t_12) ' s1=' num2str(round(s_1, 2)) ' s2=' num2str(round(s_2, 2)) '.png']);
    writetable(array2table(stat, 'VariableNames', {'Generation', '#TotalCells', '#CellType1', '#CellType2'}), ['_XLS/N=' num2str(N) ' t=' num2str(t_12) ' s1=' num2str(round(s_1, 2)) ' s2=' num2str(round(s_2, 2)) '.xls']);
end