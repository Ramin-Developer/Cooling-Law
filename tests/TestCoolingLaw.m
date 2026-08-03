classdef TestCoolingLaw < matlab.unittest.TestCase
    methods (TestMethodSetup)
        function addProjectRootToPath(~)
            thisFile = mfilename('fullpath');
            testDir = fileparts(thisFile);
            projectRoot = fileparts(testDir);
            addpath(fullfile(projectRoot, 'src'));
        end
    end

    methods (Test)
        function analyticalMatchesInitialCondition(testCase)
            config = GetDefaultCoolingConfig();
            [tempExactFn, tempAsymFn] = AnalyticalSol(config.k, config.tempAmbient, config.tempInitial);

            testCase.verifyEqual(tempExactFn(config.tStart), config.tempInitial, 'AbsTol', 1e-12);
            testCase.verifyEqual(tempAsymFn(config.tStart), config.tempAmbient, 'AbsTol', 1e-12);
        end

        function analyticalMatchesSelectedTimePoints(testCase)
            config = GetDefaultCoolingConfig();
            [tempExactFn, ~] = AnalyticalSol(config.k, config.tempAmbient, config.tempInitial);

            selectedTimes = [config.tStart; 5; 15; config.tMax];
            expectedTemps = config.tempAmbient + ...
                (config.tempInitial - config.tempAmbient) .* exp(-config.k .* selectedTimes);

            testCase.verifyEqual(tempExactFn(selectedTimes), expectedTemps, 'AbsTol', 1e-12);
        end

        function numericalOutputSizeAndBoundary(testCase)
            config = GetDefaultCoolingConfig();
            [timeDisc, tempNum] = DiffSol( ...
                config.k, config.tempAmbient, config.tempInitial, ...
                config.tStart, config.tMax, config.numIntervals);

            testCase.verifySize(timeDisc, [config.numIntervals + 1, 1]);
            testCase.verifySize(tempNum, [config.numIntervals + 1, 1]);
            testCase.verifyEqual(tempNum(1), config.tempInitial, 'AbsTol', 1e-12);
        end

        function numericalCoolingTrend(testCase)
            config = GetDefaultCoolingConfig();
            [~, tempNum] = DiffSol( ...
                config.k, config.tempAmbient, config.tempInitial, ...
                config.tStart, config.tMax, config.numIntervals);

            % For Temp0 > TempAmbient, sequence should be non-increasing.
            testCase.verifyGreaterThanOrEqual(0, max(diff(tempNum)));
        end

        function runCoolingLawContract(testCase)
            config = GetDefaultCoolingConfig();
            result = RunCoolingLaw(config);

            testCase.verifyTrue(isstruct(result));
            expectedFields = {'timeDisc', 'tempNum', 'tempExactFn', 'tempAsymFn', 'error', 'config', 'summary'};
            for i = 1:numel(expectedFields)
                testCase.verifyTrue(isfield(result, expectedFields{i}));
            end

            testCase.verifyTrue(isstruct(result.summary));
            expectedSummaryFields = {
                'numIntervals', 'timeStart', 'timeEnd', 'tempInitial', ...
                'tempFinalNumerical', 'tempFinalExact', 'errorRms'
            };
            for i = 1:numel(expectedSummaryFields)
                testCase.verifyTrue(isfield(result.summary, expectedSummaryFields{i}));
            end

            testCase.verifyEqual(result.summary.numIntervals, config.numIntervals);
            testCase.verifyEqual(result.summary.timeStart, config.tStart, 'AbsTol', 1e-12);
            testCase.verifyEqual(result.summary.timeEnd, config.tMax, 'AbsTol', 1e-12);
            testCase.verifyEqual(result.summary.tempInitial, config.tempInitial, 'AbsTol', 1e-12);
            testCase.verifyEqual(result.summary.errorRms, result.error, 'AbsTol', 1e-12);
            testCase.verifyGreaterThanOrEqual(result.error, 0);
        end

        function errorConvergenceTrend(testCase)
            configCoarse = GetDefaultCoolingConfig();
            configFine = GetDefaultCoolingConfig();
            configCoarse.numIntervals = 64;
            configFine.numIntervals = 128;

            coarse = RunCoolingLaw(configCoarse);
            fine = RunCoolingLaw(configFine);

            testCase.verifyLessThanOrEqual(fine.error, coarse.error);
        end

        function errorEstimatorSanity(testCase)
            config = GetDefaultCoolingConfig();
            [timeDisc, tempNum] = DiffSol( ...
                config.k, config.tempAmbient, config.tempInitial, ...
                config.tStart, config.tMax, config.numIntervals);
            [tempExactFn, ~] = AnalyticalSol(config.k, config.tempAmbient, config.tempInitial);

            perfectError = EstimateError(config.numIntervals, timeDisc, tempExactFn, tempExactFn(timeDisc));
            actualError = EstimateError(config.numIntervals, timeDisc, tempExactFn, tempNum);

            testCase.verifyEqual(perfectError, 0, 'AbsTol', 1e-12);
            testCase.verifyGreaterThan(actualError, 0);
        end

        function regressionSnapshotDefaultConfig(testCase)
            config = GetDefaultCoolingConfig();
            result = RunCoolingLaw(config);

            testCase.verifyEqual(result.timeDisc(end), 30.0, 'AbsTol', 1e-12);
            testCase.verifyEqual(result.tempExactFn(config.tMax), 40.865129256564877, 'AbsTol', 1e-12);
            testCase.verifyEqual(result.tempNum(end), 40.869881845160734, 'AbsTol', 1e-12);
            testCase.verifyEqual(result.error, 0.004085627279127, 'AbsTol', 1e-12);
        end
    end
end
