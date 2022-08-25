function r = timeshift(r, TS)
xy = [0 0];
id = unique(r(:, 8));
ts = [TS{r(1, 2)} 200];
r(:, 15) = (1:size(r, 1))';
r(r(:, 8) == id(1), 11:12) = r(r(:, 8) == id(1), 6:7);
for i = 2:size(id, 1)
    t1 = r(r(:, 8) == id(i-1), :);
    t2 = r(r(:, 8) == id(i), :);
    [~, ia, ib] = intersect(t1(:, 3), t2(:, 3));
    if abs(ts(1) - id(i)) < 0.01
        xy = xy + mean(t2(ib, 6:7), 1)-mean(t1(ia, 6:7), 1);
        ts(1) = [];
    end
    r(r(:, 8) == id(i), 11:12) = r(r(:, 8) == id(i), 6:7) - xy;
end
r(:, 6:7) = r(:, 11:12);
id = unique(r(:, 3));
for i = 1:size(id, 1)
    ss = sortrows(r(r(:, 3) == id(i), :), 8);
	ss(:, 11:12) = [0 0; ss(2:end, 6:7) - ss(1:end-1, 6:7)];
    [~, ia, ib] = intersect(ss(:, 15), r(:, 15));
    r(ib, 11:12) = ss(ia, 11:12);
end
r(:, 13) = sqrt(r(:, 11).^2 + r(:, 12).^2);
r(:, 14) = r(:, 13)/(1/3);