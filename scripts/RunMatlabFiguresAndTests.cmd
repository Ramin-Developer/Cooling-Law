@echo off
"C:\Program Files\MATLAB\R2017a\bin\matlab.exe" -nosplash -wait -logfile matlab_run.log -r "try, addpath('scripts'); GenerateLatexFigures; run('scripts/RunAllTests.m'); catch ME, disp(getReport(ME,'extended','hyperlinks','off')); exit(1); end; exit(0);"
exit /b %ERRORLEVEL%
