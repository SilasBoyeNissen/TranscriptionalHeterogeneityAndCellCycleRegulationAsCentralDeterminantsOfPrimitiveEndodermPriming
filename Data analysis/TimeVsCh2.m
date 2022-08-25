function TimeVsCh2(SA)
for i = 14:15
    for j = 1:3
        figure(3); clf;
        ss = SA((SA(:, 1) == j) + (SA(:, 18) == 2) == 2, :);
        tightsubplot(1, 1, [0 0], [0.1 0.02], [0.11 0.03]);
        set(figure(3), 'color', 'w', 'Position', [0, 0, 600, 600]);
        scatter(ss(ss(:, 6) == 1, i), mean(ss(ss(:, 6) == 1, 11:12), 2), 70, [0  0.4470 0.7410], 'filled'); hold on;
        scatter(ss(ss(:, 6) == 2, i), mean(ss(ss(:, 6) == 2, 11:12), 2), 70, [0.85 0.325 0.098], 'filled');
        set(gca, 'FontSize', 20, 'XTick', 0:0.2:0.8, 'YTick', 0:48:144);
        ylabel('Time [h]', 'FontWeight', 'bold');
        axis([0 0.8 0 144]);
        box('on');
        f = gcf; f.PaperSize = [f.PaperPosition(3) f.PaperPosition(4)];
        if i == 14
            xlabel('Ch1', 'FontWeight', 'bold');
            print(['_Results/TimeVsCh1' num2str(j) '.pdf'], '-dpdf');
        elseif i == 15
            xlabel('Ch2', 'FontWeight', 'bold');
            print(['_Results/TimeVsCh2' num2str(j) '.pdf'], '-dpdf');
        end
    end
end