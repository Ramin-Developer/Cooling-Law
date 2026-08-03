function [timeNum, TempNum] = DiffSol(k, TempAmb, Temp0, tStart, tMax, N)
%DIFFSOL Solve Newton's cooling ODE using a central-difference discretization.

validateattributes(N, {'numeric'}, {'scalar', 'real', 'finite', 'integer', '>=', 2}, mfilename, 'N');
validateattributes(k, {'numeric'}, {'scalar', 'real', 'finite', 'positive'}, mfilename, 'k');
validateattributes(TempAmb, {'numeric'}, {'scalar', 'real', 'finite'}, mfilename, 'TempAmb');
validateattributes(Temp0, {'numeric'}, {'scalar', 'real', 'finite'}, mfilename, 'Temp0');
validateattributes(tStart, {'numeric'}, {'scalar', 'real', 'finite'}, mfilename, 'tStart');
validateattributes(tMax, {'numeric'}, {'scalar', 'real', 'finite', '>', tStart}, mfilename, 'tMax');

timeNum = linspace(tStart, tMax, N + 1)';
h = timeNum(2) - timeNum(1);

% Main, first upper and first lower diagonals
mainDiag = 2*k*h * ones(N, 1);
mainDiag(end) = 2*(1 + k*h);
firstUpper = zeros(N, 1);
firstUpper(1:N - 1) = 1;
firstLower = zeros(N, 1);
firstLower(2:N) = -1;
firstLower(end) = -2;

% Setup sparse tridiagonal coefficient matrix.
A = spdiags([firstLower, mainDiag, firstUpper], [-1, 0, 1], N, N);

% Setup right hand side
b = 2*k*h*TempAmb * ones(N, 1);
b(1) = 2*k*h*TempAmb + Temp0;

% Solve the linear system and recover unknown temperatures.
TempNum = A\b;
TempNum = [Temp0; TempNum];

end
