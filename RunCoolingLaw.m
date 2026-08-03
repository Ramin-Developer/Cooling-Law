function result = RunCoolingLaw(config)
%RUNCOOLINGLAW Execute analytical and numerical cooling-law workflow.
%
% result fields:
% - timeDisc, tempNum
% - tempExactFn, tempAsymFn
% - error
% - config

if nargin == 0 || isempty(config)
    config = GetDefaultCoolingConfig();
end

validateattributes(config.k, {'numeric'}, {'scalar', 'real', 'finite', 'positive'}, ...
    mfilename, 'config.k');
validateattributes(config.tempAmbient, {'numeric'}, {'scalar', 'real', 'finite'}, ...
    mfilename, 'config.tempAmbient');
validateattributes(config.tempInitial, {'numeric'}, {'scalar', 'real', 'finite'}, ...
    mfilename, 'config.tempInitial');
validateattributes(config.tStart, {'numeric'}, {'scalar', 'real', 'finite'}, ...
    mfilename, 'config.tStart');
validateattributes(config.tMax, {'numeric'}, {'scalar', 'real', 'finite', '>', config.tStart}, ...
    mfilename, 'config.tMax');
validateattributes(config.numIntervals, {'numeric'}, {'scalar', 'real', 'finite', 'integer', '>=', 2}, ...
    mfilename, 'config.numIntervals');

[tempExactFn, tempAsymFn] = AnalyticalSol(config.k, config.tempAmbient, config.tempInitial);
[timeDisc, tempNum] = DiffSol( ...
    config.k, config.tempAmbient, config.tempInitial, ...
    config.tStart, config.tMax, config.numIntervals);
err = EstimateError(config.numIntervals, timeDisc, tempExactFn, tempNum);

if isfield(config, 'enablePlot') && config.enablePlot
    PresentData(config.tStart, config.tMax, timeDisc, tempExactFn, tempNum, tempAsymFn);
end

result = struct();
result.timeDisc = timeDisc;
result.tempNum = tempNum;
result.tempExactFn = tempExactFn;
result.tempAsymFn = tempAsymFn;
result.error = err;
result.config = config;
