clear; tic;

%% Input parameters (change as wished)
N = 1; % Initial number of cells of cell type 1
T = 0.12; % Transition rate from cell type 1 to 2
D1 = 17; % Doubling time of cell type 1 in hours
S1 = 0.6; % Survival rate of cell type 1
D = 0.5:0.1:2; % Doubling time of cell type 2 divided by doubling time of cell type 1
S = (0.5:0.1:2)'; % Survival rate of cell type 2 divided by survival rate of cell type 1

%% Perform calculations
figure(1); clf;
set(figure(1), 'color', 'w', 'Position', [0 0 1700 400]);
for x = 3:5 % Day to evaluate the experiment on
    RES = (N*2*S1*T*((S.*2*S1).^(1./D*24*(x-1)/D1) - (2*S1)^(24*(x-1)/D1)*(1-T)^(24*(x-1)/D1))./((S.*2*S1).^(1./D) + 2*S1*(T-1)))/(N*(2*S1)^(24*(x-1)/D1)*(1-T)^(24*(x-1)/D1));
    subplot(1, 3, x-2);
    contour(D, S, RES, [3 2 1 0.5], 'LineWidth', 3, 'ShowText', 'on'); hold on;
    set(gca, 'Box', 'on', 'FontSize', 20, 'LineWidth', 2);
    xlabel('d_2 / d_1');
    ylabel('s_2 / s_1');
    title(['N = ' num2str(N) '; T = ' num2str(T) '; d_1 = ' num2str(D1) 'h; s_1 = ' num2str(S1) '; On day ' num2str(x)]);
end

%% Save result
saveas(gcf, 'figure.png');
toc;