: GitSynch.cmd 
:: Emualates what Visual Studio does
:: 1st param is the comments for the commit, if ommitted , just does a git status to show whats changed
::
:: Andy Ball 1.00 8/7/2017 Base Version 
:: Andy Ball 1.01 30/11/2017 Add retry logic for when on a bad connection

:: Time to sleep between retrys
SET SLEEPTIMEms=3000
SET ERRORCODE=0
SET COUNTER=1
SET RETRYS=10

@echo off 
If !%1==! goto error 

git add *.*
git status
git commit -a -m %1


:loop
@echo.
@echo *** Trying iteration %COUNTER% of %RETRYS%
git push
SET ERRORCODE=%ERRORLEVEL%

IF %ERRORCODE%==0 goto cool
IF /I %COUNTER% GEQ %RETRYS% goto fail
SET /A COUNTER=%COUNTER% + 1
@echo *** Error is %ERRORCODE% sleeping %SLEEPTIMEms% ms
POWERSHELL "Start-Sleep -milliseconds %SLEEPTIMEms%"
goto loop

:cool
goto end

:error
@echo *** Usage : 
@echo     GitSynch "updated readme"
@echo.
@echo *** Current Git Status :
git status
goto end

:fail 
@echo.
@echo *** Failed to commit after %RETRYS% RETRYS

:end