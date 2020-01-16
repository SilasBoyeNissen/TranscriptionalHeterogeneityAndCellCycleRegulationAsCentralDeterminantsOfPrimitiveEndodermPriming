function lineage(r, s)
for n = 1:3
    figure(2); clf;
    tightsubplot(1, 1, [0 0], [0.07 0.01], [0.042 0.01]);
    set(figure(2), 'color', 'w', 'Position', [0, 0, 1600, 800]);
    par = unique(s(:, 5))';
    for i = par(2:end)
        dad = find(s(:, 4) == i);
        son = find(s(:, 5) == i)';
        v = min(s([dad son], 4)):0.01:max(s([dad son], 4));
        r(end+1:end+size(v, 2), :) = [ones(size(v, 2), 3) v' repmat([s(dad, 6) 1 1 s(dad, 12) mean(s([dad son], 14:15), 1) 1 1 1 1], size(v, 2), 1)];
    end
    if n == 1
        scatter(r(:, 4), r(:, 8), 50, [r(:, 10) zeros(size(r, 1), 1) 1-r(:, 10)], 'filled');
    elseif n == 2
        scatter(r(r(:, 5) == 1, 4), r(r(:, 5) == 1, 8), 50, [0  0.4470 0.7410], 'filled'); hold on;
        scatter(r(r(:, 5) == 2, 4), r(r(:, 5) == 2, 8), 50, [0.85 0.325 0.098], 'filled');
    else
        scatter(r(r(:, 10) <= 0.178, 4), r(r(:, 10) <= 0.178, 8), 50, [194 230 153]/255, 'filled'); hold on;
        scatter(r((r(:, 10) > 0.178) + (r(:, 10) <= 0.196) == 2, 4), r((r(:, 10) > 0.178) + (r(:, 10) <= 0.196) == 2, 8), 50, [120 198 121]/255, 'filled');
        scatter(r((r(:, 10) > 0.196) + (r(:, 10) <= 0.219) == 2, 4), r((r(:, 10) > 0.196) + (r(:, 10) <= 0.219) == 2, 8), 50, [49 163 84]/255, 'filled');
        scatter(r(r(:, 10) > 0.219, 4), r(r(:, 10) > 0.219, 8), 50, [0 104 55]/255, 'filled');
    end
    box('on');
    set(gca, 'FontSize', 20, 'Ydir', 'reverse', 'YTick', 0:24:max(r(:, 8)));
    xlabel('Cell ID', 'FontWeight', 'bold');
    ylabel('Time [h]', 'FontWeight', 'bold');
    axis([min(s(:, 4))-1 max(s(:, 4))+1 0 max(r(:, 8))]);
    f = gcf; f.PaperSize = [f.PaperPosition(3) f.PaperPosition(4)];
	print(['_Lineage tree ' num2str(n) '/' num2str(s(1, 1)) '-' num2str(s(1, 2)) '.pdf'], '-dpdf');
end