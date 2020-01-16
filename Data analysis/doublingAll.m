function SA = doublingAll(SA)
if ismember(3, unique(SA(:, 1)))
    tak = 3;
else
    tak = max(SA(:, 1));
end
for i = 14:15
    for j = unique(SA(:, 1))'
        figure(3); clf;
        ss = SA((SA(:, 1) == j) + (SA(:, 18) == 2) == 2, :);
        tightsubplot(1, 1, [0 0], [0.1 0.02], [0.1 0.03]);
        set(figure(3), 'color', 'w', 'Position', [0, 0, 600, 600]);
        if i == 15 && j == tak %%% OBS: Changed from i == 15 && j == 3
            k = kmeans([(log10(ss(:, 15)) - min(log10(ss(:, 15))))/(max(log10(ss(:, 15))) - min(log10(ss(:, 15)))) (ss(:, 13) - min(ss(:, 13)))/(max(ss(:, 13)) - min(ss(:, 13)))], 3);
            k(k == k(1)) = 0; % 2, 'Distance', 'cosine'
            k(k ~= k(1)) = 1;
            scatter(ss(k == 0, 15), ss(k == 0, 13), 70, [0 0.4470 0.7410], 'filled'); hold on;
            scatter(ss(k == 1, 15), ss(k == 1, 13), 70, [0.8500 0.3250 0.0980], 'filled');
            [ia, ib] = ismember(SA(:, 4), ss(:, 4));
            SA(ia, 6) = k(ib(ib>0)) + 1;
        else
            scatter(ss(:, i), ss(:, 13), 70, [0 0.4470 0.7410], 'filled');
        end
        set(gca, 'FontSize', 20, 'XTick', 0:0.2:0.8, 'YTick', 0:12:60);
        ylabel('Doubling time [h]', 'FontWeight', 'bold');
        axis([0 0.8 0 60]);
        box('on');
        f = gcf; f.PaperSize = [f.PaperPosition(3) f.PaperPosition(4)];
        if i == 14
            xlabel('Ch1', 'FontWeight', 'bold');
            print(['_Results/DoublingVsCh1' num2str(j) '.pdf'], '-dpdf');
        elseif i == 15
            xlabel('Ch2', 'FontWeight', 'bold');
            print(['_Results/DoublingVsCh2' num2str(j) '.pdf'], '-dpdf');
        end
    end
end