@echo off
color 1F
set BATCH_MODE=0
set VERSION=1.0.0

title Starlight Tweaks v%VERSION% - Windows Performance Optimizer
echo ============================================================
echo              STARLIGHT TWEAKS v%VERSION%
echo         Windows Performance Optimizer Batchfile
echo                Powered by Starlight
echo                   by Morphine
echo ============================================================
echo.
echo NOTICE: This tool modifies system configurations and registry.
echo We strongly recommend creating a system restore point and
echo backing up your registry before proceeding with optimizations.
echo.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Administrator privileges required to run this tool.
    echo Right-click and select "Run as Administrator"
    pause
    exit /b
)

echo Create a System Restore Point before optimizing? (Y/N)
set /p restore_choice= 
if /i "%restore_choice%"=="Y" (
    echo [STARLIGHT] Creating system restore point...
    powershell -NoProfile -ExecutionPolicy Bypass -command "Checkpoint-Computer -Description 'Starlight_Tweaks_Backup' -RestorePointType 'MODIFY_SETTINGS'"
    echo [STARLIGHT] Restore point created successfully.
    timeout /t 2 >nul
)

:MainInterface
cls
echo ============================================================
echo              STARLIGHT TWEAKS - Main Menu
echo ============================================================
echo.
echo 1.  System Integrity Scanner (SFC + DISM)
echo 2.  Windows Update Components Reset
echo 3.  Microsoft Store and Apps Repair
echo 4.  Performance Enhancement Suite
echo 5.  Visual Effects and UI Optimization
echo 6.  Privacy Protection Settings
echo 7.  Bloatware Removal Tool
echo 8.  Essential Registry Optimizations
echo 9.  Advanced System Tweaks
echo 10. Network Connectivity Fixes
echo 11. Power and Resource Management
echo 12. Additional System Enhancements
echo 13. Restart Computer
echo 14. Exit Starlight Tweaks
echo.
set /p menu_choice="Select option (1-14): "

if "%menu_choice%"=="1" goto SystemIntegrity
if "%menu_choice%"=="2" goto UpdateReset
if "%menu_choice%"=="3" goto StoreRepair
if "%menu_choice%"=="4" goto PerformanceBoost
if "%menu_choice%"=="5" goto VisualOptimization
if "%menu_choice%"=="6" goto PrivacySettings
if "%menu_choice%"=="7" goto BloatwareRemoval
if "%menu_choice%"=="8" goto RegistryOptimization
if "%menu_choice%"=="9" goto AdvancedOptimizations
if "%menu_choice%"=="10" goto NetworkRepair
if "%menu_choice%"=="11" goto PowerManagement
if "%menu_choice%"=="12" goto SystemEnhancements
if "%menu_choice%"=="13" goto RestartSystem
if "%menu_choice%"=="14" goto ExitProgram
echo [ERROR] Invalid selection. Please try again.
pause
goto MainInterface

:SystemIntegrity
cls
echo ============================================================
echo         STARLIGHT - System Integrity Scanner
echo ============================================================
echo.
call :ExecutionMode
if "%BATCH_MODE%"=="0" (
    call :PromptAndExecute "Running System File Checker scan" "sfc /scannow"
    call :PromptAndExecute "Scanning image health status" "dism /online /cleanup-image /scanhealth"
    call :PromptAndExecute "Checking image health integrity" "dism /online /cleanup-image /checkhealth"
    call :PromptAndExecute "Repairing image health issues" "dism /online /cleanup-image /restorehealth"
) else (
    echo [STARLIGHT] Scanning system files...
    sfc /scannow
    echo [STARLIGHT] Analyzing image health...
    dism /online /cleanup-image /scanhealth
    echo [STARLIGHT] Verifying image integrity...
    dism /online /cleanup-image /checkhealth
    echo [STARLIGHT] Restoring image health...
    dism /online /cleanup-image /restorehealth
)
pause
goto MainInterface

