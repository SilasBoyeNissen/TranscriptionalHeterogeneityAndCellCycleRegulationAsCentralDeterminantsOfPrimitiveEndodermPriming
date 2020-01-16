function Ch2VsDisplacement(SA)
for i = 16:17
    for j = 1:3
        figure(3); clf;
        ss = SA((SA(:, 1) == j) + (SA(:, 18) == 2) == 2, :);
        tightsubplot(1, 1, [0 0], [0.1 0.02], [0.11 0.03]);
        set(figure(3), 'color', 'w', 'Position', [0, 0, 600, 600]);
        scatter(ss(ss(:, 6) == 1, i), ss(ss(:, 6) == 1, 15), 70, 'filled'); hold on;
        scatter(ss(ss(:, 6) == 2, i), ss(ss(:, 6) == 2, 15), 70, 'filled');
        set(gca, 'FontSize', 20, 'YTick', 0:0.2:0.8);
        box('on');
        ylabel('Ch2', 'FontWeight', 'bold');
        f = gcf; f.PaperSize = [f.PaperPosition(3) f.PaperPosition(4)];
        if i == 16
            axis([0 2000 0 0.8]);
            set(gca, 'XTick', 0:500:2000)
            xlabel('Displacement [µm]', 'FontWeight', 'bold');
            print(['_Results/Ch2VsDisplacement' num2str(j) '.pdf'], '-dpdf');
        else
            axis([0 200 0 0.8]);
            set(gca, 'XTick', 0:50:200)
            xlabel('Speed [µm/h]', 'FontWeight', 'bold');
            print(['_Results/Ch2VsSpeed' num2str(j) '.pdf'], '-dpdf');
        end
    end
end