function results = RunAllTests()
%RUNALLTESTS Execute all MATLAB unit tests for the Cooling-Law repository.

scriptDir = fileparts(mfilename('fullpath'));
projectRoot = fileparts(scriptDir);
srcPath = fullfile(projectRoot, 'src');
testsPath = fullfile(projectRoot, 'tests');

addpath(srcPath);
addpath(testsPath);

suite = testsuite(testsPath, 'IncludeSubfolders', true);
runner = matlab.unittest.TestRunner.withTextOutput();
results = runner.run(suite);
assertSuccess(results);
end
