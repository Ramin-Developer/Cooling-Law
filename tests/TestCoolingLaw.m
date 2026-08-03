classdef TestCoolingLaw < matlab.unittest.TestCase
    methods (TestMethodSetup)
        function addProjectRootToPath(~)
            thisFile = mfilename('fullpath');
            testDir = fileparts(thisFile);
            projectRoot = fileparts(testDir);
            addpath(projectRoot);
        end
    end

    methods (Test)
        function analyticalMatchesInitialCondition(testCase)
            config = GetDefaultCoolingConfig();
            [tempExactFn, tempAsymFn] = AnalyticalSol(config.k, config.tempAmbient, config.tempInitial);

            testCase.verifyEqual(tempExactFn(config.tStart), config.tempInitial, 'AbsTol', 1e-12);
            testCase.verifyEqual(tempAsymFn(config.tStart), config.tempAmbient, 'AbsTol', 1e-12);
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
            expectedFields = {'timeDisc', 'tempNum', 'tempExactFn', 'tempAsymFn', 'error', 'config'};
            for i = 1:numel(expectedFields)
                testCase.verifyTrue(isfield(result, expectedFields{i}));
            end
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
    end
end
