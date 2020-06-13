@chcp 950>nul
@ECHO OFF

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: INITIALIZE                                                                         ::
::                                                                              ::

:INITIALIZE

color f0

set device_name=ASUS ZenFone 5(2018) ZE620KL
TITLE %device_name% _�@�����u��
set tool_name=ZE620KL_�@�����u��
set tool_ver=V2
set tool_auth=���m
set tool_team=�N�O�R���
set tool_date=2020.06.13
cd /d "%~dp0"

CLS
ECHO:
ECHO:         %device_name% �@�����u��
ECHO:*********************************************************
ECHO:
ECHO:                 ����}���򥻸��
ECHO:
ECHO:              �}���W�١G%tool_name%
ECHO:              �}�������G%tool_ver%
ECHO:              �A�ξ����G%device_name%
ECHO:              �}���@�̡G%tool_auth%
ECHO:              �ζ��W�١G%tool_team%
ECHO:           
ECHO:           
ECHO:     �]����}�����A��J�Mfastboot�Ҧ���J�^    
ECHO:*********************************************************
ECHO:
ECHO:                  ��l�Ƥ�.......

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
ECHO:         %device_name% �@�����u��
ECHO:*********************************************************
ECHO:
ECHO:                 ����}���򥻸��
ECHO:
ECHO:              �}���W�١G%tool_name%
ECHO:              �}�������G%tool_ver%
ECHO:              �A�ξ����G%device_name%
ECHO:              �}���@�̡G%tool_auth%
ECHO:              �ζ��W�١G%tool_team%
ECHO:           
ECHO:           
ECHO:     �]����}�����A��J�Mfastboot�Ҧ���J�^    
ECHO:*********************************************************
ECHO:
ECHO:�����N���~��...
pause>nul

::                                                                              ::
::                                                                              ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: DETECT_STATE                                                                 ::
::                                                                              ::

:DETECT_STATE

:: �ݤ���b
:: 1. �}�����A�A�S���}�Ұ����Ҧ�
:: 2. �}�����A�A���}�Ұ����Ҧ�
:: 3. Bootloader�Ҧ��U
:: ����adb get-state

:: fastboot devices �o��
:: J5AZB7608107BBK fastboot
for /f "delims=" %%i in ('fastboot.exe devices') do ( set "FASTBOOTSTATE=%%i")
if "%FASTBOOTSTATE:~-8,8%" == "fastboot" do ( goto GET_UNLOCK_ABILITY )
:: adb get-state �o��
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
ECHO:         %device_name% _�@�����u��
ECHO:*********************************************************
ECHO:
ECHO:          �бz�N������T�s����q���G
ECHO:
ECHO:
ECHO:            �нT�O�G
ECHO:      �i1.����B��}�����A�j
ECHO:      �i2.����}��USB�����j
ECHO:      �i3.�q���W�w�g���T�w���X�ʡj
ECHO:      �i4.������USB�������v�ɤĿ�l���I�����v�j
ECHO:
ECHO:
ECHO:*********************************************************
ECHO:
CHOICE /c y /n /m "       [Y] �ڤw�T�{�W�z 4 �Ӱʧ@�Ҥw����"
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
ECHO:         %device_name% _�@�����u��
ECHO:*********************************************************
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:             ���ݤ�����s�}����...
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
ECHO:         %device_name% _�@�����u��
ECHO:*********************************************************
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:             ���b���o����\�i...
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:*********************************************************
ECHO:
ECHO:      �]�Y�X�{ OKAY ���o���\�A�_�h���ѡ^
ECHO:
ECHO:    �]�Y���ɶ����d�b���ɭ��A�Э��ҥ��u��^
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
:: ��X
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
:: ��X
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
ECHO:         %device_name% _�@�����u��
ECHO:*********************************************************
ECHO:
ECHO:             �������}������
ECHO:
ECHO:              ����N���}��
ECHO:            �]�i��|���}��1-2���^
ECHO:
ECHO:
ECHO:           %tool_auth%�P�±z�ϥΥ��u��
ECHO:
ECHO:           �]�����N�������������^
ECHO:
ECHO:*********************************************************
ECHO:
fastboot.exe reboot
pause >NUL

EXIT

:RELOCKED
CLS
ECHO:
ECHO:         %device_name% _�@�����u��
ECHO:*********************************************************
ECHO:
ECHO:             ����W��}������
ECHO:
ECHO:              ����N���}��
ECHO:            �]�i��|���}��1-2���^
ECHO:
ECHO:
ECHO:           %tool_auth%�P�±z�ϥΥ��u��
ECHO:
ECHO:           �]�����N�������������^
ECHO:
ECHO:*********************************************************
ECHO:
fastboot.exe reboot
pause >NUL

EXIT

:LOCKFAILED
ECHO:
ECHO: �I�I�X���I�I
timeout /t 6 /nobreak >NUL
CLS
ECHO:
ECHO:         %device_name% _�@�����u��
ECHO:*********************************************************
ECHO:
ECHO:                   ��J���ѡI
ECHO:
ECHO:           1.���ˬd��������O�_���T
ECHO:           2.�нT�{fastboot�O�_���`
ECHO:           3.�����᭫�s�B�楻�{���A
ECHO:           �Y�٬O�����\�A���p���@��
ECHO:
ECHO:           %tool_auth%�P�±z�ϥΥ��u��
ECHO:
ECHO:            �]�����N��h�X�{���^
ECHO:*********************************************************
ECHO:
timeout /t 1 /nobreak >NUL
pause >NUL
EXIT
