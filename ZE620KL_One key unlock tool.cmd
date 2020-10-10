@chcp 950>nul
@ECHO OFF

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: INITIALIZE                                                                         ::
::                                                                              ::

:INITIALIZE

color 3f

set device_name=ASUS ZenFone 5(2018) ZE620KL
TITLE %device_name% _One Key Unlock Tool
set tool_name=ZE620KL_One Key Unlock Tiol
set tool_ver=V2
set tool_auth=游晨烯 and Edward Wu
set tool_team=就是愛刷機
set tool_date=2020.10.10
cd /d "%~dp0"

CLS
ECHO:
ECHO:         %device_name% One Key Unlock Tool
ECHO:*********************************************************
ECHO:
ECHO:                 Unlock Script Information
ECHO:
ECHO:              Script Name：%tool_name%
ECHO:              Script Version：%tool_ver%
ECHO:              Applicable Device：%device_name%
ECHO:              Script Author：%tool_auth%
ECHO:              Team Name：%tool_team%
ECHO:              Build Date：%tool_date%
ECHO:           
ECHO:     （Support System Status and fastboot mode）    
ECHO:*********************************************************
ECHO:
ECHO:                  setup.......

::                                                                              ::
::                                                                              ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


adb.exe start-server >nul 2>nul
adb.exe kill-server >nul 2>nul
adb.exe start-server >nul 2>nul

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: LOGO                                                                         ::
::                                                                              ::

:LOGO
CLS
ECHO:
ECHO:         %device_name% One Key Unlock Tool
ECHO:*********************************************************
ECHO:
ECHO:                 Unlock Script Information
ECHO:
ECHO:              Script Name：%tool_name%
ECHO:              Script Version：%tool_ver%
ECHO:              Applicable Device：%device_name%
ECHO:              Script Author：%tool_auth%
ECHO:              Team Name：%tool_team%
ECHO:           
ECHO:           
ECHO:     （Support System Status and fastboot mode）    
ECHO:*********************************************************
ECHO:
ECHO:Press any key to continue...
pause>nul

::                                                                              ::
::                                                                              ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: DETECT_STATE                                                                 ::
::                                                                              ::

:DETECT_STATE

:: Watch device status
:: 1. system , disable USB Debug
:: 2. system , enable USB Debug
:: 3. Bootloader mode
:: run adb get-state

:: Get fastboot devices
:: J5AZB7608107BBK fastboot
for /f "delims=" %%i in ('fastboot.exe devices') do ( set "FASTBOOTSTATE=%%i")
if "%FASTBOOTSTATE:~-8,8%" == "fastboot" do ( goto GET_UNLOCK_ABILITY )
:: Get adb get-state
:: device
for /f "delims=" %%i in ('adb.exe get-state') do ( set "ADBSTATE=%%i")
if "%ADBSTATE%" == "device" ( goto START_AT_ADB ) else ( goto IN_SYSTEM )

::                                                                              ::
::                                                                              ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: IN_STSTEM                                                                    ::
::                                                                              ::

:IN_SYSTEM
CLS
ECHO:
ECHO:         %device_name% _One Key Unlock Tool
ECHO:*********************************************************
ECHO:
ECHO:   Please correct connect your phone to Computer:
ECHO:
ECHO:
ECHO:            Check：
ECHO:      【1.Phone is already in system.】
ECHO:      【2.Phone already enable USB Debug.】
ECHO:      【3.Computer already installed driver.】
ECHO:      【4.When phone show USB Debug , always kick allow.】
ECHO:
ECHO:
ECHO:*********************************************************
ECHO:
CHOICE /c y /n /m "       [Y] I'm confirm all 4 steps are already done."
goto START_AT_ADB

::                                                                              ::
::                                                                              ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: START_AT_ADB                                                                 ::
::                                                                              ::

:START_AT_ADB
adb.exe reboot bootloader
CLS
ECHO:
ECHO:         %device_name% _One Key Unlock Tool
ECHO:*********************************************************
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:             Waiting for device reboot...
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:*********************************************************
ECHO:
timeout /t 5 >nul
goto GET_UNLOCK_ABILITY

::                                                                              ::
::                                                                              ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: GET_UNLOCK_ABILITY                                                           ::
::                                                                              ::

:GET_UNLOCK_ABILITY

CLS
ECHO:
ECHO:         %device_name% _One Key Unlock Tool
ECHO:*********************************************************
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:             Obtaining unlock permission...
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:*********************************************************
ECHO:
ECHO:      （If OKAY appears, succeed, otherwise fail）
ECHO:
ECHO:    （If you stay on this interface for a long time, please restart this tool）
ECHO:

for /f "delims=" %%i in ('fastboot.exe devices') do ( set "FASTBOOTSTATE=%%i")
if not "%FASTBOOTSTATE:~-8,8%" == "fastboot" (
	timeout /t 2 >nul
	goto GET_UNLOCK_ABILITY
)

:: Check if already have ability
for /f %%i in ('fastboot.exe flashing get_unlock_ability') do (set "unlock_ability=%%i")
set "unlock_ability=%unlock_ability:~33,1%"
if /i "%unlock_ability%" == "1" (
	goto UNLOCKING
)


:: Get unlock token and store it into secret.txt 

