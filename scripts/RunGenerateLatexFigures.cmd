@echo off
set "MATLAB_CMD=%MATLAB_EXE%"
if "%MATLAB_CMD%"=="" set "MATLAB_CMD=matlab"

"%MATLAB_CMD%" -nosplash -wait -logfile matlab_figures.log -r "try, addpath('scripts'); GenerateLatexFigures; catch ME, disp(getReport(ME,'extended','hyperlinks','off')); exit(1); end; exit(0);"
exit /b %ERRORLEVEL%
