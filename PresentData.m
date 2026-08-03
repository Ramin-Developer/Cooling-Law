function PresentData(tStart, tMax, timeDisc, TempEx, TempNum, TempAsymp)

noOfPlotPts = (tMax - tStart) * 2^6;
t = linspace(tStart, tMax, noOfPlotPts)';
TAsymp = TempAsymp(t);
TempEx = TempEx(t);

% Initializing a new figure
hFig = figure();
set(hFig, 'Color', 'White');
set(hFig, 'Name', 'Newton''s Law of Cooling');
set (hFig, 'Units', 'normalized', 'Position', [0,0,1,1]);
plotSize = 32;
markerSize = 24;

% Plot the results;
hPlot = plot(t, TempEx, 'magenta', timeDisc, TempNum, 'blue', ...
    t, TAsymp, 'r--');

% Set legend
hLegend = legend('$T\left(t \right)$', '$\bar{T} \left( t\right)$', ...
    'Asymptotical Line');
set(hLegend, 'FontSize', plotSize, 'Interpreter', 'latex');

% Set font of axes data
set(gca, 'fontsize', plotSize);

% Set axes titles
handleX = get(gca, 'xlabel');
handleY = get(gca, 'ylabel');

set(handleX, 'string', 'Time, $\left( \textit{min} \right)$', ...
    'FontSize', plotSize, 'Interpreter', 'Latex');
set(handleY, 'string', 'Temperature, $\left( ^\circ C \right)$', ...
    'FontSize', plotSize, 'Interpreter', 'Latex');

% Set line width
set(hPlot(1), 'LineWidth', 2);
set(hPlot(2), 'LineStyle', 'None', 'Marker', '+', 'MarkerSize', markerSize);
set(hPlot(3), 'LineWidth', 2);
grid;

% Convert to pdf high quality
export_fig Comparison.pdf -q101;

