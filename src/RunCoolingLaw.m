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

showOutput = false;
if isfield(config, 'verbose')
    showOutput = logical(config.verbose);
end

err = EstimateError(config.numIntervals, timeDisc, tempExactFn, tempNum, false);

tempFinalExact = tempExactFn(config.tMax);
tempFinalNum = tempNum(end);

summary = struct();
summary.numIntervals = config.numIntervals;
summary.timeStart = config.tStart;
summary.timeEnd = config.tMax;
summary.tempInitial = config.tempInitial;
summary.tempFinalNumerical = tempFinalNum;
summary.tempFinalExact = tempFinalExact;
summary.errorRms = err;

if showOutput
    fprintf(['[RunCoolingLaw] N=%d, t=[%.6f, %.6f], T0=%.6f, ' ...
        'Tend_num=%.6f, Tend_exact=%.6f, RMS=%.6e\n'], ...
        summary.numIntervals, summary.timeStart, summary.timeEnd, ...
        summary.tempInitial, summary.tempFinalNumerical, ...
        summary.tempFinalExact, summary.errorRms);
end

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
result.summary = summary;
