function stats = RunPerformanceBenchmark()
%RUNPERFORMANCEBENCHMARK Measure solver runtime over increasing interval counts.
%
% Set COOLING_ENFORCE_PERF_THRESHOLDS=1 in the environment to enforce
% runtime thresholds as hard failures.

scriptDir = fileparts(mfilename('fullpath'));
projectRoot = fileparts(scriptDir);
addpath(fullfile(projectRoot, 'src'));

nValues = [128; 256; 512; 1024; 2048];
thresholdSeconds = [0.05; 0.08; 0.16; 0.40; 1.20];
repeats = 5;
warmups = 1;

enforceThresholds = strcmp(getenv('COOLING_ENFORCE_PERF_THRESHOLDS'), '1');

elapsedSeconds = zeros(numel(nValues), 1);

for i = 1:numel(nValues)
    cfg = GetDefaultCoolingConfig();
    cfg.numIntervals = nValues(i);
    cfg.enablePlot = false;
    cfg.verbose = false;

    for w = 1:warmups
        RunCoolingLaw(cfg); %#ok<NASGU>
    end

    t = tic;
    for r = 1:repeats
        RunCoolingLaw(cfg); %#ok<NASGU>
    end
    elapsedSeconds(i) = toc(t) / repeats;

    if enforceThresholds && elapsedSeconds(i) > thresholdSeconds(i)
        error('RunPerformanceBenchmark:ThresholdExceeded', ...
            'N=%d exceeded threshold: %.6fs > %.6fs', ...
            nValues(i), elapsedSeconds(i), thresholdSeconds(i));
    end
end

stats = table(nValues, elapsedSeconds, thresholdSeconds, ...
    'VariableNames', {'N', 'AvgSeconds', 'ThresholdSeconds'});

resultsDir = fullfile(projectRoot, 'test-results');
if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

resultsPath = fullfile(resultsDir, 'performance-benchmark.txt');
fid = fopen(resultsPath, 'w');
fprintf(fid, 'Cooling-Law performance benchmark\n');
fprintf(fid, 'repeats=%d, warmups=%d\n', repeats, warmups);
fprintf(fid, 'enforceThresholds=%d\n\n', enforceThresholds);
fprintf(fid, 'N\tAvgSeconds\tThresholdSeconds\n');
for i = 1:height(stats)
    fprintf(fid, '%d\t%.6f\t%.6f\n', stats.N(i), stats.AvgSeconds(i), stats.ThresholdSeconds(i));
end
fclose(fid);

disp(stats);
fprintf('Saved benchmark report: %s\n', resultsPath);
end
