function doubling(ss)
for i = 14:15
    figure(3); clf;
    tightsubplot(1, 1, [0 0], [0.1 0.02], [0.1 0.03]);
    set(figure(3), 'color', 'w', 'Position', [0, 0, 600, 600]);
    scatter(ss(ss(:, 18) == 2, i), ss(ss(:, 18) == 2, 13), 100, 'filled');
    set(gca, 'FontSize', 20, 'XTick', 0:0.2:0.8, 'YTick', 0:12:60);
    ylabel('Doubling time [h]', 'FontWeight', 'bold');
    axis([0 0.8 0 60]);
    box('on');
    f = gcf; f.PaperSize = [f.PaperPosition(3) f.PaperPosition(4)];
    if i == 14
        xlabel('Ch1', 'FontWeight', 'bold');
        print(['_Doubling time/Ch1/' num2str(ss(1, 1)) '-' num2str(ss(1, 2)) '.pdf'], '-dpdf');
    elseif i == 15
        xlabel('Ch2', 'FontWeight', 'bold');
        print(['_Doubling time/Ch2/' num2str(ss(1, 1)) '-' num2str(ss(1, 2)) '.pdf'], '-dpdf');
    end
end