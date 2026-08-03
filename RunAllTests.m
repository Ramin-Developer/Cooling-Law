function results = RunAllTests()
%RUNALLTESTS Execute all MATLAB unit tests for the Cooling-Law repository.

suite = testsuite('tests', 'IncludeSubfolders', true);
runner = matlab.unittest.TestRunner.withTextOutput();
results = runner.run(suite);
assertSuccess(results);
end