:UpdateReset
cls
echo ============================================================
echo      STARLIGHT - Windows Update Reset Tool
echo ============================================================
call :ExecutionMode
if "%BATCH_MODE%"=="0" (
    call :PromptAndExecute "Stopping Windows Update services" "net stop wuauserv >nul 2>&1 && net stop cryptSvc >nul 2>&1 && net stop bits >nul 2>&1 && net stop msiserver >nul 2>&1"
    call :PromptAndExecute "Clearing update cache directory" "rd /s /q %systemroot%\SoftwareDistribution >nul 2>&1"
    call :PromptAndExecute "Clearing cryptographic services cache" "rd /s /q %systemroot%\system32\catroot2 >nul 2>&1"
    call :PromptAndExecute "Restarting Windows Update services" "net start wuauserv >nul 2>&1 && net start cryptSvc >nul 2>&1 && net start bits >nul 2>&1 && net start msiserver >nul 2>&1"
) else (
    echo [STARLIGHT] Stopping update services...
    net stop wuauserv >nul 2>&1
    net stop cryptSvc >nul 2>&1
    net stop bits >nul 2>&1
    net stop msiserver >nul 2>&1
    echo [STARLIGHT] Clearing update cache...
    rd /s /q %systemroot%\SoftwareDistribution >nul 2>&1
    rd /s /q %systemroot%\system32\catroot2 >nul 2>&1
    echo [STARLIGHT] Restarting services...
    net start wuauserv >nul 2>&1
    net start cryptSvc >nul 2>&1
    net start bits >nul 2>&1
    net start msiserver >nul 2>&1
)
pause
goto MainInterface

:StoreRepair
cls
echo ============================================================
echo    STARLIGHT - Microsoft Store Repair Tool
echo ============================================================
call :ExecutionMode
if "%BATCH_MODE%"=="0" (
    call :PromptAndExecute "Re-registering Microsoft Store components" "powershell -NoProfile -ExecutionPolicy Bypass -command \"Get-AppxPackage *WindowsStore* | Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register \\\"$($_.InstallLocation)\\\\AppxManifest.xml\\\"}\""
    call :PromptAndExecute "Re-registering all user applications" "powershell -NoProfile -ExecutionPolicy Bypass -command \"Get-AppxPackage -AllUsers | Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register \\\"$($_.InstallLocation)\\\\AppxManifest.xml\\\"}\""
) else (
    echo [STARLIGHT] Repairing Microsoft Store...
    powershell -NoProfile -ExecutionPolicy Bypass -command "Get-AppxPackage *WindowsStore* | Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register \"$($_.InstallLocation)\\AppxManifest.xml\"}"
    echo [STARLIGHT] Re-registering applications...
    powershell -NoProfile -ExecutionPolicy Bypass -command "Get-AppxPackage -AllUsers | Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register \"$($_.InstallLocation)\\AppxManifest.xml\"}"
)
pause
goto MainInterface

:PerformanceBoost
cls
echo ============================================================
echo       STARLIGHT - Performance Enhancement Suite
echo ============================================================
echo.
call :ExecutionMode
if "%BATCH_MODE%"=="0" (
    call :SecureRegistryUpdate "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" "StartupDelayInMSec" REG_DWORD 0 "Eliminating startup delays"
    call :SecureRegistryUpdate "HKLM\SYSTEM\CurrentControlSet\Control" "WaitToKillServiceTimeout" REG_SZ 2000 "Optimizing shutdown speed"
    call :SecureRegistryUpdate "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" REG_DWORD 10 "Enhancing foreground application priority"
    call :SecureRegistryUpdate "HKCU\Control Panel\Desktop" "MenuShowDelay" REG_SZ 100 "Reducing interface delays"
    call :SecureRegistryUpdate "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" REG_DWORD 4294967295 "Removing network throttling"
    call :PromptAndExecute "Optimizing system timer settings" "bcdedit /deletevalue useplatformclock >nul 2>&1 && bcdedit /set disabledynamictick yes >nul 2>&1"
) else (
    echo [STARLIGHT] Eliminating startup delays...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f >nul
    echo [STARLIGHT] Optimizing shutdown speed...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f >nul
    echo [STARLIGHT] Enhancing application priority...
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 10 /f >nul
    echo [STARLIGHT] Reducing interface delays...
    reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 100 /f >nul
    echo [STARLIGHT] Removing network throttling...
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f >nul
    echo [STARLIGHT] Optimizing system timers...
    bcdedit /deletevalue useplatformclock >nul 2>&1
    bcdedit /set disabledynamictick yes >nul 2>&1
)
echo [STARLIGHT] Performance enhancements completed.
pause
goto MainInterface

:VisualOptimization
cls
echo ============================================================
echo    STARLIGHT - Visual Effects Optimization
echo ============================================================
call :ExecutionMode
if "%BATCH_MODE%"=="0" (
    call :SecureRegistryUpdate "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" REG_DWORD 2 "Optimizing visual effects for performance"
    echo [WARNING] Advanced UI optimization may affect visual appearance.
    call :SecureRegistryUpdate "HKCU\Control Panel\Desktop" "UserPreferencesMask" REG_BINARY 90120000 "Applying advanced UI optimizations"
) else (
    echo [STARLIGHT] Optimizing visual effects...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
    echo [WARNING] Applying advanced UI optimizations...
    reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 90120000 /f >nul
)
echo [STARLIGHT] Visual optimizations applied.
pause
goto MainInterface

