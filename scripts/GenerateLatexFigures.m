function GenerateLatexFigures()
%GENERATELATEXFIGURES Build publication figures used by the LaTeX report.

scriptDir = fileparts(mfilename('fullpath'));
projectRoot = fileparts(scriptDir);
addpath(fullfile(projectRoot, 'src'));

outputDir = fullfile(projectRoot, 'docs', 'latex', 'source', 'figures');
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

cfg = GetDefaultCoolingConfig();

createDiscretizationFigure(cfg, outputDir);
createTrajectoryConvergenceFigure(cfg, outputDir);
createEndpointConvergenceFigure(cfg, outputDir);

fprintf('Saved LaTeX figure assets to: %s\n', outputDir);
end

function createDiscretizationFigure(cfg, outputDir)
nA = 16;
nB = 64;

tA = linspace(cfg.tStart, cfg.tMax, nA + 1);
tB = linspace(cfg.tStart, cfg.tMax, nB + 1);

fig = figure('Color', 'w', 'Visible', 'off');
subplot(2, 1, 1);
plot(tA, zeros(size(tA)), 'o-', 'LineWidth', 1.2, 'MarkerSize', 4, 'Color', [0.00 0.45 0.74]);
hold on;
plot(tA([1 end]), [0 0], 's', 'MarkerSize', 7, 'LineWidth', 1.2, 'Color', [0.85 0.33 0.10]);
text(tA(1), 0.05, 't0', 'HorizontalAlignment', 'center', 'Interpreter', 'none');
text(tA(end), 0.05, 'tN', 'HorizontalAlignment', 'center', 'Interpreter', 'none');
for i = 2:4:nA
    text(tA(i), -0.06, sprintf('%d', i - 1), 'FontSize', 8, 'HorizontalAlignment', 'center');
end
xlabel('Time t (min)');
ylabel('Node marker');
title(sprintf('Uniform time-grid nodes (N = %d)', nA));
axis([cfg.tStart cfg.tMax -0.12 0.12]);
yticks([]);
grid on;

subplot(2, 1, 2);
plot(tB, zeros(size(tB)), '.', 'MarkerSize', 10, 'Color', [0.47 0.67 0.19]);
hold on;
plot(tB([1 end]), [0 0], 's', 'MarkerSize', 7, 'LineWidth', 1.2, 'Color', [0.49 0.18 0.56]);
xlabel('Time t (min)');
ylabel('Node marker');
title(sprintf('Refined time-grid nodes (N = %d)', nB));
axis([cfg.tStart cfg.tMax -0.12 0.12]);
yticks([]);
grid on;

print(fig, fullfile(outputDir, 'discretization_nodes.png'), '-dpng', '-r220');
close(fig);
end

function createTrajectoryConvergenceFigure(cfg, outputDir)
nValues = [16; 32; 64; 128];
colors = lines(numel(nValues));

[tempExactFn, ~] = AnalyticalSol(cfg.k, cfg.tempAmbient, cfg.tempInitial);
tDense = linspace(cfg.tStart, cfg.tMax, 500)';

fig = figure('Color', 'w', 'Visible', 'off');
plot(tDense, tempExactFn(tDense), 'k-', 'LineWidth', 1.6, 'DisplayName', 'Exact solution');
hold on;

for i = 1:numel(nValues)
    cfgLocal = cfg;
    cfgLocal.numIntervals = nValues(i);
    result = RunCoolingLaw(cfgLocal);
    plot(result.timeDisc, result.tempNum, 'o-', ...
        'Color', colors(i, :), ...
        'LineWidth', 1.0, ...
        'MarkerSize', 3, ...
        'DisplayName', sprintf('Numerical (N = %d)', nValues(i)));
end

xlabel('Time t (min)');
ylabel('Temperature T (degC)');
title('Solution trajectory convergence under grid refinement');
legend('Location', 'northeast');
grid on;

print(fig, fullfile(outputDir, 'trajectory_convergence.png'), '-dpng', '-r220');
close(fig);
end

function createEndpointConvergenceFigure(cfg, outputDir)
initialValues = [120; 250; 400];
nValues = [8; 16; 32; 64; 128; 256];

fig = figure('Color', 'w', 'Visible', 'off');

for j = 1:numel(initialValues)
    cfgInit = cfg;
    cfgInit.tempInitial = initialValues(j);

    [tempExactFn, ~] = AnalyticalSol(cfgInit.k, cfgInit.tempAmbient, cfgInit.tempInitial);
    endExact = tempExactFn(cfgInit.tMax);

    endNumerical = zeros(numel(nValues), 1);
    endAbsError = zeros(numel(nValues), 1);

    for i = 1:numel(nValues)
        cfgLocal = cfgInit;
        cfgLocal.numIntervals = nValues(i);
        result = RunCoolingLaw(cfgLocal);
        endNumerical(i) = result.tempNum(end);
        endAbsError(i) = abs(result.tempNum(end) - endExact);
    end

    subplot(3, 1, j);
    [axPair, hLeft, hRight] = plotyy(nValues, endNumerical, nValues, max(endAbsError, eps), @plot, @semilogy);
    set(hLeft, 'LineStyle', '-', 'Marker', 'o', 'LineWidth', 1.2, 'MarkerSize', 4, 'Color', [0.00 0.45 0.74]);
    set(hRight, 'LineStyle', '-', 'Marker', 's', 'LineWidth', 1.1, 'MarkerSize', 4, 'Color', [0.47 0.67 0.19]);
    set(axPair(1), 'YColor', [0.00 0.45 0.74]);
    set(axPair(2), 'YColor', [0.47 0.67 0.19]);

    axes(axPair(1));
    hold on;
    plot(nValues, endExact * ones(size(nValues)), '--', 'LineWidth', 1.2, 'Color', [0.85 0.33 0.10]);
    hold off;
    ylabel('Endpoint temperature T(tmax) (degC)', 'Interpreter', 'none');

    axes(axPair(2));
    ylabel('|TN(tmax) - T(tmax)|', 'Interpreter', 'none');

    axes(axPair(1));
    xlabel('Number of intervals N');
    title(sprintf('Endpoint convergence for T0 = %d degC', cfgInit.tempInitial), 'Interpreter', 'none');
    grid on;

    if j == 1
        legend(axPair(1), {'Numerical endpoint', 'Exact endpoint'}, 'Location', 'NorthEast');
        legend(axPair(2), {'Absolute endpoint error'}, 'Location', 'SouthWest');
    end
end

print(fig, fullfile(outputDir, 'endpoint_convergence_by_initial.png'), '-dpng', '-r220');
close(fig);
end
