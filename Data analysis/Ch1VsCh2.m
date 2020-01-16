function Ch1VsCh2(SA)
for j = 1:3
    figure(3); clf;
    ss = SA((SA(:, 1) == j) + (SA(:, 18) == 2) == 2, :);
    tightsubplot(1, 1, [0 0], [0.1 0.02], [0.11 0.03]);
    set(figure(3), 'color', 'w', 'Position', [0, 0, 600, 600]);
    scatter(ss(ss(:, 6) == 1, 14), ss(ss(:, 6) == 1, 15), 70, 'filled'); hold on;
    scatter(ss(ss(:, 6) == 2, 14), ss(ss(:, 6) == 2, 15), 70, 'filled');
    set(gca, 'FontSize', 20, 'XTick', 0:0.2:0.8, 'YTick', 0:0.2:0.8);
    axis([0 0.8 0 0.8]);
    box('on');
    xlabel('Ch1', 'FontWeight', 'bold');
    ylabel('Ch2', 'FontWeight', 'bold');
    f = gcf; f.PaperSize = [f.PaperPosition(3) f.PaperPosition(4)];
    print(['_Results/Ch1VsCh2' num2str(j) '.pdf'], '-dpdf');
end