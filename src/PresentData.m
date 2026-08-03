function PresentData(tStart, tMax, timeDisc, tempExactFn, tempNum, tempAsymFn)
%PRESENTDATA Plot analytical/numerical results and export comparison figure.

validateattributes(tStart, {'numeric'}, {'scalar', 'real', 'finite'}, mfilename, 'tStart');
validateattributes(tMax, {'numeric'}, {'scalar', 'real', 'finite', '>', tStart}, mfilename, 'tMax');
validateattributes(timeDisc, {'numeric'}, {'column', 'real', 'finite'}, mfilename, 'timeDisc');
validateattributes(tempNum, {'numeric'}, {'column', 'real', 'finite', 'numel', numel(timeDisc)}, mfilename, 'tempNum');
assert(isa(tempExactFn, 'function_handle'), 'PresentData:InvalidExactFunction', ...
    'tempExactFn must be a function handle.');
assert(isa(tempAsymFn, 'function_handle'), 'PresentData:InvalidAsymFunction', ...
    'tempAsymFn must be a function handle.');

noOfPlotPts = (tMax - tStart) * 2^6;
t = linspace(tStart, tMax, noOfPlotPts)';
tempAsymVals = tempAsymFn(t);
tempExactVals = tempExactFn(t);

% Initializing a new figure
hFig = figure();
set(hFig, 'Color', 'White');
set(hFig, 'Name', 'Newton''s Law of Cooling');
set(hFig, 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
plotSize = 32;
markerSize = 24;

% Plot the results;
hPlot = plot(t, tempExactVals, 'magenta', timeDisc, tempNum, 'blue', ...
    t, tempAsymVals, 'r--');

% Set legend
hLegend = legend('$T\left(t \right)$', '$\bar{T} \left( t\right)$', ...
    'Asymptotic Line');
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

% Export plot with graceful fallback when export_fig is unavailable.
if exist('export_fig', 'file') == 2
    export_fig Comparison.pdf -q101;
elseif exist('exportgraphics', 'file') == 2
    exportgraphics(gcf, 'Comparison.pdf', 'ContentType', 'vector');
else
    print(gcf, 'Comparison.pdf', '-dpdf');
end

