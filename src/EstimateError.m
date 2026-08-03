function error = EstimateError(N, timeDisc, tempExactFn, tempNum, showOutput)
%ESTIMATEERROR Compute RMS error of numerical solution vs exact values.

if nargin < 5
	showOutput = false;
end

validateattributes(N, {'numeric'}, {'scalar', 'real', 'finite', 'integer', '>=', 2}, mfilename, 'N');
validateattributes(timeDisc, {'numeric'}, {'column', 'real', 'finite', 'numel', N + 1}, mfilename, 'timeDisc');
validateattributes(tempNum, {'numeric'}, {'column', 'real', 'finite', 'numel', N + 1}, mfilename, 'tempNum');
validateattributes(showOutput, {'logical', 'numeric'}, {'scalar'}, mfilename, 'showOutput');

assert(isa(tempExactFn, 'function_handle'), ...
	'EstimateError:InvalidExactFunction', 'tempExactFn must be a function handle.');

tempExactForComp = tempExactFn(timeDisc);

% Calculate variance and standard deviation of the error:
errVariance = sum((tempExactForComp(2:end) - tempNum(2:end)).^2) / (N - 1);
error = sqrt(errVariance);

if logical(showOutput)
	sciFormat = '%10.5e';
	errorStr = num2str(error, sciFormat);
	fprintf('\nN =\t\t%d\nError =\t%s\n\n', N, errorStr);
end
