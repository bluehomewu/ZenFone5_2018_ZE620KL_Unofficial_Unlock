@chcp 950>nul
@ECHO OFF

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: INITIALIZE                                                                         ::
::                                                                              ::

:INITIALIZE

color f0

set device_name=ASUS ZenFone 5(2018) ZE620KL
TITLE %device_name% _一鍵解鎖工具
set tool_name=ZE620KL_一鍵解鎖工具
set tool_ver=V2
set tool_auth=游晨烯
set tool_team=就是愛刷機
set tool_date=2020.06.13
cd /d "%~dp0"

CLS
ECHO:
ECHO:         %device_name% 一鍵解鎖工具
ECHO:*********************************************************
ECHO:
ECHO:                 解鎖腳本基本資料
ECHO:
ECHO:              腳本名稱：%tool_name%
ECHO:              腳本版本：%tool_ver%
ECHO:              適用機型：%device_name%
ECHO:              腳本作者：%tool_auth%
ECHO:              團隊名稱：%tool_team%
ECHO:           
ECHO:           
ECHO:     （支持開機狀態刷入和fastboot模式刷入）    
ECHO:*********************************************************
ECHO:
ECHO:                  初始化中.......

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
ECHO:         %device_name% 一鍵解鎖工具
ECHO:*********************************************************
ECHO:
ECHO:                 解鎖腳本基本資料
ECHO:
ECHO:              腳本名稱：%tool_name%
ECHO:              腳本版本：%tool_ver%
ECHO:              適用機型：%device_name%
ECHO:              腳本作者：%tool_auth%
ECHO:              團隊名稱：%tool_team%
ECHO:           
ECHO:           
ECHO:     （支持開機狀態刷入和fastboot模式刷入）    
ECHO:*********************************************************
ECHO:
ECHO:按任意鍵繼續...
pause>nul

::                                                                              ::
::                                                                              ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: DETECT_STATE                                                                 ::
::                                                                              ::

:DETECT_STATE

:: 看手機在
:: 1. 開機狀態，沒有開啟偵錯模式
:: 2. 開機狀態，有開啟偵錯模式
:: 3. Bootloader模式下
:: 執行adb get-state

:: fastboot devices 得到
:: J5AZB7608107BBK fastboot
for /f "delims=" %%i in ('fastboot.exe devices') do ( set "FASTBOOTSTATE=%%i")
if "%FASTBOOTSTATE:~-8,8%" == "fastboot" do ( goto GET_UNLOCK_ABILITY )
:: adb get-state 得到
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
ECHO:         %device_name% _一鍵解鎖工具
ECHO:*********************************************************
ECHO:
ECHO:          請您將手機正確連接到電腦：
ECHO:
ECHO:
ECHO:            請確保：
ECHO:      【1.手機處於開機狀態】
ECHO:      【2.手機開啟USB偵錯】
ECHO:      【3.電腦上已經正確安裝驅動】
ECHO:      【4.手機顯示USB偵錯授權時勾選始終點擊授權】
ECHO:
ECHO:
ECHO:*********************************************************
ECHO:
CHOICE /c y /n /m "       [Y] 我已確認上述 4 個動作皆已完成"
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
ECHO:         %device_name% _一鍵解鎖工具
ECHO:*********************************************************
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:             等待手機重新開機中...
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
ECHO:         %device_name% _一鍵解鎖工具
ECHO:*********************************************************
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:             正在取得解鎖許可...
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:*********************************************************
ECHO:
ECHO:      （若出現 OKAY 取得成功，否則失敗）
ECHO:
ECHO:    （若長時間停留在此界面，請重啟本工具）
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
:: 輸出
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
:: 輸出
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
ECHO:         %device_name% _一鍵解鎖工具
ECHO:*********************************************************
ECHO:
ECHO:             執行解鎖腳本完成
ECHO:
ECHO:              手機將重開機
ECHO:            （可能會重開機1-2次）
ECHO:
ECHO:
ECHO:           %tool_auth%感謝您使用本工具
ECHO:
ECHO:           （按任意鍵關閉此視窗）
ECHO:
ECHO:*********************************************************
ECHO:
fastboot.exe reboot
pause >NUL

EXIT

:RELOCKED
CLS
ECHO:
ECHO:         %device_name% _一鍵解鎖工具
ECHO:*********************************************************
ECHO:
ECHO:             執行上鎖腳本完成
ECHO:
ECHO:              手機將重開機
ECHO:            （可能會重開機1-2次）
ECHO:
ECHO:
ECHO:           %tool_auth%感謝您使用本工具
ECHO:
ECHO:           （按任意鍵關閉此視窗）
ECHO:
ECHO:*********************************************************
ECHO:
fastboot.exe reboot
pause >NUL

EXIT

:LOCKFAILED
ECHO:
ECHO: ！！出錯！！
timeout /t 6 /nobreak >NUL
CLS
ECHO:
ECHO:         %device_name% _一鍵解鎖工具
ECHO:*********************************************************
ECHO:
ECHO:                   刷入失敗！
ECHO:
ECHO:           1.請檢查手機型號是否正確
ECHO:           2.請確認fastboot是否正常
ECHO:           3.解壓後重新運行本程式，
ECHO:           若還是不成功，請聯絡作者
ECHO:
ECHO:           %tool_auth%感謝您使用本工具
ECHO:
ECHO:            （按任意鍵退出程式）
ECHO:*********************************************************
ECHO:
timeout /t 1 /nobreak >NUL
pause >NUL
EXIT