:PrivacySettings
cls
echo ============================================================
echo        STARLIGHT - Privacy Protection Suite
echo ============================================================
call :ExecutionMode
if "%BATCH_MODE%"=="0" (
    call :SecureRegistryUpdate "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" REG_DWORD 0 "Disabling telemetry data collection"
    call :SecureRegistryUpdate "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" REG_DWORD 0 "Disabling Cortana voice assistant"
    call :SecureRegistryUpdate "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" "Status" REG_DWORD 0 "Disabling location tracking service"
) else (
    echo [STARLIGHT] Disabling telemetry...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul
    echo [STARLIGHT] Disabling Cortana...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul
    echo [STARLIGHT] Disabling location services...
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v Status /t REG_DWORD /d 0 /f >nul
)
echo [STARLIGHT] Privacy protections activated.
pause
goto MainInterface

:BloatwareRemoval
cls
echo ============================================================
echo        STARLIGHT - Bloatware Removal Tool
echo ============================================================
echo This will permanently remove certain pre-installed applications.
echo These apps can be reinstalled from the Microsoft Store if needed.
echo Do you want to proceed with bloatware removal? (Y/N)
set /p bloat_confirm=
if /i not "%bloat_confirm%"=="Y" (
    echo [STARLIGHT] Bloatware removal cancelled.
    pause
    goto MainInterface
)
call :ExecutionMode
if "%BATCH_MODE%"=="0" (
    call :PromptAndExecute "Removing Xbox Gaming app" "powershell -NoProfile -ExecutionPolicy Bypass -command \"Get-AppxPackage *xboxapp* | Remove-AppxPackage\""
    call :PromptAndExecute "Removing News application" "powershell -NoProfile -ExecutionPolicy Bypass -command \"Get-AppxPackage *bingnews* | Remove-AppxPackage\""
    call :PromptAndExecute "Removing Weather application" "powershell -NoProfile -ExecutionPolicy Bypass -command \"Get-AppxPackage *bingweather* | Remove-AppxPackage\""
    call :PromptAndExecute "Removing Movies & TV app" "powershell -NoProfile -ExecutionPolicy Bypass -command \"Get-AppxPackage *zunevideo* | Remove-AppxPackage\""
    call :PromptAndExecute "Removing Solitaire games" "powershell -NoProfile -ExecutionPolicy Bypass -command \"Get-AppxPackage *solitairecollection* | Remove-AppxPackage\""
) else (
    echo [STARLIGHT] Removing bloatware applications...
    powershell -NoProfile -ExecutionPolicy Bypass -command "Get-AppxPackage *xboxapp* | Remove-AppxPackage"
    powershell -NoProfile -ExecutionPolicy Bypass -command "Get-AppxPackage *bingnews* | Remove-AppxPackage"
    powershell -NoProfile -ExecutionPolicy Bypass -command "Get-AppxPackage *bingweather* | Remove-AppxPackage"
    powershell -NoProfile -ExecutionPolicy Bypass -command "Get-AppxPackage *zunevideo* | Remove-AppxPackage"
    powershell -NoProfile -ExecutionPolicy Bypass -command "Get-AppxPackage *solitairecollection* | Remove-AppxPackage"
)
echo [STARLIGHT] Bloatware removal completed.
pause
goto MainInterface

:RegistryOptimization
cls
echo ============================================================
echo      STARLIGHT - Essential Registry Optimizations
echo ============================================================
call :ExecutionMode
if "%BATCH_MODE%"=="0" (
    call :SecureRegistryUpdate "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableConsumerFeatures" REG_DWORD 1 "Disabling consumer advertising features"
    call :SecureRegistryUpdate "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" REG_DWORD 1 "Disabling promotional content"
    call :SecureRegistryUpdate "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" REG_DWORD 1 "Setting File Explorer default view to This PC"
) else (
    echo [STARLIGHT] Disabling advertising features...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableConsumerFeatures /t REG_DWORD /d 1 /f >nul
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableSoftLanding /t REG_DWORD /d 1 /f >nul
    echo [STARLIGHT] Optimizing File Explorer...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f >nul
)
echo [STARLIGHT] Registry optimizations applied.
pause
goto MainInterface

