@ECHO OFF& SETLOCAL ENABLEDELAYEDEXPANSION
MODE CON cols=100 lines=35
shutdown /A 2>NUL 1>&2
FOR /F %%A IN ('wmic.exe OS GET localdatetime^| findstr ^[0-9]') DO SET t0=%%A
SET Y0=%t0:~0,4%& SET M0=%t0:~4,2%& SET D0=%t0:~6,2%& SET H0=%t0:~8,2%& SET X0=%t0:~10,2%& SET C0=%t0:~12,2%
TITLE Miner-autorun(%Y0%.%M0%.%D0%_%H0%:%X0%:%C0%)
SET Version=1.6.9
:hardstart
CLS
COLOR 1F
ECHO ==================================================================
ECHO +----------------------------------------------------------------+
ECHO +          AutoRun for EWBF 0.3.4.b Miner - by Acrefawn          +
ECHO +                 acrefawn@gmail.com [v. %Version%]                  +
ECHO +                   Donation deposit address:                    +
ECHO +            ZEC: t1S8HRoMoyhBhwXq6zY5vHwqhd9MHSiHWKv            +
ECHO +             BTC: 1wdJBYkVromPoiYk82JfSGSSVVyFJnenB             +
ECHO +----------------------------------------------------------------+
ECHO ==================================================================
REM Attention. Change the options below only if it's really needed.
REM Amount of errors before computer restart (5 - default)
SET ErrorsAmount=5
REM Amount of hashrate errors before miner restart (5 - default)
SET HashrateErrorsAmount=5
REM Name miner process. (in English, without special symbols and spaces)
SET MinerProcess=miner.exe
REM Name miner log file. (in English, without special symbols and spaces)
SET MinerLog=miner.log
REM Check to see if %~n0.bat has already been started. (0 - false, 1 - true)
SET EnableDoubleWindowCheck=1
REM Attention. Do not touch the options below in any case.
IF "%PROCESSOR_ARCHITECTURE%" == "x86" IF NOT DEFINED PROCESSOR_ARCHITEW6432 ECHO Your OS Architecture is %PROCESSOR_ARCHITECTURE%. Only x64 required.& PAUSE & EXIT
IF %EnableDoubleWindowCheck% EQU 1 (
	FOR /F "delims=" %%z IN ('tasklist /V /NH /FI "imagename eq cmd.exe"^| findstr /V /R /C:".*Miner-autorun(%Y0%.%M0%.%D0%_%H0%:%X0%:%C0%)"^| findstr /R /C:".*Miner-autorun.*"') DO (
		ECHO Warning. This process is already running.&	ECHO The original process will continue, but this window will close in 10 seconds.
		CHOICE /C yn /T 10 /D y /M "Continue this process"
		IF ERRORLEVEL ==2 EXIT
	)
)
SET PTOS1=0
SET FirstRun=0
SET AllowSend=0
SET ServerQueue=0
SET MinHashrate=0
SET ErrorsCounter=0
SET SwitchToDefault=0
SET OtherErrorsList=/C:"ERROR:"
SET OtherWarningsList=/C:"WARNING:"
SET InternetErrorsCancel=/C:"Connection restored"
SET ErrorEcho=+ Unknown error.                                                 +
SET MinerWarningsList=/C:"Temperature limit are reached, gpu will be stopped"
SET CriticalErrorsList=/C:"Cannot initialize NVML. Temperature monitor will not work" /C:"no CUDA-capable device is detected"
SET MinerErrorsList=/C:"Thread exited" /C:" 0 Sol/s" /C:"Total speed: 0 Sol/s" /C:"benchmark error" /C:"Api bind error" /C:"CUDA error" /C:"Looks like "
SET InternetErrorsList=/C:"Lost connection" /C:"Cannot resolve hostname" /C:"Stratum subscribe timeout" /C:"Cannot connect to the pool" /C:"No properly configured pool"
SET Web=https://api.telegram.org/bot405371799:AAFq9-W91wg2vtDsuqHmSfZujNpStSDo3OE/sendMessage?parse_mode=markdown
:checkconfig
IF EXIST %~dp0config.bat (
	FOR /F "tokens=5 delims= " %%B IN ('findstr /C:"Configuration file v." config.bat') DO (
		IF "%%B" == "%Version%" (
			FOR %%C IN (config.bat) DO (
				IF %%~ZC LSS 4200 (
					ECHO Config.bat file error. It is corrupted, check it please.
				) ELSE (
					FOR %%z IN (%~n0.bat) DO IF %%~Zz LSS 50030 EXIT
					CALL config.bat && ECHO Config.bat loaded.
					GOTO prestart
				)
			)
		) ELSE (
			ECHO Your config.bat is out of date.
		)
		CHOICE /C yn /T 15 /D y /M "Backup existing and create an updated (default) config.bat"
		IF ERRORLEVEL ==2 EXIT
		MOVE /Y config.bat config_backup_%%B.bat >NUL && ECHO Created backup of your v. %%B config.bat.
	)
)
> config.bat ECHO @ECHO off
>> config.bat ECHO REM Configuration file v. %Version%
>> config.bat ECHO REM =================================================== [Overclock program]
>> config.bat ECHO REM Enable GPU Overclock control monitor. (0 - false, 1 - true XTREMEGE, 2 - true AFTERBURNER, 3 - true GPUTWEAK, 4 - true PRECISION, 5 - true AORUSGE)
>> config.bat ECHO REM Autorun and run-check of GPU Overclock programs.
>> config.bat ECHO SET EnableGPUOverclockMonitor=0
>> config.bat ECHO REM Additional option to auto-enable Overclock Profile for MSI Afterburner. (0 - false, 1 - Profile 1, 2 - Profile 2, 3 - Profile 3, 4 - Profile 4, 5 - Profile 5)
>> config.bat ECHO SET AutorunMSIAWithProfile=0
>> config.bat ECHO REM Allow Overclock programs to be restarted when miner is restarted. (0 - false, 1 - true)
>> config.bat ECHO REM Please, do not use this option if it is not needed.
>> config.bat ECHO SET RestartGPUOverclockMonitor=0
>> config.bat ECHO REM =================================================== [GPU]
>> config.bat ECHO REM Set how many GPU devices are enabled.
>> config.bat ECHO SET NumberOfGPUs=0
>> config.bat ECHO REM Allow computer restart if number of loaded GPUs is not equal to number of enabled GPUs. (0 - false, 1 - true)
>> config.bat ECHO SET AllowRestartGPU=1
>> config.bat ECHO REM Set total average hashrate of this Rig. (you can use average hashrate value from your pool)
>> config.bat ECHO SET AverageTotalHashrate=0
>> config.bat ECHO REM =================================================== [Miner]
>> config.bat ECHO REM Use miner.bat or %MinerProcess% file to start mining? (1 - %MinerProcess%, 2 - miner.bat)
>> config.bat ECHO SET StartFromBatOrExe=2
>> config.bat ECHO REM Set miner command here to auto-create miner.bat or miner.cfg file if it is missing or wrong. (keep default order)
>> config.bat ECHO SET MainServerBatCommand=miner --server eu1-zcash.flypool.org --port 3333 --user t1S8HRoMoyhBhwXq6zY5vHwqhd9MHSiHWKv.def169 --pass x --log 2 --fee 2 --templimit 90 --eexit 3 --pec
>> config.bat ECHO REM Enable additional server. When the main server fails, %~n0 will switch to the additional server immediately. (0 - false, 1 - true) EnableInternetConnectivityCheck=1 required.
>> config.bat ECHO SET EnableAdditionalServer=0
>> config.bat ECHO REM Configure miner command here. Old miner.bat will be removed and a new one will be created with this value. (keep default order) EnableInternetConnectivityCheck=1 required.
>> config.bat ECHO SET AdditionalServerBatCommand=miner --server eu1-zcash.flypool.org --port 3333 --user t1S8HRoMoyhBhwXq6zY5vHwqhd9MHSiHWKv.def169 --pass x --log 2 --fee 2 --templimit 90 --eexit 3 --pec
>> config.bat ECHO REM =================================================== [Timers]
>> config.bat ECHO REM Restart miner or computer every hour. (1 - true miner every One hour, 2 - true miner every Two hours, 3 - true computer every One hour, 4 - true computer every Two hours, 0 - false)
>> config.bat ECHO SET EveryHourAutoRestart=0
>> config.bat ECHO REM Restart miner or computer every day at 12:00. (1 - true miner, 2 - true computer, 0 - false)
>> config.bat ECHO SET MiddayAutoRestart=0
>> config.bat ECHO REM Restart miner or computer every day at 00:00. (1 - true miner, 2 - true computer, 0 - false)
>> config.bat ECHO SET MidnightAutoRestart=0
>> config.bat ECHO REM =================================================== [Other]
>> config.bat ECHO REM Skip miner startup confirmation. (0 - false, 1 - true)
>> config.bat ECHO SET SkipBeginMiningConfirmation=0
>> config.bat ECHO REM Enable Internet connectivity check. (0 - false, 1 - true)
>> config.bat ECHO REM Disable Internet connectivity check only if you have difficulties with your connection. (ie. high latency, intermittent connectivity)
>> config.bat ECHO SET EnableInternetConnectivityCheck=1
>> config.bat ECHO REM Enable additional environments. Please do not use this option if it is not needed, or if you do not understand it's function. (0 - false, 1 - true)
>> config.bat ECHO REM GPU_FORCE_64BIT_PTR 0, GPU_MAX_HEAP_SIZE 100, GPU_USE_SYNC_OBJECTS 1, GPU_MAX_ALLOC_PERCENT 100, GPU_SINGLE_ALLOC_PERCENT 100
>> config.bat ECHO SET EnableGPUEnvironments=0
>> config.bat ECHO REM =================================================== [Telegram notifications]
>> config.bat ECHO REM Enable Telegram notifications. Don't forget to add @EwbfWatchBot in Telegram. (0 - false, 1 - true)
>> config.bat ECHO SET EnableTelegramNotifications=0
>> config.bat ECHO REM Name your Rig. (in English, without special symbols)
>> config.bat ECHO SET RigName=Zcash Farm
>> config.bat ECHO REM Enter here your ChatId, from Telegram @EwbfWatchBot.
>> config.bat ECHO SET ChatId=000000000
>> config.bat ECHO REM Enable hourly statistics through Telegram. (0 - false, 1 - true, 2 - true in silent mode, 3 - true short, 4 - true short in silent mode)
>> config.bat ECHO SET EnableEveryHourInfoSend=0
>> config.bat ECHO REM =================================================== [Additional program]
>> config.bat ECHO REM Enable additional program check on startup. (ie. TeamViewer, Minergate, Storj etc) (0 - false, 1 - true)
>> config.bat ECHO SET EnableAPAutorun=0
>> config.bat ECHO REM Process name of additional program. (Press CTRL+ALT+DEL to find the process name)
>> config.bat ECHO SET APProcessName=TeamViewer.exe
>> config.bat ECHO REM Path to file of additional program. (ie. C:\Program Files (x86)\TeamViewer\TeamViewer.exe)
>> config.bat ECHO SET APProcessPath=C:\Program Files (x86)\TeamViewer\TeamViewer.exe
ECHO Default config.bat created. Please check it and restart %~n0.bat.
GOTO checkconfig
:restart
COLOR 4F
CHOICE /C yn /T 30 /D y /M "Restart your computer now"
IF ERRORLEVEL ==2 GOTO hardstart
tskill /A /V %GPUOverclockProcess% 2>NUL 1>&2 && ECHO Process %GPUOverclockProcess%.exe was successfully killed.
taskkill /F /IM "%MinerProcess%" 2>NUL 1>&2 && ECHO Process %MinerProcess% was successfully killed. & timeout /T 5 /nobreak >NUL & taskkill /F /FI "IMAGENAME eq cmd.exe" /FI "WINDOWTITLE eq miner.bat*" 2>NUL 1>&2
IF %EnableAPAutorun% EQU 1 taskkill /F /IM "%APProcessName%" 2>NUL 1>&2 && ECHO Process %APProcessName% was successfully killed.
IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Computer restarting...')" 2>NUL 1>&2
>> %~n0.log ECHO [%NowDate%][%NowTime%] Computer restarting...
shutdown /T 30 /R /F /C "Your computer will restart after 30 seconds. To cancel restart, close this window and start autorun.bat manually."
EXIT
:prestart
SET NumberOfGPUs=%NumberOfGPUs: =%& SET AverageTotalHashrate=%AverageTotalHashrate: =%& SET ChatId=%ChatId: =%
IF %ChatId% EQU "000000000" SET EnableTelegramNotifications=0
IF %EnableGPUEnvironments% EQU 1 (
	SETX GPU_FORCE_64BIT_PTR 0 2>NUL 1>&2 && ECHO GPU_FORCE_64BIT_PTR 0
	SETX GPU_MAX_HEAP_SIZE 100 2>NUL 1>&2 && ECHO GPU_MAX_HEAP_SIZE 100
	SETX GPU_USE_SYNC_OBJECTS 1 2>NUL 1>&2 && ECHO GPU_USE_SYNC_OBJECTS 1
	SETX GPU_MAX_ALLOC_PERCENT 100 2>NUL 1>&2 && ECHO GPU_MAX_ALLOC_PERCENT 100
	SETX GPU_SINGLE_ALLOC_PERCENT 100 2>NUL 1>&2 && ECHO GPU_SINGLE_ALLOC_100
) ELSE (
	REG DELETE HKCU\Environment /F /V GPU_FORCE_64BIT_PTR 2>NUL 1>&2 && ECHO GPU_FORCE_64BIT_PTR successfully removed from environments.
	REG DELETE HKCU\Environment /F /V GPU_MAX_HEAP_SIZE 2>NUL 1>&2 && ECHO GPU_MAX_HEAP_SIZE successfully removed from environments.
	REG DELETE HKCU\Environment /F /V GPU_USE_SYNC_OBJECTS 2>NUL 1>&2 && ECHO GPU_USE_SYNC_OBJECTS successfully removed from environments.
	REG DELETE HKCU\Environment /F /V GPU_MAX_ALLOC_PERCENT 2>NUL 1>&2 && ECHO GPU_MAX_ALLOC_PERCENT successfully removed from environments.
	REG DELETE HKCU\Environment /F /V GPU_SINGLE_ALLOC_PERCENT 2>NUL 1>&2 && ECHO GPU_SINGLE_ALLOC_PERCENT successfully removed from environments.
)
IF %SkipBeginMiningConfirmation% EQU 0 (
	CHOICE /C yn /T 30 /D y /M "Begin mining"
	IF ERRORLEVEL ==2 EXIT
	GOTO start
) ELSE (
	timeout /T 5 /nobreak >NUL
	GOTO start
)
:switch
IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Attempting to switch to the main pool server.')" 2>NUL 1>&2
>> %~n0.log ECHO [%NowDate%][%NowTime%] Warning. Attempting to switch to the main pool server.
ECHO ==================================================================
ECHO +----------------------------------------------------------------+
ECHO + Now %NowDate% %NowTime%                                           +
ECHO + Miner was started at %StartDate% %StartTime%                          +
ECHO + Miner ran for %t3%                                         +
ECHO + Warning. Attempting to switch to the main pool server.         +
ECHO +----------------------------------------------------------------+
ECHO ==================================================================
GOTO hardstart
:ctimer
IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Scheduled computer restart, please wait...')" 2>NUL 1>&2
>> %~n0.log ECHO [%NowDate%][%NowTime%] Warning. Scheduled computer restart, please wait. Miner ran for %t3%.
ECHO ==================================================================
ECHO +----------------------------------------------------------------+
ECHO + Now %NowDate% %NowTime%                                           +
ECHO + Miner was started at %StartDate% %StartTime%                          +
ECHO + Miner ran for %t3%                                         +
ECHO + Warning. Scheduled computer restart, please wait...            +
ECHO +----------------------------------------------------------------+
ECHO ==================================================================
GOTO restart
:mtimer
IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Scheduled miner restart, please wait...')" 2>NUL 1>&2
>> %~n0.log ECHO [%NowDate%][%NowTime%] Warning. Scheduled miner restart, please wait. Miner ran for %t3%.
ECHO ==================================================================
ECHO +----------------------------------------------------------------+
ECHO + Now %NowDate% %NowTime%                                           +
ECHO + Miner was started at %StartDate% %StartTime%                          +
ECHO + Miner ran for %t3%                                         +
ECHO + Warning. Scheduled miner restart, please wait...               +
ECHO +----------------------------------------------------------------+
ECHO ==================================================================
GOTO hardstart
:error
COLOR 4F
IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Miner restarting...')" 2>NUL 1>&2
ECHO ==================================================================
ECHO +----------------------------------------------------------------+
ECHO + Now %NowDate% %NowTime%                                           +
ECHO + Miner was started at %StartDate% %StartTime%                          +
ECHO + Miner ran for %t3%                                         +
ECHO %ErrorEcho%
ECHO + Miner restarting...                                            +
ECHO +----------------------------------------------------------------+
ECHO ==================================================================
SET /A ErrorsCounter+=1
:start
COLOR 1F
FOR /F %%D IN ('wmic.exe OS GET localdatetime^| findstr ^[0-9]') DO SET t1=%%D
SET Y1=%t1:~0,4%& SET M1=%t1:~4,2%& SET D1=%t1:~6,2%& SET H1=%t1:~8,2%& SET X1=%t1:~10,2%& SET C1=%t1:~12,2%
SET StartTime=%H1%:%X1%& SET StartDate=%Y1%.%M1%.%D1%
IF %M1:~0,1% ==0 SET M1=%M1:~1%
IF %D1:~0,1% ==0 SET D1=%D1:~1%
IF %H1:~0,1% ==0 SET H1=%H1:~1%
IF %X1:~0,1% ==0 SET X1=%X1:~1%
IF %C1:~0,1% ==0 SET C1=%C1:~1%
SET /A s1=H1*60*60+X1*60+C1& SET /A RestartHour=%H1%+2
IF %EnableGPUOverclockMonitor% GTR 0 (
	IF %AverageTotalHashrate% EQU 0 ECHO Error. Average hashrate = 0. This must be set to a number higher than 0 in your config.bat file under AverageTotalHashrate.& ECHO GPUOverclockControl will be disabled...& SET EnableGPUOverclockMonitor=0
	IF %EnableGPUOverclockMonitor% EQU 1 SET GPUOverclockProcess=Xtreme& SET GPUOverclockPath=\GIGABYTE\XTREME GAMING ENGINE\
	IF %EnableGPUOverclockMonitor% EQU 2 SET GPUOverclockProcess=MSIAfterburner& SET GPUOverclockPath=\MSI Afterburner\
	IF %EnableGPUOverclockMonitor% EQU 3 SET GPUOverclockProcess=GPUTweakII& SET GPUOverclockPath=\ASUS\GPU TweakII\
	IF %EnableGPUOverclockMonitor% EQU 4 SET GPUOverclockProcess=PrecisionX_x64& SET GPUOverclockPath=\EVGA\Precision XOC\
	IF %EnableGPUOverclockMonitor% EQU 5 SET GPUOverclockProcess=AORUS& SET GPUOverclockPath=\GIGABYTE\AORUS GRAPHICS ENGINE\
	IF NOT EXIST "%programfiles(x86)%%GPUOverclockPath%" (
		ECHO Warning. Incorrect path to %GPUOverclockProcess%.exe. Default install path required to function. Please reinstall the software using the default path.& ECHO GPUOverclockControl will be disabled...
		SET EnableGPUOverclockMonitor=0
	)
)
IF %EnableGPUOverclockMonitor% LEQ 0 ECHO ECHO Overclock control monitor was disabled.& SET EnableGPUOverclockMonitor=0
IF NOT EXIST "%~dp0%MinerProcess%" ECHO Error. "%MinerProcess%" is missing. Please check the directory for missing files. Exiting...& PAUSE & EXIT
IF NOT EXIST "%~dp0cudart64_80.dll" ECHO Error. "cudart64_80.dll" is missing. Please check the directory for missing files. Exiting...& PAUSE & EXIT
IF EXIST "%~dp0Logs" ECHO Folder Logs exist.
IF NOT EXIST "%~dp0Logs" MD Logs && ECHO Folder Logs created.
IF %EnableAPAutorun% EQU 1 (
	tasklist /FI "IMAGENAME eq %APProcessName%" 2>NUL| find /I /N "%APProcessName%" >NUL
	IF ERRORLEVEL ==1 (
		START /MIN "%APProcessName%" "%APProcessPath%" && ECHO %APProcessName% was started at %StartDate% %StartTime%& timeout /T 5 /nobreak >NUL
		IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* %APProcessName% was started.')" 2>NUL 1>&2
		>> %~n0.log ECHO [%StartDate%][%StartTime%] %APProcessName% was started.
	)
)
IF %EnableGPUOverclockMonitor% GEQ 1 (
	IF %RestartGPUOverclockMonitor% EQU 1 (
		IF %FirstRun% EQU 1 (
			tskill /A /V %GPUOverclockProcess% 2>NUL 1>&2 && ECHO Process %GPUOverclockProcess%.exe was successfully killed.& timeout /T 5 /nobreak >NUL
			IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Process %GPUOverclockProcess%.exe was successfully killed.')" 2>NUL 1>&2
			>> %~n0.log ECHO [%StartDate%][%StartTime%] Process %GPUOverclockProcess%.exe was successfully killed.
		)
	)
	tasklist /FI "IMAGENAME eq %GPUOverclockProcess%.exe" 2>NUL| find /I /N "%GPUOverclockProcess%.exe" >NUL
	IF ERRORLEVEL ==1 (
		START /MIN "" "%programfiles(x86)%%GPUOverclockPath%%GPUOverclockProcess%.exe" && ECHO %GPUOverclockProcess%.exe was started at %StartDate% %StartTime%& timeout /T 5 /nobreak >NUL
		IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* %GPUOverclockProcess%.exe was started.')" 2>NUL 1>&2
		>> %~n0.log ECHO [%StartDate%][%StartTime%] %GPUOverclockProcess%.exe was started.
	)
	IF %EnableGPUOverclockMonitor% EQU 2 IF %AutorunMSIAWithProfile% GEQ 1 IF %AutorunMSIAWithProfile% LEQ 5 "%programfiles(x86)%%GPUOverclockPath%%GPUOverclockProcess%.exe" -Profile%AutorunMSIAWithProfile% >NUL
)
taskkill /F /IM "%MinerProcess%" 2>NUL 1>&2 && (
	ECHO Process %MinerProcess% was successfully killed. & timeout /T 5 /nobreak >NUL & taskkill /F /FI "IMAGENAME eq cmd.exe" /FI "WINDOWTITLE eq miner.bat*" 2>NUL 1>&2
	IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Process %MinerProcess% was successfully killed.')" 2>NUL 1>&2
	>> %~n0.log ECHO [%StartDate%][%StartTime%] Process %MinerProcess% was successfully killed.
)
IF EXIST "%MinerLog%" MOVE /Y %MinerLog% Logs\miner_%Y0%.%M0%.%D0%_%H0%.%X0%.%C0%.log 2>NUL 1>&2
IF ERRORLEVEL ==1 (
	>> %~n0.log ECHO [%StartDate%][%StartTime%] Warning. Unable to rename or access %MinerLog%. Attempting to delete %MinerLog% and continue...
	DEL /Q /F "%~dp0%MinerLog%" >NUL || (
		ECHO Error. Unable to rename or access %MinerLog%.
		IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Unable to delete %MinerLog%.')" 2>NUL 1>&2
		>> %~n0.log ECHO [%StartDate%][%StartTime%] Error. Unable to delete %MinerLog%.
		GOTO hardstart
	)
) ELSE (
	ECHO %MinerLog% renamed and moved to Logs folder.
)
timeout /T 5 /nobreak >NUL
IF %StartFromBatOrExe% EQU 1 (
	IF NOT EXIST "%~dp0%MinerProcess%" ECHO Mining is impossible, %MinerProcess% is missing. Please ensure you've placed autorun.bat in the same directory as the EWBF miner.& PAUSE & EXIT
	IF NOT EXIST "%~dp0miner.cfg" (
		FOR /F "tokens=3,5,7,9 delims= " %%W IN ("%MainServerBatCommand%") DO (
			> miner.cfg ECHO # Common parameters
			>> miner.cfg ECHO # All the parameters here are similar to the command line arguments
			>> miner.cfg ECHO.
			>> miner.cfg ECHO [common]
			>> miner.cfg ECHO cuda_devices 0 1 2 3 4 5 6 7
			>> miner.cfg ECHO intensity    64 64 64 64 64 64 64 64
			>> miner.cfg ECHO templimit    90
			>> miner.cfg ECHO pec          1
			>> miner.cfg ECHO boff         0
			>> miner.cfg ECHO eexit        3
			>> miner.cfg ECHO tempunits    c
			>> miner.cfg ECHO log          2
			>> miner.cfg ECHO logfile      %MinerLog%
			>> miner.cfg ECHO api          127.0.0.1:42000
			>> miner.cfg ECHO.
			>> miner.cfg ECHO # The miner start work from this server
			>> miner.cfg ECHO # When the server is fail, the miner will try to reconnect 3 times
			>> miner.cfg ECHO # After three unsuccessful attempts, the miner will switch to the next server
			>> miner.cfg ECHO # You can add up to 8 servers
			>> miner.cfg ECHO.
			>> miner.cfg ECHO # main server
			>> miner.cfg ECHO [server]
			>> miner.cfg ECHO server %%W
			>> miner.cfg ECHO port   %%X
			>> miner.cfg ECHO user   %%Y
			>> miner.cfg ECHO pass   %%Z
			>> miner.cfg ECHO.
		)
		FOR /F "tokens=3,5,7,9 delims= " %%W IN ("%AdditionalServerBatCommand%") DO (
			>> miner.cfg ECHO # additional server 1
			>> miner.cfg ECHO [server]
			>> miner.cfg ECHO server %%W
			>> miner.cfg ECHO port   %%X
			>> miner.cfg ECHO user   %%Y
			>> miner.cfg ECHO pass   %%Z
		)
		ECHO miner.cfg created. Please check it for errors.
	)
	START "%MinerProcess%" "%~dp0%MinerProcess%" && ECHO Miner was started at %StartDate% %StartTime%
	IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Miner was started.')" 2>NUL 1>&2
	>> %~n0.log ECHO [%StartDate%][%StartTime%] Miner was started. Autorun v. %Version%.
) ELSE (
	IF NOT EXIST "%~dp0miner.bat" (
		> miner.bat ECHO @ECHO off
		>> miner.bat ECHO TITLE miner.bat
		>> miner.bat ECHO REM Configure miner's command line in config.bat file. Not in miner.bat.
		>> miner.bat ECHO %MainServerBatCommand%
		>> miner.bat ECHO EXIT
		ECHO miner.bat created. Please check it for errors.
		GOTO start
	) ELSE (
		IF %SwitchToDefault% EQU 0 (
			findstr /L /C:"%MainServerBatCommand%" miner.bat 2>NUL 1>&2 || (
				> miner.bat ECHO @ECHO off
				>> miner.bat ECHO TITLE miner.bat
				>> miner.bat ECHO REM Configure miner's command line in config.bat file. Not in miner.bat.
				>> miner.bat ECHO %MainServerBatCommand%
				>> miner.bat ECHO EXIT
			)
		)
	)
	START "miner.bat" "%~dp0miner.bat" && ECHO Miner was started at %StartDate% %StartTime%
	IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Miner was started.')" 2>NUL 1>&2
	>> %~n0.log ECHO [%StartDate%][%StartTime%] Miner was started. Autorun v. %Version%.
)
timeout /T 5 /nobreak >NUL
IF NOT EXIST "%~dp0%MinerLog%" (
	ECHO Error. %MinerLog% is missing.
	ECHO Check permissions in "%~dp0". This script requires permission to create files.
	IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Error. %MinerLog% is missing.%%0ACheck permissions in "%~dp0". This script requires permission to create files.')" 2>NUL 1>&2
	>> %~n0.log ECHO [%StartDate%][%StartTime%] Error. %MinerLog% is missing.
	>> %~n0.log ECHO [%StartDate%][%StartTime%] Check permissions in "%~dp0". This script requires permission to create files.
	IF %StartFromBatOrExe% EQU 2 (
		ECHO Ensure "--log 2" option is added to the miner's command line.
		>> %~n0.log ECHO [%StartDate%][%StartTime%] Ensure "--log 2" option is added to the miner's command line.
		> miner.bat ECHO @ECHO off
		>> miner.bat ECHO TITLE miner.bat
		>> miner.bat ECHO REM Configure miner's command line in config.bat file. Not in miner.bat.
		>> miner.bat ECHO %MainServerBatCommand%
		>> miner.bat ECHO EXIT
		ECHO miner.bat created. Please check it for errors.
		GOTO start
	) ELSE (
		ECHO Ensure "log 2" option is added in your miner.cfg file.
		>> %~n0.log ECHO [%StartDate%][%StartTime%] Ensure "log 2" option is added in your miner.cfg file.
		DEL /Q /F "%~dp0miner.cfg" >NUL
		GOTO start
	)
) ELSE (
	ECHO Connected to %MinerLog%. Log monitoring started...
)
SET FirstRun=0& SET HashrateErrorsCount=0& SET OldHashrate=0& SET InternetErrorsCounter=1
:check
IF %FirstRun% EQU 0 timeout /T 15 /nobreak >NUL
SET Hashcount=0& SET SumHash=0
COLOR 1F
timeout /T 5 /nobreak >NUL
FOR /F %%F IN ('wmic.exe OS GET localdatetime^| findstr ^[0-9]') DO SET t2=%%F
SET Y2=%t2:~0,4%& SET M2=%t2:~4,2%& SET D2=%t2:~6,2%& SET H2=%t2:~8,2%& SET X2=%t2:~10,2%& SET C2=%t2:~12,2%
SET NowTime=%H2%:%X2%& SET NowDate=%Y2%.%M2%.%D2%
IF %M2:~0,1% ==0 SET M2=%M2:~1%
IF %D2:~0,1% ==0 SET D2=%D2:~1%
IF %H2:~0,1% ==0 SET H2=%H2:~1%
IF %X2:~0,1% ==0 SET X2=%X2:~1%
IF %C2:~0,1% ==0 SET C2=%C2:~1%
SET /A s2=H2*60*60+X2*60+C2
IF %D2% GTR %D1% (
	SET /A s3=^(%D2%-%D1%^)*86400-%s1%+%s2%
) ELSE (
	IF %M2% NEQ %M1% (
		>> %~n0.log ECHO [%NowDate%][%NowTime%] Warning. Miner must be restarted, please wait...
		GOTO hardstart
	)
	IF %s2% GEQ %s1% (SET /A s3=%s2%-%s1%) ELSE (SET /A s3=%s1%-%s2%)
)
SET /A t3h=%s3%/60/60& SET /A t3m=%s3% %% 3600/60& SET /A t3s=%s3% %% 60
IF %t3h% LSS 10 SET t3h=0%t3h%
IF %t3m% LSS 10 SET t3m=0%t3m%
IF %t3s% LSS 10 SET t3s=0%t3s%
SET t3=%t3h%:%t3m%:%t3s%
IF %D2% NEQ %D1% (
	IF %MidnightAutoRestart% EQU 1 GOTO mtimer
	IF %MidnightAutoRestart% EQU 2 GOTO ctimer
)
IF %H2% NEQ %H1% (
	IF %EveryHourAutoRestart% EQU 1 GOTO mtimer
	IF %EveryHourAutoRestart% EQU 2 (
		IF %H2% GEQ %RestartHour% GOTO mtimer
		IF %H2% LSS %H1% GOTO mtimer
	)
	IF %EveryHourAutoRestart% EQU 3 GOTO ctimer
	IF %EveryHourAutoRestart% EQU 4 (
		IF %H2% GEQ %RestartHour% GOTO ctimer
		IF %H2% LSS %H1% GOTO ctimer
	)
	IF %H2% EQU 12 (
		IF %MiddayAutoRestart% EQU 1 GOTO mtimer
		IF %MiddayAutoRestart% EQU 2 GOTO ctimer
	)
)
IF %SwitchToDefault% EQU 1 (
	IF %H2% NEQ %H1% GOTO switch
	IF %X2% EQU 30 GOTO switch
)
IF %ErrorsCounter% GEQ %ErrorsAmount% (
	>> %~n0.log ECHO [%NowDate%][%NowTime%] Warning. Too many errors. A restart of the computer to clear GPU cache is required. Restarting... Miner ran for %t3%.
	COLOR 4F
	ECHO ==================================================================
	ECHO +----------------------------------------------------------------+
	ECHO + Now %NowDate% %NowTime%                                           +
	ECHO + Miner was started at %StartDate% %StartTime%                          +
	ECHO + Miner ran for %t3%                                         +
	ECHO + Warning. Too many errors, need clear GPU cash.                 +
	ECHO + Computer restarting...                                         +
	ECHO +----------------------------------------------------------------+
	ECHO ==================================================================
	GOTO restart
)
timeout /T 2 /nobreak >NUL
FOR /F "tokens=3 delims= " %%G IN ('findstr /R /C:"Total speed: [0-9]* Sol/s" %MinerLog%') DO SET LastHashrate=%%G& SET /A Hashcount+=1& SET /A SumHash=SumHash+%%G& SET /A SumResult=SumHash/Hashcount
timeout /T 2 /nobreak >NUL
FOR /F "delims=" %%T IN ('findstr /R /C:"Temp: GPU.*C.*" %MinerLog%') DO SET CurrentTemp=%%T
timeout /T 2 /nobreak >NUL
FOR /F "delims=" %%U IN ('findstr /R /C:"GPU.*: .* Sol/s .*" %MinerLog%') DO SET CurrentSpeed=%%U
IF %AverageTotalHashrate% GTR 0 (
	IF !LastHashrate! LSS %AverageTotalHashrate% SET /A MinHashrate+=1
	IF !MinHashrate! GEQ 100 GOTO passaveragecheck
	IF !SumResult! NEQ %OldHashrate% IF !SumResult! LSS %AverageTotalHashrate% (
		:passaveragecheck
		COLOR 4F
		IF %EnableGPUOverclockMonitor% NEQ 0 (
			tasklist /FI "IMAGENAME eq %GPUOverclockProcess%.exe" 2>NUL| find /I /N "%GPUOverclockProcess%.exe" >NUL
			IF ERRORLEVEL ==1 (
				IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Process %GPUOverclockProcess%.exe crashed.')" 2>NUL 1>&2
				>> %~n0.log ECHO [%NowDate%][%NowTime%] Error. Process %GPUOverclockProcess%.exe crashed. Miner ran for %t3%.
				IF %EnableGPUOverclockMonitor% EQU 1 SET ErrorEcho=+ Error. Process %GPUOverclockProcess%.exe crashed...                           +
				IF %EnableGPUOverclockMonitor% EQU 2 SET ErrorEcho=+ Error. Process %GPUOverclockProcess%.exe crashed...                   +
				IF %EnableGPUOverclockMonitor% EQU 3 SET ErrorEcho=+ Error. Process %GPUOverclockProcess%.exe crashed...                       +
				IF %EnableGPUOverclockMonitor% EQU 4 SET ErrorEcho=+ Error. Process %GPUOverclockProcess%.exe crashed...                   +
				IF %EnableGPUOverclockMonitor% EQU 5 SET ErrorEcho=+ Error. Process %GPUOverclockProcess%.exe crashed...                            +
				GOTO error
			)
		)
		IF %HashrateErrorsCount% GEQ %HashrateErrorsAmount% (
			>> %~n0.log ECHO [%NowDate%][%NowTime%] Warning. Low hashrate. Miner ran for %t3%.
			SET ErrorEcho=+ Warning. Low hashrate...                                       +
			GOTO error
		)
		IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Abnormal hashrate. Average: *!SumResult!/%AverageTotalHashrate%* Last: *!LastHashrate!/%AverageTotalHashrate%*')" 2>NUL 1>&2
		>> %~n0.log ECHO [%NowDate%][%NowTime%] Warning. Abnormal hashrate. Average: !SumResult!/%AverageTotalHashrate% Last: !LastHashrate!/%AverageTotalHashrate%
		ECHO [%NowDate%][%NowTime%] Warning. Abnormal hashrate. Average: !SumResult!/%AverageTotalHashrate% Last: !LastHashrate!/%AverageTotalHashrate%
		SET /A HashrateErrorsCount+=1& SET OldHashrate=!SumResult!
	)
)
IF %PTOS1% GEQ 59 SET PTOS1=0
IF %PTOS1% LSS %X2% (
	SET PTOS1=%X2%
	SET LstShareDiff=0
	timeout /T 2 /nobreak >NUL
	FOR /F "tokens=3 delims=: " %%Y IN ('findstr /R /C:"INFO .* share .*" %MinerLog%') DO SET LstShareMin=%%Y
	IF !LstShareMin! GEQ 0 IF %X2% GEQ 1 (
		IF !LstShareMin! LSS 10 SET LstShareMin=!LstShareMin:~1!
		IF !LstShareMin! EQU 0 SET LstShareMin=59
		IF !LstShareMin! LSS %X2% SET /A LstShareDiff=%X2%-!LstShareMin!
		IF !LstShareMin! GTR %X2% SET /A LstShareDiff=!LstShareMin!-%X2%
		IF !LstShareMin! GTR 50 IF %X2% LEQ 10 SET /A LstShareDiff=60-!LstShareMin!+%X2%
		IF !LstShareDiff! GTR 10 (
			IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Error. Long share timeout... Miner ran for %t3%.')" 2>NUL 1>&2
			>> %~n0.log ECHO [%NowDate%][%NowTime%] Error. Long share timeout... !LstShareDiff!/!LstShareMin!/%X2%. Miner ran for %t3%.
			SET ErrorEcho=+ Error. Long share timeout...                                   +
			GOTO error
		)
	)
)
timeout /T 2 /nobreak >NUL
FOR /F "delims=" %%N IN ('findstr %InternetErrorsList% %MinerErrorsList% %CriticalErrorsList% %OtherErrorsList% %MinerWarningsList% %OtherWarningsList% %MinerLog%') DO (
	IF %EnableTelegramNotifications% EQU 1 ECHO %%N| findstr /V %InternetErrorsList% %MinerWarningsList% >NUL && powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* %%N')" 2>NUL 1>&2
	ECHO %%N| findstr /V %InternetErrorsList% >NUL && >> %~n0.log ECHO [%NowDate%][%NowTime%] %%N
	IF %EnableInternetConnectivityCheck% EQU 1 (
		timeout /T 15 /nobreak >NUL
		FOR /F "delims=" %%M IN ('findstr %InternetErrorsList% %InternetErrorsCancel% %MinerLog%') DO SET LastInternetError=%%M
		ECHO !LastInternetError!| findstr %InternetErrorsList% >NUL && (
			ping google.com| find /i "TTL=" >NUL && (
				ECHO %%N| findstr %InternetErrorsList% 2>NUL && (
					IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* %%N')" 2>NUL 1>&2
					COLOR 4F
					ECHO ==================================================================
					ECHO +----------------------------------------------------------------+
					ECHO + Now %NowDate% %NowTime%                                           +
					ECHO + Miner was started at %StartDate% %StartTime%                          +
					ECHO + Carefully configure config.bat, miner.cfg or/and miner.bat     +
					ECHO + Check config file for errors or pool is offline                +
					ECHO + Miner restarting with default values...                        +
					ECHO +----------------------------------------------------------------+
					ECHO ==================================================================
					SET StartFromBatOrExe=2
					taskkill /F /IM "%MinerProcess%" 2>NUL 1>&2 && timeout /T 5 /nobreak >NUL & taskkill /F /FI "IMAGENAME eq cmd.exe" /FI "WINDOWTITLE eq miner.bat*" 2>NUL 1>&2
					> miner.bat ECHO @ECHO off
					>> miner.bat ECHO TITLE miner.bat
					>> miner.bat ECHO REM Configure miner's command line in config.bat file. Not in miner.bat.
					IF %EnableAdditionalServer% EQU 1 (
						IF %ServerQueue% EQU 1 (
							>> miner.bat ECHO miner --server eu1-zcash.flypool.org --port 3333 --user t1S8HRoMoyhBhwXq6zY5vHwqhd9MHSiHWKv.dev169 --pass x --log 2 --fee 2 --templimit 90 --eexit 2 --pec
							SET ServerQueue=0& SET SwitchToDefault=1
						)
						IF %ServerQueue% EQU 0 (
							>> miner.bat ECHO %AdditionalServerBatCommand%
							SET ServerQueue=1& SET SwitchToDefault=1
						)
					) ELSE (
						>> miner.bat ECHO miner --server eu1-zcash.flypool.org --port 3333 --user t1S8HRoMoyhBhwXq6zY5vHwqhd9MHSiHWKv.dev169 --pass x --log 2 --fee 2 --templimit 90 --eexit 2 --pec
						SET SwitchToDefault=1
					)
					>> miner.bat ECHO EXIT
					IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Pool server was switched. Please check your config.bat, miner.cfg or miner.bat file carefully for spelling errors or incorrect parameters. Otherwise check if the pool you are connecting to is online.')" 2>NUL 1>&2
					>> %~n0.log ECHO [%NowDate%][%NowTime%] Warning. Pool server was switched. Please check your config.bat, miner.cfg or miner.bat file carefully for spelling errors or incorrect parameters. Otherwise check if the pool you are connecting to is online.
					ECHO Warning. Pool server was switched. Please check your config.bat, miner.cfg or miner.bat file carefully for spelling errors or incorrect parameters. Otherwise check if the pool you are connecting to is online.
					ECHO Default miner.bat created. Please check it for errors.
					SET /A ErrorsCounter+=1
					GOTO start
				)
			) || (
				ECHO %%N| findstr %InternetErrorsList% 2>NUL && (
					COLOR 4F
					IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* %%N')" 2>NUL 1>&2
					>> %~n0.log ECHO [%NowDate%][%NowTime%] %%N
					>> %~n0.log ECHO [%NowDate%][%NowTime%] Error. Something is wrong with your Internet. Please check your connection. Miner ran for %t3%.
					ECHO ==================================================================
					ECHO +----------------------------------------------------------------+
					ECHO + Now %NowDate% %NowTime%                                           +
					ECHO + Miner was started at %StartDate% %StartTime%                          +
					ECHO + Miner ran for %t3%                                         +
					ECHO + Something is wrong with your Internet...                       +
					ECHO + Attempting to reconnect...                                     +
					ECHO +----------------------------------------------------------------+
					ECHO ==================================================================
					:tryingreconnect
					IF %t3h% EQU 0 IF %t3m% GEQ 10 IF %InternetErrorsCounter% GTR 10 GOTO restart
					IF %InternetErrorsCounter% GTR 60 GOTO restart
					SET /A InternetErrorsCounter+=1
					ECHO Attempt %InternetErrorsCounter% to restore Internet connection.
					FOR /F "delims=" %%L IN ('findstr %InternetErrorsCancel% %MinerLog%') DO GOTO reconnected
					ping google.com| find /i "TTL=" >NUL || (
						CHOICE /C yn /T 60 /D n /M "Restart miner manually"
						IF ERRORLEVEL ==2 GOTO tryingreconnect
						SET /A ErrorsCounter+=1
						GOTO start
					)
					:reconnected
					IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Something was wrong with your Internet. Connection has been restored. Miner restarting...')" 2>NUL 1>&2
					>> %~n0.log ECHO [%NowDate%][%NowTime%] Something was wrong with your Internet. Connection has been restored. Miner restarting...
					ECHO ==================================================================
					ECHO +----------------------------------------------------------------+
					ECHO + Now %NowDate% %NowTime%                                           +
					ECHO + Miner was started at %StartDate% %StartTime%                          +
					ECHO + Something was wrong with your Internet.                        +
					ECHO + Connection has been restored.                                  +
					ECHO + Miner restarting...                                            +
					ECHO +----------------------------------------------------------------+
					ECHO ==================================================================
					GOTO start
				)
			)
		)
	)
	ECHO %%N| findstr %MinerErrorsList% 2>NUL && (
		>> %~n0.log ECHO [%NowDate%][%NowTime%] Error from GPU. Voltage or Overclock issue. Miner ran for %t3%.
		SET ErrorEcho=+ Error from GPU. Voltage or Overclock issue...                  +
		GOTO error
	)
	ECHO %%N| findstr %CriticalErrorsList% 2>NUL && (
		>> %~n0.log ECHO [%NowDate%][%NowTime%] Critical error from GPU. Voltage or Overclock issue. Miner ran for %t3%.
		GOTO restart
	)
	ECHO %%N| findstr /V %InternetErrorsList% %MinerErrorsList% %CriticalErrorsList% %MinerWarningsList% %OtherWarningsList% 2>NUL && (
		>> %~n0.log ECHO [%NowDate%][%NowTime%] Unknown error found. Please send this error to developer. Miner ran for %t3%.
		SET ErrorEcho=+ Unknown error found...                                         +
		GOTO error
	)
	ECHO %%N| findstr %MinerWarningsList% 2>NUL && (
		IF %t3h% EQU 0 IF %t3m% LSS 10 (
			IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Current !CurrentTemp!.%%0A%%0ATemperature limit reached. GPU will now *STOP MINING*. Please ensure your GPUs have enough air flow. *Waiting for users input...*')" 2>NUL 1>&2
			>> %~n0.log ECHO [%NowDate%][%NowTime%] Current !CurrentTemp!. Temperature limit reached. GPU will now STOP MINING. Please ensure your GPUs have enough air flow. Miner ran for %t3%.
			tskill /A /V %GPUOverclockProcess% >NUL && ECHO Process %GPUOverclockProcess%.exe was successfully killed.
			taskkill /F /IM "%MinerProcess%" 2>NUL 1>&2 && ECHO Process %MinerProcess% was successfully killed. && timeout /T 5 /nobreak >NUL & taskkill /F /FI "IMAGENAME eq cmd.exe" /FI "WINDOWTITLE eq miner.bat*" 2>NUL 1>&2
			ECHO Temperature limit reached. GPU will now STOP MINING. Please ensure your GPUs have enough air flow. Miner ran for %t3%.
			ECHO Waiting for users input...
			PAUSE
			GOTO hardstart
		)
		IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Current !CurrentTemp!.%%0A%%0ATemperature limit reached. Fans may be stuck. Attempting to restart computer.')" 2>NUL 1>&2
		>> %~n0.log ECHO [%NowDate%][%NowTime%] Current !CurrentTemp!. Temperature limit reached. Fans may be stuck. Miner ran for %t3%. Computer restarting...
		ECHO Temperature limit reached. Fans may be stuck. Miner ran for %t3%.
		ECHO Computer restarting...
		GOTO restart
	)
	ECHO %%N| findstr /V %InternetErrorsList% %MinerErrorsList% %CriticalErrorsList% %OtherErrorsList% %MinerWarningsList% 2>NUL && (
		>> %~n0.log ECHO [%NowDate%][%NowTime%] Unknown warning found. Please send this warning to developer. Miner ran for %t3%.
		SET ErrorEcho=+ Unknown warning found...                                       +
		GOTO error
	)
)
timeout /T 5 /nobreak >NUL
tasklist /FI "IMAGENAME eq %MinerProcess%" 2>NUL| find /I /N "%MinerProcess%" >NUL
IF ERRORLEVEL ==1 (
	IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Process *%MinerProcess%* crashed.')" 2>NUL 1>&2
	>> %~n0.log ECHO [%NowDate%][%NowTime%] Error. Process %MinerProcess% crashed. Miner ran for %t3%.
	SET ErrorEcho=+ Error. Process %MinerProcess% crashed...                            +
	GOTO error
)
IF %EnableAPAutorun% EQU 1 (
	timeout /T 5 /nobreak >NUL
	tasklist /FI "IMAGENAME eq %APProcessName%" 2>NUL| find /I /N "%APProcessName%" >NUL
	IF ERRORLEVEL ==1 (
		IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Process *%APProcessName%* crashed.')" 2>NUL 1>&2
		>> %~n0.log ECHO [%NowDate%][%NowTime%] Error. %APProcessName% crashed. Miner ran for %t3%.
		SET ErrorEcho=+ Error. Additional program crashed...                           +
		GOTO error
	)
)
IF %FirstRun% EQU 0 (
	SET GPUCount=0
	IF %NumberOfGPUs% GEQ 1 (
		timeout /T 10 /nobreak >NUL
		FOR /F "delims=" %%I IN ('findstr /R /C:"CUDA: Device: [0-9]* .* PCI: .*" %MinerLog%') DO SET /A GPUCount+=1
		IF %NumberOfGPUs% GTR !GPUCount! (
			IF %AllowRestartGPU% EQU 1 (
				IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Failed load all GPUs. Number of GPUs *!GPUCount!/%NumberOfGPUs%*.')" 2>NUL 1>&2
				>> %~n0.log ECHO [%NowDate%][%NowTime%] Error. Failed load all GPUs. Number of GPUs [!GPUCount!/%NumberOfGPUs%]. Miner ran for %t3%.
				COLOR 4F
				ECHO ==================================================================
				ECHO +----------------------------------------------------------------+
				ECHO + Now %NowDate% %NowTime%                                           +
				ECHO + Miner was started at %StartDate% %StartTime%                          +
				ECHO + Miner ran for %t3%                                         +
				ECHO + Failed load all GPUs. Number of GPUs: [!GPUCount!/%NumberOfGPUs%]                    +
				ECHO + Computer restarting...                                         +
				ECHO +----------------------------------------------------------------+
				ECHO ==================================================================
				GOTO restart
			) ELSE (
				IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Failed load all GPUs. Number of GPUs *!GPUCount!/%NumberOfGPUs%*.')" 2>NUL 1>&2
				>> %~n0.log ECHO [%NowDate%][%NowTime%] Error. Failed load all GPUs. Number of GPUs [!GPUCount!/%NumberOfGPUs%].
				ECHO Failed load all GPUs. Number of GPUs: [!GPUCount!/%NumberOfGPUs%]
				SET /A AverageTotalHashrate=%AverageTotalHashrate%/%NumberOfGPUs%*!GPUCount!
			)
		)
		IF %NumberOfGPUs% LSS !GPUCount! (
			IF %EnableTelegramNotifications% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Loaded too many GPUs. This must be set to a number higher than *%NumberOfGPUs%* in your *config.bat* file under *NumberOfGPUs*. Number of GPUs *!GPUCount!/%NumberOfGPUs%*.')" 2>NUL 1>&2
			>> %~n0.log ECHO [%NowDate%][%NowTime%] Warning. Loaded too many GPUs. This must be set to a number higher than %NumberOfGPUs% in your config.bat file under NumberOfGPUs. Number of GPUs: [!GPUCount!/%NumberOfGPUs%].
			ECHO Loaded too many GPUs. This must be set to a number higher than %NumberOfGPUs% in your config.bat file under NumberOfGPUs. Number of GPUs: [!GPUCount!/%NumberOfGPUs%]
		)
	) ELSE (
		ECHO GPU check is disabled.
	)
	ECHO ==================================================================
	ECHO +----------------------------------------------------------------+
	ECHO + Process %MinerProcess% is running - do not worry                    +
	IF %EnableGPUOverclockMonitor% GTR 0 (
		IF %EnableGPUOverclockMonitor% EQU 1 ECHO + Process %GPUOverclockProcess%.exe is running...                               +
		IF %EnableGPUOverclockMonitor% EQU 2 ECHO + Process %GPUOverclockProcess%.exe is running...                       +
		IF %EnableGPUOverclockMonitor% EQU 3 ECHO + Process %GPUOverclockProcess%.exe is running...                           +
		IF %EnableGPUOverclockMonitor% EQU 4 ECHO + Process %GPUOverclockProcess%.exe is running...                       +
		IF %EnableGPUOverclockMonitor% EQU 5 ECHO + Process %GPUOverclockProcess%.exe is running...                                +
		IF %EnableGPUOverclockMonitor% GEQ 6 ECHO + GPU Overclock monitor: Wrong config.                           +
	)
	IF %EnableGPUOverclockMonitor% LEQ 0 ECHO + GPU Overclock monitor: Disabled                                +
	IF %MidnightAutoRestart% LEQ 0  ECHO + Autorestart at 00:00: Disabled                                 +
	IF %MidnightAutoRestart% GTR 0	ECHO + Autorestart at 00:00: Enabled                                  +
	IF %MiddayAutoRestart% LEQ 0 ECHO + Autorestart at 12:00: Disabled                                 +
	IF %MiddayAutoRestart% GTR 0 ECHO + Autorestart at 12:00: Enabled                                  +
	IF %EveryHourAutoRestart% LEQ 0 ECHO + Autorestart every hour: Disabled                               +
	IF %EveryHourAutoRestart% GTR 0 ECHO + Autorestart every hour: Enabled                                +
	IF %EnableTelegramNotifications% LEQ 0 ECHO + Telegram notifications: Disabled                               +
	IF %EnableTelegramNotifications% GTR 0 ECHO + Telegram notifications: Enabled                                +
	IF %EnableAPAutorun% LEQ 0 ECHO + Additional program autorun: Disabled                           +
	IF %EnableAPAutorun% EQU 1 ECHO + Additional program autorun: Enabled                            +
	ECHO + Number of errors: [%ErrorsCounter%/%ErrorsAmount%], GPUs: [!GPUCount!/%NumberOfGPUs%]                           +
	ECHO +----------------------------------------------------------------+
	ECHO ==================================================================
	SET FirstRun=1
	IF EXIST "%~dp0Logs\miner_*.log" (
		CHOICE /C yn /T 60 /D n /M "Clean Logs folder now"
		IF ERRORLEVEL ==2 (
			ECHO Now I will take care of your %RigName% and you can take a rest.
		) ELSE (
			DEL /F /Q "%~dp0Logs\*" && ECHO Clean Logs folder finished.
			ECHO Now I will take care of your %RigName% and you can take a rest.
		)
		GOTO check
	)
)
IF %EnableTelegramNotifications% EQU 1 (
	IF %X2% LSS 30 SET AllowSend=1
	IF %AllowSend% EQU 1 IF %X2% GEQ 30 (
		IF %EnableEveryHourInfoSend% EQU 1 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Miner has been running for *%t3h%:%t3m%* - do not worry.%%0AAverage total hashrate: *!SumResult!*.%%0ALast total hashrate: *!LastHashrate!*.%%0ACurrent Speed: !CurrentSpeed!.%%0ACurrent !CurrentTemp!.')" 2>NUL 1>&2 && SET AllowSend=0
		IF %EnableEveryHourInfoSend% EQU 2 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&disable_notification=true&text=*%RigName%:* Miner has been running for *%t3h%:%t3m%* - do not worry.%%0AAverage total hashrate: *!SumResult!*.%%0ALast total hashrate: *!LastHashrate!*.%%0ACurrent Speed: !CurrentSpeed!.%%0ACurrent !CurrentTemp!.')" 2>NUL 1>&2 && SET AllowSend=0
		IF %EnableEveryHourInfoSend% EQU 3 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&text=*%RigName%:* Online, *%t3h%:%t3m%*, *!LastHashrate!*.')" 2>NUL 1>&2 && SET AllowSend=0
		IF %EnableEveryHourInfoSend% EQU 4 powershell -command "(new-object net.webclient).DownloadString('%Web%&chat_id=%ChatId%&disable_notification=true&text=*%RigName%:* Online, *%t3h%:%t3m%*, *!LastHashrate!*.')" 2>NUL 1>&2 && SET AllowSend=0
	)
)
GOTO check