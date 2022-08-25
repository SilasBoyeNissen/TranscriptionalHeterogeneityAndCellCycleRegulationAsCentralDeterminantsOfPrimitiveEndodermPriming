clear; rng(2);

T = readtable('__Output XLS files/Single Cell data.xls');
Singlecelldata = table2array(T);

S1 = Singlecelldata(Singlecelldata(:, 1) == 1, 13);
S2 = Singlecelldata(Singlecelldata(:, 1) == 2, 13);
S1(S1 == 0) = [];
S2(S2 == 0) = [];

figure(1); clf;
histogram(S1, 0:2:50, 'Normalization', 'probability'); hold on;
histogram(S2, 0:2:50, 'Normalization', 'probability');
set(gca, 'FontSize', 20, 'XTick', 0:10:50, 'YTick', 0:0.1:0.4);

title('Raw data', 'FontSize', 20);
legend('NACL', 'NACL + PD03', 'FontSize', 20);
xlabel('Doubling time [h]', 'FontSize', 20);
ylabel('Normalized histogram', 'FontSize', 20);
axis([0 50 0 0.4]);

f = gcf; f.PaperSize = [f.PaperPosition(3) f.PaperPosition(4)];
print('_Results/DoublingRaw.pdf', '-dpdf');

[h, p] = kstest2(S1, S2);

m1 = bootstrp(100, @mean, S1);
m2 = bootstrp(100, @mean, S2);

[h, p] = kstest2(m1, m2);

figure(2); clf;
histogram(m1, 14:0.2:19, 'Normalization', 'probability'); hold on;
histogram(m2, 14:0.2:19, 'Normalization', 'probability');
set(gca, 'FontSize', 20, 'XTick', 14:1:19, 'YTick', 0:0.1:0.4);

title('Mean bootstrapped 100 times', 'FontSize', 20);
legend('NACL', 'NACL + PD03', 'FontSize', 20);
xlabel('Doubling time [h]', 'FontSize', 20);
ylabel('Normalized histogram', 'FontSize', 20);
axis([14 19 0 0.4]);

f = gcf; f.PaperSize = [f.PaperPosition(3) f.PaperPosition(4)];
print('_Results/DoublingBootstrapped.pdf', '-dpdf');