:AdvancedOptimizations
cls
echo ============================================================
echo       STARLIGHT - Advanced System Tweaks
echo ============================================================
call :ExecutionMode
if "%BATCH_MODE%"=="0" (
    call :PromptAndExecute "Enhancing CPU timer synchronization" "bcdedit /set tscsyncpolicy enhanced >nul 2>&1"
    call :PromptAndExecute "Optimizing platform timing" "bcdedit /deletevalue useplatformtick >nul 2>&1"
    call :PromptAndExecute "Setting legacy boot menu policy" "bcdedit /set bootmenupolicy legacy >nul 2>&1"
    call :SecureRegistryUpdate "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" "EnablePreemption" REG_DWORD 0 "Disabling GPU driver preemption"
    call :SecureRegistryUpdate "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "LargeSystemCache" REG_DWORD 1 "Enabling large system cache"
    call :SecureRegistryUpdate "HKLM\SYSTEM\CurrentControlSet\Services\MMCSS" "Start" REG_DWORD 4 "Disabling multimedia scheduler service"
    call :SecureRegistryUpdate "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" "TcpAckFrequency" REG_DWORD 1 "Optimizing TCP acknowledgment frequency"
    call :PromptAndExecute "Disabling diagnostic tracking services" "sc config DiagTrack start= disabled >nul 2>&1 && sc config dmwappushservice start= disabled >nul 2>&1"
    call :SecureRegistryUpdate "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" REG_DWORD 26 "Optimizing CPU scheduling for gaming"
) else (
    echo [STARLIGHT] Enhancing CPU synchronization...
    bcdedit /set tscsyncpolicy enhanced >nul 2>&1
    echo [STARLIGHT] Optimizing platform timing...
    bcdedit /deletevalue useplatformtick >nul 2>&1
    echo [STARLIGHT] Setting boot menu policy...
    bcdedit /set bootmenupolicy legacy >nul 2>&1
    echo [STARLIGHT] Optimizing graphics drivers...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v EnablePreemption /t REG_DWORD /d 0 /f >nul
    echo [STARLIGHT] Enabling large system cache...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f >nul
    echo [STARLIGHT] Disabling multimedia scheduler...
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\MMCSS" /v Start /t REG_DWORD /d 4 /f >nul
    echo [STARLIGHT] Optimizing TCP settings...
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul
    echo [STARLIGHT] Disabling tracking services...
    sc config DiagTrack start= disabled >nul 2>&1
    sc config dmwappushservice start= disabled >nul 2>&1
    echo [STARLIGHT] Optimizing CPU scheduling...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f >nul
)
echo [STARLIGHT] Advanced optimizations completed.
pause
goto MainInterface

:NetworkRepair
cls
echo ============================================================
echo       STARLIGHT - Network Connectivity Repair
echo ============================================================
echo WARNING: Network settings will be reset. Internet connectivity may be briefly interrupted.
call :ExecutionMode
if "%BATCH_MODE%"=="0" (
    call :PromptAndExecute "Resetting TCP/IP stack configuration" "netsh int ip reset >nul"
    call :PromptAndExecute "Clearing DNS resolver cache" "ipconfig /flushdns >nul"
    call :PromptAndExecute "Resetting Winsock catalog" "netsh winsock reset >nul"
    call :PromptAndExecute "Releasing current IP address" "ipconfig /release >nul"
    call :PromptAndExecute "Renewing IP address assignment" "ipconfig /renew >nul"
) else (
    echo [STARLIGHT] Resetting TCP/IP stack...
    netsh int ip reset >nul
    echo [STARLIGHT] Clearing DNS cache...
    ipconfig /flushdns >nul
    echo [STARLIGHT] Resetting Winsock...
    netsh winsock reset >nul
    echo [STARLIGHT] Releasing IP address...
    ipconfig /release >nul
    echo [STARLIGHT] Renewing IP address...
    ipconfig /renew >nul
)
echo [STARLIGHT] Network repairs completed.
pause
goto MainInterface