for /f %%i in ('fastboot.exe getvar secret-key-opt') do (set "utoken=%%i") 
set "utoken=%utoken:~16,100%"
ECHO %utoken%>secret.txt

:: Get random partition code 

for /f %%i in ('fastboot.exe oem get_random_partition') do (set "rpart=%%i")
set "rpart=%rpart:~13,100%"
fastboot.exe flash %rpart% secret.txt
del secret.txt

:: Check if success 

for /f %%i in ('fastboot.exe flashing get_unlock_ability') do (set "unlock_ability=%%i")
set "unlock_ability=%unlock_ability:~33,1%"
if /i not "%unlock_ability%" == "1" (
	goto LOCKFAILED
)
CLS
echo:
echo:
echo:                    OKAY
echo:
echo:
timeout /t 3 >nul
goto UNLOCKING

::                                                                              ::
::                                                                              ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: UNLOCKING                                                                    ::
::                                                                              ::

:UNLOCKING
for /f %%i in ('fastboot.exe flashing get_unlock_ability') do (set "unlock_ability=%%i")
set "unlock_ability=%unlock_ability:~33,1%"
if /i not "%unlock_ability%" == "1" (
	fastboot.exe flashing unlock_critical
)

:: Check unlocked state
setlocal enabledelayedexpansion
set /a cLine=0
for /f %%i in ('fastboot.exe oem device-info') do (
	set /a cLine = !cLine! + 1
	if !cLine! == 3 (
		set "CUNLOCKED=%%i"
	)
)
:: output
:: (bootloader) Verity mode: true
:: (bootloader) Device unlocked: true
:: (bootloader) Device critical unlocked: true
:: (bootloader) Charger screen enabled: true
:: (bootloader) ABL Info: Q-ZE620KL202003
:: (bootloader) SSN: XXXXXXXXXXXXXXX
:: OKAY [ 0.008s]
:: Finished. Total time: 0.009s
endlocal &(
	set "CUNLOCKED=%CUNLOCKED:~-4,4%"
)
if "%CUNLOCKED%" == "true"(
	goto UNLOCKED
) else (
	goto LOCKFAILED
)

:RELOCKING
for /f %%i in ('fastboot.exe flashing get_unlock_ability') do (set "unlock_ability=%%i")
set "unlock_ability=%unlock_ability:~33,1%"
if /i not "%unlock_ability%" == "1" (
	fastboot.exe flashing lock_critical
)

:: Check unlocked state
setlocal enabledelayedexpansion
set /a cLine=0
for /f %%i in ('fastboot.exe oem device-info') do (
	set /a cLine = !cLine! + 1
	if !cLine! == 3 (
		set "CUNLOCKED=%%i"
	)
)
:: output
:: (bootloader) Verity mode: true
:: (bootloader) Device unlocked: true
:: (bootloader) Device critical unlocked: true
:: (bootloader) Charger screen enabled: true
:: (bootloader) ABL Info: Q-ZE620KL202003
:: (bootloader) SSN: XXXXXXXXXXXXXXX
:: OKAY [ 0.008s]
:: Finished. Total time: 0.009s
endlocal &(
	set "CUNLOCKED=%CUNLOCKED:~-4,4%"
)
if "%CUNLOCKED%" == "true"(
	goto LOCKFAILED
) else (
	goto RELOCKED
)

::                                                                              ::
::                                                                              ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:UNLOCKED
CLS
ECHO:
ECHO:         %device_name% _One Key Unlock Tool
ECHO:*********************************************************
ECHO:
ECHO:             Already finished script.
ECHO:
ECHO:              Device will be rebooting.
ECHO:            （Maybe will reboot 1-2 times）
ECHO:
ECHO:
ECHO:           %tool_auth% Thank you to using this tool.
ECHO:
ECHO:           （Press any key to close this window.）
ECHO:
ECHO:*********************************************************
ECHO:
fastboot.exe reboot
pause >NUL

EXIT

:RELOCKED
CLS
ECHO:
ECHO:         %device_name% _One Key Unlock Tool
ECHO:*********************************************************
ECHO:
ECHO:             Already finished lock script.
ECHO:
ECHO:              Device will be rebooting.
ECHO:            （Maybe will reboot 1-2times）
ECHO:
ECHO:
ECHO:           %tool_auth% Thank you to using this tool.
ECHO:
ECHO:           （Press any key to close this window.）
ECHO:
ECHO:*********************************************************
ECHO:
fastboot.exe reboot
pause >NUL

EXIT

:LOCKFAILED
ECHO:
ECHO: ！！Failed！！
timeout /t 6 /nobreak >NUL
CLS
ECHO:
ECHO:         %device_name% _One Key Unlock Tool
ECHO:*********************************************************
ECHO:
ECHO:                   Flashing falied！
ECHO:
ECHO:           1.Please check device correct or not.
ECHO:           2.Please check fastboot work it or not.
ECHO:           3.Re-unzip and try to run this program again.
ECHO:           If it still not work, please connect author.
ECHO:
ECHO:           %tool_auth% Thank you to using this tool.
ECHO:
ECHO:            （Press any key to close this window.）
ECHO:*********************************************************
ECHO:
timeout /t 1 /nobreak >NUL
pause >NUL
EXIT
