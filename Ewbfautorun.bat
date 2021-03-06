@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
MODE CON cols=67 lines=40
shutdown.exe /A 2>NUL 1>&2
FOR /F "tokens=1 delims=." %%A IN ('wmic.exe OS GET localdatetime^|Find "."') DO SET DT0=%%A
TITLE Miner-autorun(%DT0%)
SET Version=1.8.0
SET FirstRun=0
:hardstart
CLS
COLOR 1F
ECHO +================================================================+
ECHO            AutoRun v.%Version% for EWBF Miner - by Acrefawn
ECHO              ZEC: t1S8HRoMoyhBhwXq6zY5vHwqhd9MHSiHWKv
ECHO               BTC: 1wdJBYkVromPoiYk82JfSGSSVVyFJnenB
ECHO +================================================================+
REM Attention. Change the options below only if its really needed.
REM Amount of errors before computer restart (5 - default)
SET ErrorsAmount=5
REM Amount of hashrate errors before miner restart (5 - default)
SET HashrateErrorsAmount=5
REM Set MSI Afterburner wait timer (default - 120 sec, min value - 1 sec)
SET MSIADelayTimer=120
REM Name miner process. (in English, without special symbols and spaces)
SET MinerProcess=miner.exe
REM Name start mining .bat file. (in English, without special symbols and spaces)
SET MinerBat=miner.bat
REM Check to see if %~n0.bat has already been started. (0 - false, 1 - true)
SET EnableDoubleWindowCheck=1
REM Attention. Do not touch the options below in any case.
IF "%PROCESSOR_ARCHITECTURE%" == "x86" IF NOT DEFINED PROCESSOR_ARCHITEW6432 (
	ECHO Your OS Architecture is %PROCESSOR_ARCHITECTURE%. Only x64 required.
	PAUSE
	EXIT
)
IF %EnableDoubleWindowCheck% EQU 1 (
	tasklist.exe /V /NH /FI "imagename eq cmd.exe"| findstr.exe /V /R /C:".*Miner-autorun(%DT0%)"| findstr.exe /R /C:".*Miner-autorun.*" 2>NUL 1>&2 && (
		ECHO This script is already running...
		ECHO Current window will close in 10 seconds.
		timeout.exe /T 10 /nobreak >NUL
		EXIT
	)
)
SET PTOS1=0
SET rtpt=d2a
SET AllowSend=0
SET tprt=WYHfeJU
SET ServerQueue=1
SET prt=AAFWKz6wv7
SET ErrorsCounter=0
SET rtp=%rtpt%eV6idp
SET SwitchToDefault=0
SET tpr=C8go_jp8%tprt%
SET OtherErrorsList=/C:"ERROR:.*"
SET /A Num=(3780712+3780711)*6*9
SET OtherWarningsList=/C:"WARNING:.*"
SET IgnoreErrorsList=/C:".*solutions buf overflow.*" /C:".*cudaMemcpu .* failed.*" /C:".*illegal memory access.*" /C:".*msg buffer full.*"
SET InternetErrorsCancel=/C:".*Connection restored.*" /C:".*Connected.*"
SET MinerWarningsList=/C:".*reached.*"
SET CriticalErrorsList=/C:".*NVML.*" /C:".*CUDA-capable.*"
SET MinerErrorsList=/C:".*Thread exited.*" /C:".*benchmark error.*" /C:".*Api bind error.*" /C:".*CUDA error.*" /C:".*Looks like.*" /C:".*unresponsive.*" /C:" 0C " /C:".*t=0C.*"
SET InternetErrorsList=/C:".*Lost connection.*" /C:".*Connection lost.*" /C:".*not resolve.*" /C:".*subscribe timeout.*" /C:".*Cannot connect.*" /C:".*No properly.*" /C:".*Failed to connect.*" /C:".*not responding.*" /C:".*closed by server.*" /C:".*reconnecting.*" /C:".*connect failed.*"
REM Attention. Change the options below only if its really needed.
SET EnableGPUOverclockMonitor=0
SET AutorunMSIAWithProfile=0
SET RestartGPUOverclockMonitor=0
SET NumberOfGPUs=0
SET AllowRestartGPU=1
SET AverageTotalHashrate=0
SET Server1BatCommand=%MinerProcess% --server eu1-zcash.flypool.org --port 3333 --user t1S8HRoMoyhBhwXq6zY5vHwqhd9MHSiHWKv.fr180 --pass x --log 2 --fee 0 --templimit 90 --pec
SET Server2BatCommand=%MinerProcess% --server eu1-zcash.flypool.org --port 3333 --user t1S8HRoMoyhBhwXq6zY5vHwqhd9MHSiHWKv.fr180 --pass x --log 2 --fee 0 --templimit 90 --pec
SET Server3BatCommand=%MinerProcess% --server eu1-zcash.flypool.org --port 3333 --user t1S8HRoMoyhBhwXq6zY5vHwqhd9MHSiHWKv.fr180 --pass x --log 2 --fee 0 --templimit 90 --pec
SET Server4BatCommand=%MinerProcess% --server eu1-zcash.flypool.org --port 3333 --user t1S8HRoMoyhBhwXq6zY5vHwqhd9MHSiHWKv.fr180 --pass x --log 2 --fee 0 --templimit 90 --pec
SET Server5BatCommand=%MinerProcess% --server eu1-zcash.flypool.org --port 3333 --user t1S8HRoMoyhBhwXq6zY5vHwqhd9MHSiHWKv.fr180 --pass x --log 2 --fee 0 --templimit 90 --pec
SET EveryHourMinerAutoRestart=0
SET EveryHourComputerAutoRestart=0
SET MiddayAutoRestart=0
SET MidnightAutoRestart=0
SET EnableInternetConnectivityCheck=1
SET EnableGPUEnvironments=0
SET RigName=%COMPUTERNAME%
SET ChatId=0
SET EnableEveryHourInfoSend=0
SET EnableAPAutorun=0
SET APProcessName=TeamViewer.exe
SET APProcessPath=C:\Program Files (x86)\TeamViewer\TeamViewer.exe
REM Attention. Do not touch the options below in any case.
:checkconfig
timeout.exe /T 2 /nobreak >NUL
IF EXIST "config.bat" (
	findstr.exe /C:"%Version%" config.bat >NUL && (
		FOR %%A IN (%~n0.bat) DO IF %%~ZA LSS 50000 EXIT
		FOR %%B IN (config.bat) DO (
			IF %%~ZB LSS 4350 (
				ECHO Config.bat file error. It is corrupted.
				>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Config.bat file error. It is corrupted.
			) ELSE (
				CALL config.bat
				ECHO Config.bat loaded.
				>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Config.bat loaded.
				GOTO prestart
			)
		)
	) || (
		CALL config.bat
		ECHO Your config.bat is out of date.
	)
	MOVE /Y config.bat config_backup.bat >NUL && ECHO Created backup of your old config.bat.
)
> config.bat ECHO @ECHO off
>> config.bat ECHO REM Configuration file v. %Version%
>> config.bat ECHO REM =================================================== [Overclock program]
>> config.bat ECHO REM Enable GPU Overclock control monitor. [0 - false, 1 - true XTREMEGE, 2 - true AFTERBURNER, 3 - true GPUTWEAK, 4 - true PRECISION, 5 - true AORUSGE]
>> config.bat ECHO REM Autorun and run-check of GPU Overclock programs.
>> config.bat ECHO SET EnableGPUOverclockMonitor=%EnableGPUOverclockMonitor%
>> config.bat ECHO REM Additional option to auto-enable Overclock Profile for MSI Afterburner. [0 - false, 1 - Profile 1, 2 - Profile 2, 3 - Profile 3, 4 - Profile 4, 5 - Profile 5]
>> config.bat ECHO SET AutorunMSIAWithProfile=%AutorunMSIAWithProfile%
>> config.bat ECHO REM Allow Overclock programs to be restarted when miner is restarted. Please, do not use this option if it is not needed. [0 - false, 1 - true]
>> config.bat ECHO SET RestartGPUOverclockMonitor=%RestartGPUOverclockMonitor%
>> config.bat ECHO REM =================================================== [GPU]
>> config.bat ECHO REM Set how many GPU devices are enabled.
>> config.bat ECHO SET NumberOfGPUs=%NumberOfGPUs%
>> config.bat ECHO REM Allow computer restart if number of loaded GPUs is not equal to number of enabled GPUs. [0 - false, 1 - true]
>> config.bat ECHO SET AllowRestartGPU=%AllowRestartGPU%
>> config.bat ECHO REM Set total average hashrate of this Rig. [you can use average hashrate value from your pool]
>> config.bat ECHO SET AverageTotalHashrate=%AverageTotalHashrate%
>> config.bat ECHO REM =================================================== [Miner]
>> config.bat ECHO REM Set main server miner command here to auto-create %MinerBat% file if it is missing or wrong. [keep default order]
>> config.bat ECHO SET Server1BatCommand=%Server1BatCommand%
>> config.bat ECHO REM When the main server fails, %~n0 will switch to the additional server below immediately. [in order]
>> config.bat ECHO REM Configure miner command here. Old %MinerBat% will be removed and a new one will be created with this value. [keep default order] EnableInternetConnectivityCheck=1 required.
>> config.bat ECHO SET Server2BatCommand=%Server2BatCommand%
>> config.bat ECHO SET Server3BatCommand=%Server3BatCommand%
>> config.bat ECHO SET Server4BatCommand=%Server4BatCommand%
>> config.bat ECHO SET Server5BatCommand=%Server5BatCommand%
>> config.bat ECHO REM =================================================== [Timers]
>> config.bat ECHO REM Restart MINER every X hours. Set value of hours delay between miner restarts. [0 - false, 1-999 - scheduled hours delay]
>> config.bat ECHO SET EveryHourMinerAutoRestart=%EveryHourMinerAutoRestart%
>> config.bat ECHO REM Restart COMPUTER every X hours. Set value of hours delay between computer restarts. [0 - false, 1-999 - scheduled hours delay]
>> config.bat ECHO SET EveryHourComputerAutoRestart=%EveryHourComputerAutoRestart%
>> config.bat ECHO REM Restart miner or computer every day at 12:00. [1 - true miner, 2 - true computer, 0 - false]
>> config.bat ECHO SET MiddayAutoRestart=%MiddayAutoRestart%
>> config.bat ECHO REM Restart miner or computer every day at 00:00. [1 - true miner, 2 - true computer, 0 - false]
>> config.bat ECHO SET MidnightAutoRestart=%MidnightAutoRestart%
>> config.bat ECHO REM =================================================== [Other]
>> config.bat ECHO REM Enable Internet connectivity check. [0 - false, 1 - true]
>> config.bat ECHO REM Disable Internet connectivity check only if you have difficulties with your connection. [ie. high latency, intermittent connectivity]
>> config.bat ECHO SET EnableInternetConnectivityCheck=%EnableInternetConnectivityCheck%
>> config.bat ECHO REM Enable additional environments. Please do not use this option if it is not needed, or if you do not understand its function. [0 - false, 1 - true]
>> config.bat ECHO REM GPU_FORCE_64BIT_PTR 0, GPU_MAX_HEAP_SIZE 100, GPU_USE_SYNC_OBJECTS 1, GPU_MAX_ALLOC_PERCENT 100, GPU_SINGLE_ALLOC_PERCENT 100
>> config.bat ECHO SET EnableGPUEnvironments=%EnableGPUEnvironments%
>> config.bat ECHO REM =================================================== [Telegram notifications]
>> config.bat ECHO REM To enable Telegram notifications enter here your ChatId, from Telegram @FarmWatchBot. [0 - disable]
>> config.bat ECHO SET ChatId=%ChatId%
>> config.bat ECHO REM Name your Rig. [in English, without special symbols]
>> config.bat ECHO SET RigName=%RigName%
>> config.bat ECHO REM Enable hourly statistics through Telegram. [0 - false, 1 - true full, 2 - true full in silent mode, 3 - true short, 4 - true short in silent mode]
>> config.bat ECHO SET EnableEveryHourInfoSend=%EnableEveryHourInfoSend%
>> config.bat ECHO REM =================================================== [Additional program]
>> config.bat ECHO REM Enable additional program check on startup. [ie. TeamViewer, Minergate, Storj etc] [0 - false, 1 - true]
>> config.bat ECHO SET EnableAPAutorun=%EnableAPAutorun%
>> config.bat ECHO REM Process name of additional program. [Press CTRL+ALT+DEL to find the process name]
>> config.bat ECHO SET APProcessName=%APProcessName%
>> config.bat ECHO REM Path to file of additional program. [ie. C:\Program Files\TeamViewer\TeamViewer.exe]
>> config.bat ECHO SET APProcessPath=%APProcessPath%
ECHO Default config.bat created.
ECHO Please check it and restart %~n0.bat.
>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Default config.bat created. Please check it and restart %~n0.bat.
GOTO checkconfig
:restart
COLOR 4F
ECHO Computer restarting...
tskill.exe /A /V %GPUOverclockProcess% 2>NUL 1>&2 && ECHO Process %GPUOverclockProcess%.exe was successfully killed.
taskkill.exe /F /IM "%MinerProcess%" 2>NUL 1>&2 && ECHO Process %MinerProcess% was successfully killed.
timeout.exe /T 5 /nobreak >NUL
taskkill.exe /F /FI "IMAGENAME eq cmd.exe" /FI "WINDOWTITLE eq %MinerBat%*" 2>NUL 1>&2
IF %EnableAPAutorun% EQU 1 taskkill.exe /F /IM "%APProcessName%" 2>NUL 1>&2 && ECHO Process %APProcessName% was successfully killed.
IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Computer restarting...')" 2>NUL 1>&2
>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Computer restarting...
shutdown.exe /T 30 /R /F /C "Your computer will restart after 30 seconds. To cancel restart, close this window and start %~n0.bat manually."
EXIT
:switch
CLS
ECHO +================================================================+
ECHO           Attempting to switch to the main pool server...
ECHO                        Miner ran for %HrDiff%:%MeDiff%:%SsDiff%
ECHO                         Miner restarting...
ECHO +================================================================+
IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Attempting to switch to the main pool server...')" 2>NUL 1>&2
>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Attempting to switch to the main pool server...
GOTO hardstart
:ctimer
CLS
ECHO +================================================================+
ECHO             Scheduled computer restart, please wait...
ECHO                        Miner ran for %HrDiff%:%MeDiff%:%SsDiff%
ECHO                            Restarting...
ECHO +================================================================+
IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Scheduled computer restart, please wait...')" 2>NUL 1>&2
>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Scheduled computer restart, please wait... Miner ran for %HrDiff%:%MeDiff%:%SsDiff%.
GOTO restart
:mtimer
CLS
ECHO +================================================================+
ECHO               Scheduled miner restart, please wait...
ECHO                        Miner ran for %HrDiff%:%MeDiff%:%SsDiff%
ECHO                            Restarting...
ECHO +================================================================+
IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Scheduled miner restart, please wait...')" 2>NUL 1>&2
>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Scheduled miner restart, please wait... Miner ran for %HrDiff%:%MeDiff%:%SsDiff%.
GOTO hardstart
:error
CLS
COLOR 4F
SET /A ErrorsCounter+=1
IF %ErrorsCounter% GEQ %ErrorsAmount% (
	ECHO +================================================================+
	ECHO              Too many errors, need clear GPU cash...
	ECHO                        Miner ran for %HrDiff%:%MeDiff%:%SsDiff%
	ECHO                       Computer restarting...
	ECHO +================================================================+
	>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Too many errors. A restart of the computer to clear GPU cache is required. Restarting... Miner ran for %HrDiff%:%MeDiff%:%SsDiff%.
	GOTO restart
)
ECHO +================================================================+
ECHO                        Something is wrong...
ECHO                        Miner ran for %HrDiff%:%MeDiff%:%SsDiff%
ECHO                         Miner restarting...
ECHO +================================================================+
IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Miner restarting...')" 2>NUL 1>&2
>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Miner restarting... Miner ran for %HrDiff%:%MeDiff%:%SsDiff%.
:prestart
SET AverageTotalHashrate=%AverageTotalHashrate: =%
SET NumberOfGPUs=%NumberOfGPUs: =%
SET ChatId=%ChatId: =%
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
ECHO Please wait or press any key to continue...
timeout.exe /T 30 >NUL
:start
FOR /F "tokens=1 delims=." %%A IN ('wmic.exe OS GET localdatetime^|Find "."') DO SET DT1=%%A
SET Mh1=1%DT1:~4,2%
SET Dy1=1%DT1:~6,2%
SET Hr1=1%DT1:~8,2%
SET Me1=1%DT1:~10,2%
SET Ss1=1%DT1:~12,2%
SET /A Mh1=%Mh1%-100
SET /A Dy1=%Dy1%-100
SET /A Hr1=%Hr1%-100
SET /A Me1=%Me1%-100
SET /A Ss1=%Ss1%-100
SET /A DTDiff1=%Hr1%*60*60+%Me1%*60+%Ss1%
IF NOT EXIST "%MinerProcess%" (
	ECHO "%MinerProcess%" is missing. Please check the directory for missing files. Exiting...
	PAUSE
	EXIT
)
IF NOT EXIST "Logs" MD Logs && ECHO Folder Logs created.
IF %EnableGPUOverclockMonitor% EQU 1 (
	SET GPUOverclockProcess=Xtreme
	SET GPUOverclockPath=\GIGABYTE\XTREME GAMING ENGINE\
)
IF %EnableGPUOverclockMonitor% EQU 2 (
	SET GPUOverclockProcess=MSIAfterburner
	SET GPUOverclockPath=\MSI Afterburner\
)
IF %EnableGPUOverclockMonitor% EQU 3 (
	SET GPUOverclockProcess=GPUTweakII
	SET GPUOverclockPath=\ASUS\GPU TweakII\
)
IF %EnableGPUOverclockMonitor% EQU 4 (
	SET GPUOverclockProcess=PrecisionX_x64
	SET GPUOverclockPath=\EVGA\Precision XOC\
)
IF %EnableGPUOverclockMonitor% EQU 5 (
	SET GPUOverclockProcess=AORUS
	SET GPUOverclockPath=\GIGABYTE\AORUS GRAPHICS ENGINE\
)
IF %EnableGPUOverclockMonitor% GTR 0 IF %EnableGPUOverclockMonitor% LEQ 5 (
	IF NOT EXIST "%programfiles(x86)%%GPUOverclockPath%" (
		ECHO Incorrect path to %GPUOverclockProcess%.exe. Default install path required to function. Please reinstall the software using the default path.
		SET EnableGPUOverclockMonitor=0
	) ELSE (
		IF !FirstRun! NEQ 0 IF %RestartGPUOverclockMonitor% EQU 1 (
			tskill.exe /A /V %GPUOverclockProcess% 2>NUL 1>&2
			>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Process %GPUOverclockProcess%.exe was successfully killed.
		)
		timeout.exe /T 5 /nobreak >NUL
		tasklist.exe /FI "IMAGENAME eq %GPUOverclockProcess%.exe" 2>NUL| find.exe /I /N "%GPUOverclockProcess%.exe" >NUL || (
			START "" "%programfiles(x86)%%GPUOverclockPath%%GPUOverclockProcess%.exe" && (
				ECHO %GPUOverclockProcess%.exe was started at %Time:~-11,8%.
				IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* %GPUOverclockProcess%.exe was started.')" 2>NUL 1>&2
				>> %~n0.log ECHO [%Date%][%Time:~-11,8%] %GPUOverclockProcess%.exe was started.
				SET FirstRun=0
			) || (
				ECHO Unable to start %GPUOverclockProcess%.exe.
				IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Unable to start %GPUOverclockProcess%.exe.')" 2>NUL 1>&2
				>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Unable to start %GPUOverclockProcess%.exe.
				SET EnableGPUOverclockMonitor=0
				GOTO hardstart
			)
		)
		IF %AutorunMSIAWithProfile% GEQ 1 IF %AutorunMSIAWithProfile% LEQ 5 IF %EnableGPUOverclockMonitor% EQU 2 (
			IF !FirstRun! EQU 0 (
				ECHO Waiting %MSIADelayTimer% sec. for the full load of Msi Afterburner...
				timeout.exe /T %MSIADelayTimer% >NUL
			)
			"%programfiles(x86)%%GPUOverclockPath%%GPUOverclockProcess%.exe" -Profile%AutorunMSIAWithProfile% >NUL
			SET FirstRun=1
		)
	)
)
IF %EnableAPAutorun% EQU 1 (
	IF NOT EXIST "%APProcessPath%" (
		ECHO Incorrect path to %APProcessName%.
		SET EnableAPAutorun=0
	) ELSE (
		tasklist.exe /FI "IMAGENAME eq %APProcessName%" 2>NUL| find.exe /I /N "%APProcessName%" >NUL || (
			timeout.exe /T 5 /nobreak >NUL
			START /MIN "%APProcessName%" "%APProcessPath%" && (
				ECHO %APProcessName% was started at %Time:~-11,8%.
				IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* %APProcessName% was started.')" 2>NUL 1>&2
				>> %~n0.log ECHO [%Date%][%Time:~-11,8%] %APProcessName% was started.
			) || (
				ECHO Unable to start %APProcessName%.
				IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Unable to start %APProcessName%.')" 2>NUL 1>&2
				>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Unable to start %APProcessName%.
				SET EnableAPAutorun=0
				GOTO hardstart
			)
		)
	)
)
taskkill.exe /F /IM "%MinerProcess%" 2>NUL 1>&2 && (
	timeout.exe /T 5 /nobreak >NUL
	taskkill.exe /F /FI "IMAGENAME eq cmd.exe" /FI "WINDOWTITLE eq %MinerBat%*" 2>NUL 1>&2
	>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Process %MinerProcess% was successfully killed.
	ECHO Process %MinerProcess% was successfully killed.
	ECHO Please wait 30 seconds or press any key to continue...
	timeout.exe /T 30 >NUL
)
IF EXIST "miner.log" (
	MOVE /Y miner.log Logs\miner_%Mh1%.%Dy1%_%Hr1%.%Me1%.log 2>NUL 1>&2 || (
		>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Unable to rename or access miner.log. Attempting to delete miner.log and continue...
		DEL /Q /F "miner.log" >NUL || (
			ECHO Unable to delete miner.log.
			IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Unable to delete miner.log.')" 2>NUL 1>&2
			>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Unable to delete miner.log.
			GOTO hardstart
		)
	) && (
		ECHO miner.log renamed and moved to Logs folder.
		timeout.exe /T 5 /nobreak >NUL
	)
)
IF NOT EXIST "%MinerBat%" (
	> %MinerBat% ECHO @ECHO off
	>> %MinerBat% ECHO TITLE %MinerBat%
	>> %MinerBat% ECHO REM Configure miners command line in config.bat file. Not in %MinerBat%.
	>> %MinerBat% ECHO %Server1BatCommand%
	>> %MinerBat% ECHO EXIT
	ECHO %MinerBat% created. Please check it for errors.
) ELSE (
	IF %SwitchToDefault% EQU 0 (
		findstr.exe /L /C:"%Server1BatCommand%" %MinerBat% 2>NUL 1>&2 || (
			> %MinerBat% ECHO @ECHO off
			>> %MinerBat% ECHO TITLE %MinerBat%
			>> %MinerBat% ECHO REM Configure miners command line in config.bat file. Not in %MinerBat%.
			>> %MinerBat% ECHO %Server1BatCommand%
			>> %MinerBat% ECHO EXIT
		)
	)
)
timeout.exe /T 3 /nobreak >NUL
START "%MinerBat%" "%MinerBat%" && (
	ECHO Miner was started at %Time:~-11,8%.
	IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Miner was started.')" 2>NUL 1>&2
	>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Miner was started. v.%Version%.
	FOR /F "tokens=3 delims= " %%s IN ('findstr.exe /C:"--server" /C:"-zpool" /C:"-epool" %MinerBat%') DO SET CurrServerName=%%s
	timeout.exe /T 30 /nobreak >NUL
) || (
	ECHO Unable to start miner.
	IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Unable to start miner.')" 2>NUL 1>&2
	>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Unable to start miner. v.%Version%.
	GOTO hardstart
)
IF NOT EXIST "miner.log" (
	ECHO miner.log is missing.
	ECHO Check permissions of this folder. This script requires permission to create files.
	ECHO Ensure --log 2 option is added to the miners command line.
	IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* miner.log is missing. Ensure --log 2 option is added to the miners command line. Check permissions of this folder. This script requires permission to create files.')" 2>NUL 1>&2
	>> %~n0.log ECHO [%Date%][%Time:~-11,8%] miner.log is missing. Check permissions of this folder. This script requires permission to create files.
	>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Ensure --log 2 option is added to the miners command line.
	GOTO hardstart
) ELSE (
	ECHO Log monitoring started.
	ECHO Collecting information. Please wait...
	timeout.exe /T 5 /nobreak >NUL
)
SET HashrateErrorsCount=0
SET OldHashrate=0
SET FirstRun=0
SET GPUCount=0
:check
SET InternetErrorsCounter=1
SET MinHashrate=0
SET Hashcount=0
SET LastError=Empty
SET SumHash=0
FOR /F "tokens=1 delims=." %%A IN ('wmic.exe OS GET localdatetime^|Find "."') DO SET DT2=%%A
SET Mh2=1%DT2:~4,2%
SET Dy2=1%DT2:~6,2%
SET Hr2=1%DT2:~8,2%
SET Me2=1%DT2:~10,2%
SET Ss2=1%DT2:~12,2%
SET /A Mh2=%Mh2%-100
SET /A Dy2=%Dy2%-100
SET /A Hr2=%Hr2%-100
SET /A Me2=%Me2%-100
SET /A Ss2=%Ss2%-100
SET /A DTDiff2=%Hr2%*60*60+%Me2%*60+%Ss2%
IF %Dy2% GTR %Dy1% (
	SET /A DTDiff=^(%Dy2%-%Dy1%^)*86400-%DTDiff1%+%DTDiff2%
) ELSE (
	IF %Mh2% NEQ %Mh1% (
		>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Miner must be restarted, please wait...
		GOTO hardstart
	)
	IF %DTDiff2% GEQ %DTDiff1% (
		SET /A DTDiff=%DTDiff2%-%DTDiff1%
	) ELSE (
		SET /A DTDiff=%DTDiff1%-%DTDiff2%
	)
)
SET /A HrDiff=%DTDiff%/60/60
SET /A MeDiff=%DTDiff% %% 3600/60
SET /A SsDiff=%DTDiff% %% 60
IF %HrDiff% LSS 10 SET HrDiff=0%HrDiff%
IF %MeDiff% LSS 10 SET MeDiff=0%MeDiff%
IF %SsDiff% LSS 10 SET SsDiff=0%SsDiff%
IF %MidnightAutoRestart% EQU 1 IF %Dy2% NEQ %Dy1% GOTO mtimer
IF %MidnightAutoRestart% EQU 2 IF %Dy2% NEQ %Dy1% GOTO ctimer
IF %EveryHourMinerAutoRestart% GEQ 1 IF %HrDiff% GEQ %EveryHourMinerAutoRestart% GOTO mtimer
IF %EveryHourComputerAutoRestart% GEQ 1 IF %HrDiff% GEQ %EveryHourComputerAutoRestart% GOTO ctimer
IF %Hr2% NEQ %Hr1% IF %Hr2% EQU 12 (
	IF %MiddayAutoRestart% EQU 1 GOTO mtimer
	IF %MiddayAutoRestart% EQU 2 GOTO ctimer
)
IF %SwitchToDefault% EQU 1 IF %Hr2% NEQ %Hr1% GOTO switch
IF %SwitchToDefault% EQU 1 IF %Me2% EQU 30 GOTO switch
IF !FirstRun! NEQ 0 (
	timeout.exe /T 3 /nobreak >NUL
	FOR /F "tokens=3 delims= " %%A IN ('findstr.exe /R /C:"Total speed: [0-9]* Sol/s" miner.log') DO (
		SET LastHashrate=%%A
		IF !LastHashrate! LSS %AverageTotalHashrate% SET /A MinHashrate+=1
		IF !LastHashrate! EQU 0 SET /A MinHashrate+=1
		SET /A Hashcount+=1
		SET /A SumHash=SumHash+!LastHashrate!
		SET /A SumResult=SumHash/Hashcount
		IF !MinHashrate! GEQ 99 GOTO passaveragecheck
	)
	timeout.exe /T 3 /nobreak >NUL
	FOR /F "tokens=3,5,7,9,11,13,15,17,19,21,23,25,27,29,31 delims=:C " %%a IN ('findstr.exe /R /C:"Temp: GPU.*C.*" miner.log') DO (
		SET CurTemp=Current temp:
		SET GpuNum=0
		FOR %%A IN (%%a %%b %%c %%d %%e %%f %%g %%h %%i %%j %%k %%l %%m %%n %%o) DO (
			IF NOT "%%A" == "" IF %%A GEQ 0 IF %%A LSS 70 SET CurTemp=!CurTemp! G!GpuNum! %%AC,
			IF NOT "%%A" == "" IF %%A GEQ 70 SET CurTemp=!CurTemp! G!GpuNum! *%%AC*,
			SET /A GpuNum+=1
		)
		SET CurTemp=!CurTemp:~0,-1!
	)
	timeout.exe /T 3 /nobreak >NUL
	FOR /F "tokens=2,4,6,8,10,12,14,16,18,20,22,24,26,28,30 delims=:Sol/s " %%a IN ('findstr.exe /R /C:"GPU.*: .* Sol/s .*" miner.log') DO (
		SET CurrSpeed=Current speed:
		SET GpuNum=0
		FOR %%A IN (%%a %%b %%c %%d %%e %%f %%g %%h %%i %%j %%k %%l %%m %%n %%o) DO (
			IF NOT "%%A" == "" IF %%A GEQ 0 SET CurrSpeed=!CurrSpeed! G!GpuNum! %%A Sol/s,
			SET /A GpuNum+=1
		)
		SET CurrSpeed=!CurrSpeed:~0,-1!
		ECHO !CurrSpeed!| findstr.exe /I /R /C:".* 0 Sol/s.*" 2>NUL 1>&2 && SET /A MinHashrate+=1
		IF !MinHashrate! GEQ 99 GOTO passaveragecheck
	)
	timeout.exe /T 3 /nobreak >NUL
	IF !SumResult! NEQ !OldHashrate! (
		IF !SumResult! LSS !OldHashrate! IF !SumResult! LSS %AverageTotalHashrate% (
			IF !HashrateErrorsCount! GEQ %HashrateErrorsAmount% (
				:passaveragecheck
				IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Low hashrate. Average: *!SumResult!/%AverageTotalHashrate%* Last: *!LastHashrate!/%AverageTotalHashrate%*.')" 2>NUL 1>&2
				>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Low hashrate. Average: !SumResult!/%AverageTotalHashrate% Last: !LastHashrate!/%AverageTotalHashrate%.
				GOTO error
			)
			ECHO Abnormal hashrate. Average: !SumResult!/%AverageTotalHashrate% Last: !LastHashrate!/%AverageTotalHashrate%.
			IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Abnormal hashrate. Average: *!SumResult!/%AverageTotalHashrate%* Last: *!LastHashrate!/%AverageTotalHashrate%*.')" 2>NUL 1>&2
			>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Abnormal hashrate. Average: !SumResult!/%AverageTotalHashrate% Last: !LastHashrate!/%AverageTotalHashrate%.
			SET /A HashrateErrorsCount+=1
		)
		SET OldHashrate=!SumResult!
	)
	timeout.exe /T 3 /nobreak >NUL
	IF !PTOS1! GEQ 59 SET PTOS1=0
	IF !PTOS1! LSS %Me2% (
		SET PTOS1=%Me2%
		SET LstShareDiff=0
		SET LstShareMin=-1
		FOR /F "tokens=3 delims=: " %%A IN ('findstr.exe /R /C:"INFO .* share .*" miner.log') DO SET LstShareMin=1%%A
		SET /A LstShareMin=!LstShareMin!-100
		IF !LstShareMin! GEQ 0 IF %Me2% GTR 0 (
			IF !LstShareMin! EQU 0 SET LstShareMin=59
			IF !LstShareMin! LSS %Me2% SET /A LstShareDiff=%Me2%-!LstShareMin!
			IF !LstShareMin! GTR %Me2% SET /A LstShareDiff=!LstShareMin!-%Me2%
			IF !LstShareMin! GTR 50 IF %Me2% LEQ 10 SET /A LstShareDiff=60-!LstShareMin!+%Me2%
			IF !LstShareMin! LEQ 10 IF %Me2% GTR 50 SET /A LstShareDiff=60-%Me2%+!LstShareMin!
			IF !LstShareDiff! GTR 10 (
				IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Long share timeout... !LstShareMin!/%Me2%.')" 2>NUL 1>&2
				>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Long share timeout... !LstShareMin!/%Me2%.
				GOTO error
			)
		)
	)
)
timeout.exe /T 3 /nobreak >NUL
FOR /F "delims=" %%N IN ('findstr.exe /I /R %CriticalErrorsList% %MinerErrorsList% %MinerWarningsList% %InternetErrorsList% %OtherErrorsList% %OtherWarningsList% miner.log ^| findstr.exe /V /R /I /C:".*DevFee.*"') DO SET LastError=%%N
IF "!LastError!" NEQ "Empty" (
	IF %EnableInternetConnectivityCheck% EQU 1 (
		ECHO !LastError!| findstr.exe /I /R %InternetErrorsList% 2>NUL 1>&2 && (
			FOR /F "delims=" %%n IN ('findstr.exe /I /R %InternetErrorsList% %InternetErrorsCancel% miner.log') DO SET LastInternetError=%%n
			ECHO !LastInternetError!| findstr.exe /I /R %InternetErrorsList% >NUL && (
				timeout.exe /T 30 /nobreak >NUL
				FOR /F "delims=" %%n IN ('findstr.exe /I /R %InternetErrorsList% %InternetErrorsCancel% miner.log') DO SET LastInternetError=%%n
				ECHO !LastInternetError!| findstr.exe /I /R %InternetErrorsList% >NUL && (
					IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* !LastError!')" 2>NUL 1>&2
					>> %~n0.log ECHO [%Date%][%Time:~-11,8%] !LastError!
					ping.exe google.com| find.exe /I "TTL=" >NUL && (
						CLS
						COLOR 4F
						taskkill.exe /F /IM "%MinerProcess%" 2>NUL 1>&2
						timeout.exe /T 5 /nobreak >NUL
						taskkill.exe /F /FI "IMAGENAME eq cmd.exe" /FI "WINDOWTITLE eq %MinerBat%*" 2>NUL 1>&2
						ECHO +================================================================+
						ECHO       Check config.bat file for errors or pool is offline...
						ECHO                        Miner ran for %HrDiff%:%MeDiff%:%SsDiff%
						ECHO               Miner restarting with default values...
						ECHO +================================================================+
						ECHO Pool server was switched. Please check your config.bat file carefully for spelling errors or incorrect parameters. Otherwise check if the pool you are connecting to is online.
						IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Pool server was switched. Please check your config.bat file carefully for spelling errors or incorrect parameters. Otherwise check if the pool you are connecting to is online.')" 2>NUL 1>&2
						>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Pool server was switched. Please check your config.bat file carefully for spelling errors or incorrect parameters. Otherwise check if the pool you are connecting to is online.
						> %MinerBat% ECHO @ECHO off
						>> %MinerBat% ECHO TITLE %MinerBat%
						>> %MinerBat% ECHO REM Configure miners command line in config.bat file. Not in %MinerBat%.
						SET SwitchToDefault=1
						IF %ServerQueue% EQU 1 (
							>> %MinerBat% ECHO %Server2BatCommand%
							SET ServerQueue=2
						)
						IF %ServerQueue% EQU 2 (
							>> %MinerBat% ECHO %Server3BatCommand%
							SET ServerQueue=3
						)
						IF %ServerQueue% EQU 3 (
							>> %MinerBat% ECHO %Server4BatCommand%
							SET ServerQueue=4
						)
						IF %ServerQueue% EQU 4 (
							>> %MinerBat% ECHO %Server5BatCommand%
							SET ServerQueue=5
						)
						IF %ServerQueue% EQU 5 (
							REM Default pool server settings for debugging. Will be activated only in case of mining failed on all user pool servers, to detect errors. Will be deactivated automatically in 30 minutes and switched back to settings of main pool server.
							>> %MinerBat% ECHO %MinerProcess% --server eu1-zcash.flypool.org --port 3333 --user t1S8HRoMoyhBhwXq6zY5vHwqhd9MHSiHWKv.fr180 --pass x --log 2 --fee 0 --templimit 90 --pec
							SET ServerQueue=1
						)
						>> %MinerBat% ECHO EXIT
						ECHO Default %MinerBat% created. Please check it for errors.
						SET /A ErrorsCounter+=1
						GOTO start
					) || (
						CLS
						COLOR 4F
						ECHO +================================================================+
						ECHO               Something is wrong with your Internet...
						ECHO                        Miner ran for %HrDiff%:%MeDiff%:%SsDiff%
						ECHO                      Attempting to reconnect...
						ECHO +================================================================+
						>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Something is wrong with your Internet. Please check your connection. Miner ran for %HrDiff%:%MeDiff%:%SsDiff%.
						:tryingreconnect
						IF %HrDiff% EQU 0 IF %MeDiff% GEQ 10 IF %InternetErrorsCounter% GTR 10 GOTO restart
						IF %InternetErrorsCounter% GTR 60 GOTO restart
						ECHO Attempt %InternetErrorsCounter% to restore Internet connection.
						SET /A InternetErrorsCounter+=1
						FOR /F "delims=" %%n IN ('findstr.exe /I /R %InternetErrorsList% %InternetErrorsCancel% miner.log') DO SET LastInternetError=%%n
						ECHO !LastInternetError!| findstr.exe /I /R %InternetErrorsCancel% && (
							ECHO +================================================================+
							ECHO                   Connection has been restored...
							ECHO                         Continue mining...
							ECHO +================================================================+
							IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Something was wrong with your Internet. Connection has been restored. Continue mining...')" 2>NUL 1>&2
							>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Something was wrong with your Internet. Connection has been restored. Continue mining...
							GOTO check
						)
						ping.exe google.com| find.exe /I "TTL=" >NUL && GOTO reconnected || (
							timeout.exe /T 60 /nobreak >NUL
							GOTO tryingreconnect
						)
						:reconnected
						ECHO +================================================================+
						ECHO                   Connection has been restored...
						ECHO                         Miner restarting...
						ECHO +================================================================+
						IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Something was wrong with your Internet. Connection has been restored. Miner restarting...')" 2>NUL 1>&2
						>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Something was wrong with your Internet. Connection has been restored. Miner restarting...
						GOTO start
					)
				)
			)
		)
	)
	ECHO !LastError!| findstr.exe /I /R %MinerErrorsList% 2>NUL && (
		IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* !LastError!')" 2>NUL 1>&2
		>> %~n0.log ECHO [%Date%][%Time:~-11,8%] !LastError!
		>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Error from GPU. Voltage or Overclock issue.
		GOTO error
	)
	ECHO !LastError!| findstr.exe /I /R %CriticalErrorsList% 2>NUL && (
		IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* !LastError!')" 2>NUL 1>&2
		>> %~n0.log ECHO [%Date%][%Time:~-11,8%] !LastError!
		>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Critical error from GPU. Voltage or Overclock issue. Miner ran for %HrDiff%:%MeDiff%:%SsDiff%.
		GOTO restart
	)
	ECHO !LastError!| findstr.exe /I /R %MinerWarningsList% 2>NUL && (
		CLS
		COLOR 4F
		ECHO +================================================================+
		ECHO                     Temperature limit reached...
		ECHO                        Miner ran for %HrDiff%:%MeDiff%:%SsDiff%
		ECHO +================================================================+
		ECHO !CurTemp!.
		>> %~n0.log ECHO [%Date%][%Time:~-11,8%] !CurTemp!.
		IF %HrDiff% EQU 0 IF %MeDiff% LSS 10 (
			tskill.exe /A /V %GPUOverclockProcess% >NUL && ECHO Process %GPUOverclockProcess%.exe was successfully killed.
			taskkill.exe /F /IM "%MinerProcess%" 2>NUL 1>&2 && ECHO Process %MinerProcess% was successfully killed.
			timeout.exe /T 5 /nobreak >NUL
			taskkill.exe /F /FI "IMAGENAME eq cmd.exe" /FI "WINDOWTITLE eq %MinerBat%*" 2>NUL 1>&2
			ECHO Please ensure your GPUs have enough air flow.
			ECHO GPUs will now STOP MINING.
			ECHO Waiting for users input...
			IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* !CurTemp!.%%0A%%0ATemperature limit reached. GPUs will now *STOP MINING*. Please ensure your GPUs have enough air flow. *Waiting for users input...*')" 2>NUL 1>&2
			>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Temperature limit reached. GPUs will now STOP MINING. Please ensure your GPUs have enough air flow. Miner ran for %HrDiff%:%MeDiff%:%SsDiff%.
			PAUSE
			GOTO hardstart
		)
		ECHO Fans may be stuck.
		IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* !CurTemp!.%%0A%%0ATemperature limit reached. Fans may be stuck. Attempting to restart computer...')" 2>NUL 1>&2
		>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Temperature limit reached. Fans may be stuck. Miner ran for %HrDiff%:%MeDiff%:%SsDiff%.
		GOTO restart
	)
	ECHO !LastError!| findstr.exe /I /R /V %InternetErrorsList% %MinerErrorsList% %CriticalErrorsList% %MinerWarningsList% %IgnoreErrorsList% 2>NUL && (
		IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* !LastError!')" 2>NUL 1>&2
		>> %~n0.log ECHO [%Date%][%Time:~-11,8%] !LastError!
		>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Unknown error or warning found. Please send this message to developer.
		GOTO error
	)
)
timeout.exe /T 3 /nobreak >NUL
tasklist.exe /FI "IMAGENAME eq %MinerProcess%" 2>NUL| find.exe /I /N "%MinerProcess%" >NUL || (
	IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Process *%MinerProcess%* crashed.')" 2>NUL 1>&2
	>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Process %MinerProcess% crashed.
	GOTO error
)
tasklist.exe /FI "IMAGENAME eq WerFault.exe" 2>NUL| find.exe /I /N "WerFault.exe" >NUL && taskkill.exe /F /IM "WerFault.exe" 2>NUL 1>&2
IF %EnableGPUOverclockMonitor% LEQ 5 IF %EnableGPUOverclockMonitor% GTR 0 (
	timeout.exe /T 3 /nobreak >NUL
	tasklist.exe /FI "IMAGENAME eq %GPUOverclockProcess%.exe" 2>NUL| find.exe /I /N "%GPUOverclockProcess%.exe" >NUL || (
		IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Process %GPUOverclockProcess%.exe crashed.')" 2>NUL 1>&2
		>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Process %GPUOverclockProcess%.exe crashed.
		GOTO error
	)
)
IF %EnableAPAutorun% EQU 1 (
	timeout.exe /T 3 /nobreak >NUL
	tasklist.exe /FI "IMAGENAME eq %APProcessName%" 2>NUL| find.exe /I /N "%APProcessName%" >NUL || (
		IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Process *%APProcessName%* crashed.')" 2>NUL 1>&2
		>> %~n0.log ECHO [%Date%][%Time:~-11,8%] %APProcessName% crashed.
		START /MIN "%APProcessName%" "%APProcessPath%" && (
			ECHO %APProcessName% was started at %Time:~-11,8%.
			IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* %APProcessName% was started.')" 2>NUL 1>&2
			>> %~n0.log ECHO [%Date%][%Time:~-11,8%] %APProcessName% was started.
		) || (
			ECHO Unable to start %APProcessName%.
			IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Unable to start %APProcessName%.')" 2>NUL 1>&2
			>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Unable to start %APProcessName%.
			SET EnableAPAutorun=0
			GOTO hardstart
		)
	)
)
IF !FirstRun! EQU 0 (
	SET FirstRun=1
	timeout.exe /T 20 /nobreak >NUL
	FOR /F "delims=" %%I IN ('findstr.exe /R /C:"CUDA: Device: [0-9]* .* PCI: .*" miner.log') DO SET /A GPUCount+=1
	IF !NumberOfGPUs! EQU 0 SET NumberOfGPUs=!GPUCount!
	IF !NumberOfGPUs! GTR !GPUCount! (
		IF %AllowRestartGPU% EQU 1 (
			CLS
			COLOR 4F
			ECHO +================================================================+
			ECHO              Failed load all GPUs. Number of GPUs: !GPUCount!/!NumberOfGPUs!
			ECHO                        Miner ran for %HrDiff%:%MeDiff%:%SsDiff%
			ECHO                       Computer restarting...
			ECHO +================================================================+
			IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Failed load all GPUs. Number of GPUs *!GPUCount!/!NumberOfGPUs!*.')" 2>NUL 1>&2
			>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Failed load all GPUs. Number of GPUs !GPUCount!/!NumberOfGPUs!. Miner ran for %HrDiff%:%MeDiff%:%SsDiff%.
			GOTO restart
		) ELSE (
			ECHO Failed load all GPUs. Number of GPUs: !GPUCount!/!NumberOfGPUs!.
			IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Failed load all GPUs. Number of GPUs *!GPUCount!/!NumberOfGPUs!*.')" 2>NUL 1>&2
			>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Failed load all GPUs. Number of GPUs !GPUCount!/!NumberOfGPUs!.
			SET /A AverageTotalHashrate=%AverageTotalHashrate%/!NumberOfGPUs!*!GPUCount!
		)
	)
	IF !NumberOfGPUs! LSS !GPUCount! (
		ECHO Loaded too many GPUs. This must be set to a number higher than !NumberOfGPUs! in your config.bat file under NumberOfGPUs. Number of GPUs: !GPUCount!/!NumberOfGPUs!.
		IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Loaded too many GPUs. This must be set to a number higher than *!NumberOfGPUs!* in your *config.bat* file under *NumberOfGPUs*. Number of GPUs *!GPUCount!/!NumberOfGPUs!*.')" 2>NUL 1>&2
		>> %~n0.log ECHO [%Date%][%Time:~-11,8%] Loaded too many GPUs. This must be set to a number higher than !NumberOfGPUs! in your config.bat file under NumberOfGPUs. Number of GPUs: !GPUCount!/!NumberOfGPUs!.
		IF %AllowRestartGPU% EQU 1 GOTO restart
	)
	FOR /F "skip=50 usebackq delims=" %%i IN (`DIR /B /A:-D /O:-D /T:W "%~dp0Logs\"`) DO DEL /F /Q "%~dp0Logs\%%~i"
	GOTO check
)
CLS
COLOR 1F
ECHO +================================================================+
ECHO            AutoRun v.%Version% for EWBF Miner - by Acrefawn
ECHO              ZEC: t1S8HRoMoyhBhwXq6zY5vHwqhd9MHSiHWKv
ECHO               BTC: 1wdJBYkVromPoiYk82JfSGSSVVyFJnenB
ECHO +============================================================[%Time:~-5,2%]+
ECHO Process %MinerProcess% is running...
IF DEFINED CurrServerName ECHO Server: !CurrServerName!
IF DEFINED CurTemp ECHO !CurTemp!.
IF DEFINED CurrSpeed ECHO !CurrSpeed!.
ECHO +================================================================+
IF %EnableGPUOverclockMonitor% EQU 1 ECHO Process %GPUOverclockProcess%.exe is running...
IF %EnableGPUOverclockMonitor% EQU 2 ECHO Process %GPUOverclockProcess%.exe is running...
IF %EnableGPUOverclockMonitor% EQU 3 ECHO Process %GPUOverclockProcess%.exe is running...
IF %EnableGPUOverclockMonitor% EQU 4 ECHO Process %GPUOverclockProcess%.exe is running...
IF %EnableGPUOverclockMonitor% EQU 5 ECHO Process %GPUOverclockProcess%.exe is running...
IF %EnableGPUOverclockMonitor% LEQ 0 ECHO GPU Overclock monitor: Disabled
IF %EnableGPUOverclockMonitor% GEQ 6 ECHO GPU Overclock monitor: Disabled
IF %MidnightAutoRestart% LEQ 0 ECHO Autorestart at 00:00: Disabled
IF %MidnightAutoRestart% GTR 0 ECHO Autorestart at 00:00: Enabled
IF %MiddayAutoRestart% LEQ 0 ECHO Autorestart at 12:00: Disabled
IF %MiddayAutoRestart% GTR 0 ECHO Autorestart at 12:00: Enabled
IF %EveryHourMinerAutoRestart% LEQ 0 ECHO Autorestart miner every hour: Disabled
IF %EveryHourMinerAutoRestart% GTR 0 ECHO Autorestart miner every hour: Enabled
IF %EveryHourComputerAutoRestart% LEQ 0 ECHO Autorestart computer every hour: Disabled
IF %EveryHourComputerAutoRestart% GTR 0 ECHO Autorestart computer every hour: Enabled
IF %ChatId% EQU 0 ECHO Telegram notifications: Disabled
IF %ChatId% NEQ 0 ECHO Telegram notifications: Enabled
IF %EnableAPAutorun% LEQ 0 ECHO Additional program autorun: Disabled
IF %EnableAPAutorun% EQU 1 ECHO Additional program autorun: Enabled
ECHO +================================================================+
ECHO            Runtime errors: %ErrorsCounter%/%ErrorsAmount% Hashrate errors: !HashrateErrorsCount!/%HashrateErrorsAmount% !MinHashrate!/99
ECHO                 GPUs: !GPUCount!/!NumberOfGPUs! Last share timeout: !LstShareDiff!/10
ECHO                 Average Sol/s: !SumResult! Last Sol/s: !LastHashrate!
ECHO                        Miner ran for %HrDiff%:%MeDiff%:%SsDiff%
ECHO +================================================================+
ECHO Now I will take care of your %RigName% and you can take a rest.
IF %ChatId% NEQ 0 (
	IF %Me2% LSS 30 SET AllowSend=1
	IF %AllowSend% EQU 1 IF %Me2% GEQ 30 (
		IF %EnableEveryHourInfoSend% EQU 1 IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Miner has been running for *%HrDiff%:%MeDiff%:%SsDiff%* on !CurrServerName!.%%0AAverage total hashrate: *!SumResult!*.%%0ALast total hashrate: *!LastHashrate!*.%%0A!CurrSpeed!.%%0A!CurTemp!.')" 2>NUL 1>&2 && SET AllowSend=0
		IF %EnableEveryHourInfoSend% EQU 2 IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&disable_notification=true&chat_id=%ChatId%&text=*%RigName%:* Miner has been running for *%HrDiff%:%MeDiff%:%SsDiff%* on !CurrServerName!.%%0AAverage total hashrate: *!SumResult!*.%%0ALast total hashrate: *!LastHashrate!*.%%0A!CurrSpeed!.%%0A!CurTemp!.')" 2>NUL 1>&2 && SET AllowSend=0
		IF %EnableEveryHourInfoSend% EQU 3 IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&chat_id=%ChatId%&text=*%RigName%:* Online, *%HrDiff%:%MeDiff%:%SsDiff%*, *!LastHashrate!*.')" 2>NUL 1>&2 && SET AllowSend=0
		IF %EnableEveryHourInfoSend% EQU 4 IF %ChatId% NEQ 0 powershell.exe -command "(new-object net.webclient).DownloadString('https://api.telegram.org/bot%Num%:%prt%-%rtp%%tpr%/sendMessage?parse_mode=markdown&disable_notification=true&chat_id=%ChatId%&text=*%RigName%:* Online, *%HrDiff%:%MeDiff%:%SsDiff%*, *!LastHashrate!*.')" 2>NUL 1>&2 && SET AllowSend=0
	)
)
GOTO check