:PowerManagement
cls
echo ============================================================
echo      STARLIGHT - Power and Resource Management
echo ============================================================
call :ExecutionMode
if "%BATCH_MODE%"=="0" (
    call :PromptAndExecute "Disabling hibernation to free disk space" "powercfg /h off"
    call :PromptAndExecute "Activating Ultimate Performance power plan" "powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1 && powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1"
    call :PromptAndExecute "Disabling IPv6 on network interfaces" "for /F \"skip=3 tokens=1,*\" %%A in ('netsh interface ipv6 show interfaces') do (netsh interface ipv6 set interface \"%%B\" admin=disabled >nul 2>&1)"
    call :PromptAndExecute "Disabling Windows Search indexing service" "sc config WSearch start= disabled >nul 2>&1 && net stop WSearch >nul 2>&1"
    call :PromptAndExecute "Removing OneDrive integration" "taskkill /f /im OneDrive.exe >nul 2>&1 && %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall >nul 2>&1"
    call :PromptAndExecute "Disabling Action Center notifications" "reg add \"HKCU\Software\Policies\Microsoft\Windows\Explorer\" /v DisableNotificationCenter /t REG_DWORD /d 1 /f >nul"
    call :PromptAndExecute "Clearing temporary files and cache" "del /f /s /q \"%temp%\*.*\" >nul 2>&1 && del /f /s /q \"%SystemRoot%\Temp\*.*\" >nul 2>&1 && del /f /s /q \"%SystemRoot%\Prefetch\*.*\" >nul 2>&1"
    call :PromptAndExecute "Clearing Windows Event Logs" "for /F \"tokens=*\" %%G in ('wevtutil el') do (wevtutil cl \"%%G\" >nul 2>&1)"
) else (
    echo [STARLIGHT] Disabling hibernation...
    powercfg /h off
    echo [STARLIGHT] Activating Ultimate Performance...
    powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    echo [STARLIGHT] Disabling IPv6...
    for /F "skip=3 tokens=1,*" %%A in ('netsh interface ipv6 show interfaces') do (
        netsh interface ipv6 set interface "%%B" admin=disabled >nul 2>&1
    )
    echo [STARLIGHT] Disabling Search indexing...
    sc config WSearch start= disabled >nul 2>&1
    net stop WSearch >nul 2>&1
    echo [STARLIGHT] Removing OneDrive...
    taskkill /f /im OneDrive.exe >nul 2>&1
    %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall >nul 2>&1
    echo [STARLIGHT] Disabling notifications...
    reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f >nul
    echo [STARLIGHT] Clearing temporary files...
    del /f /s /q "%temp%\*.*" >nul 2>&1
    del /f /s /q "%SystemRoot%\Temp\*.*" >nul 2>&1
    del /f /s /q "%SystemRoot%\Prefetch\*.*" >nul 2>&1
    echo [STARLIGHT] Clearing event logs...
    for /F "tokens=*" %%G in ('wevtutil el') do (wevtutil cl "%%G" >nul 2>&1)
)
echo [STARLIGHT] Power management optimizations completed.
pause
goto MainInterface

:SystemEnhancements
cls
echo ============================================================
echo      STARLIGHT - Additional System Enhancements
echo ============================================================
call :ExecutionMode
if "%BATCH_MODE%"=="0" (
    call :PromptAndExecute "Removing '3D Objects' from File Explorer" "reg delete \"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}\" /f >nul 2>nul"
    call :SecureRegistryUpdate "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\NonEnum" "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" REG_DWORD 1 "Hiding Network icon from sidebar"
    call :PromptAndExecute "Hiding OneDrive from File Explorer sidebar" "reg add \"HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder\" /v Attributes /t REG_DWORD /d 0x00000000 /f >nul && reg add \"HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder\" /v \"System.IsPinnedToNameSpaceTree\" /t REG_DWORD /d 0 /f >nul"
    call :SecureRegistryUpdate "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "Disabled" REG_DWORD 1 "Disabling Windows Error Reporting"
    call :SecureRegistryUpdate "HKCU\Control Panel\Sound" "Beep" REG_SZ no "Disabling system error beeps"
    call :SecureRegistryUpdate "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoDriveTypeAutoRun" REG_DWORD 255 "Disabling AutoPlay for all drive types"
    call :PromptAndExecute "Creating Starlight Control Panel shortcut" "if not exist \"%USERPROFILE%\Desktop\Starlight_Control.{ED7BA470-8E54-465E-825C-99712043E01C}\" md \"%USERPROFILE%\Desktop\Starlight_Control.{ED7BA470-8E54-465E-825C-99712043E01C}\""
    call :SecureRegistryUpdate "HKCU\Control Panel\Accessibility\StickyKeys" "Flags" REG_SZ 506 "Disabling accessibility key popup notifications"
    call :SecureRegistryUpdate "HKCU\Control Panel\Accessibility\Keyboard Response" "Flags" REG_SZ 122 "Disabling filter key notifications"
    call :SecureRegistryUpdate "HKCU\Control Panel\Accessibility\ToggleKeys" "Flags" REG_SZ 58 "Disabling toggle key notifications"
) else (
    echo [STARLIGHT] Removing '3D Objects' folder...
    reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f >nul 2>nul
    echo [STARLIGHT] Hiding Network from sidebar...
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\NonEnum" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 1 /f >nul
    echo [STARLIGHT] Hiding OneDrive from sidebar...
    reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder"