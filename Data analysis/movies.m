function movies(r)
figure(1); clf;
t = unique(r(:, 8));
set(figure(1), 'Position', [600, 0, 600, 600]);
mov = VideoWriter(['_Movies/' num2str(r(1, 1)) '-' num2str(r(1, 2))], 'MPEG-4');
mov.FrameRate = 6;
open(mov);
for n = 1:2
    for i = 1:1:size(t, 1)
        clf;
        ss = r(r(:, 8) == t(i), :);
        tightsubplot(1, 1, [0 0], [0 0], [0 0]);
        text((min(r(:, 6)) + max(r(:, 6)))/2, max(r(:, 7))*0.97, ['Time = ' sprintf('%0.1f', t(i)) ' h'], 'FontSize', 20, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center'); hold on;
        for j = 1:size(ss, 1)
            if n == 1
                text(ss(j, 6), ss(j, 7), num2str(ss(j, 4)), 'Color', [ss(j, 10) 0 1-ss(j, 10)], 'FontSize', 14, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center');
            else
                if ss(j, 5) == 1
                    text(ss(j, 6), ss(j, 7), num2str(ss(j, 4)), 'Color', [0  0.4470 0.7410], 'FontSize', 14, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center');
                elseif ss(j, 5) == 2
                    text(ss(j, 6), ss(j, 7), num2str(ss(j, 4)), 'Color', [0.85 0.325 0.098], 'FontSize', 14, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center');
                end
            end
        end
        axis off;
        axis([min(r(:, 6)) max(r(:, 6)) min(r(:, 7)) max(r(:, 7))]);
        writeVideo(mov, getframe(gcf));
    end
end
close(mov);