function [timeNum, TempNum] = DiffSol(k, TempAmb, Temp0, tStart, tMax, N)

timeNum = linspace(tStart, tMax, N + 1)';
h = timeNum(2) - timeNum(1);

% Main, first upper and first lower diagonals
mainDiag = 2*k*h * ones(N, 1);
mainDiag(end) = 2*(1 + k*h);
firstUpper = ones(N - 1, 1);
firstLower = -ones(N - 1, 1);
firstLower(end) = -2;

% Setup coefficient matrix
A = diag(mainDiag, 0) + diag(firstUpper, 1) + diag(firstLower, -1);

% Setup right hand side
b = 2*k*h*TempAmb * ones(N, 1);
b(1) = 2*k*h*TempAmb + Temp0;

% Solve the Eq. system and find unknown temperatures
TempNum = A\b;
TempNum = [Temp0; TempNum];

end
