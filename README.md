# My-Windows-Laptop-Setup-Guide
My guide to setup windows in a way that is private, fast and updateless.

# What windows update can screw up
## 1. Second screen on asus duo may be disabled
## 2. Nvidia driver can stop working
## 3. Main screen can start flickering
## 4. Windows recovery can become broken from expired components
To fix this, we need to set the date to 2015 to re-enable windows recovery.

# Basic setup
Just the basic configuration

## Step 0 Backup 

### Backup the entire drive as an image (probably to a 64 gb usb stick)
Requirements - 2 x 64gb pendrives
Use medicatusb in one usb [https://medicatusb.com/](https://medicatusb.com/)
Store the full disk image backup in another usb

### Backup all the drivers
`Export-WindowsDriver -Online -Destination C:/somepath/drivers/backup` in powershell should do it. I have confirmed this works on windows 10 ame 21H1 as well

### Backup registry
Don't think it's needed but why not, just export the whole thing as a .reg file, and have a restore point.


## Step 1 Windows AME [https://ameliorated.io/](https://ameliorated.io/)
This will strip the useless bloat that comes with windows. I will personally be using the windows 10 ame 21H1 iso install.

## Step 2 Netlimiter [https://www.netlimiter.com/](https://www.netlimiter.com/)
This will give us finer control over the internet. Set the behaviour of this to block network connections by default

## Step 3 WindowsSpyBlocker [https://github.com/crazy-max/WindowsSpyBlocker](https://github.com/crazy-max/WindowsSpyBlocker)
Set the NCSI to be the Debian one, Firewall rules not required.

## Step 4 Disable Connected Standby 
We want the laptop to  not have some sort of weird semi-sleep.

use ` powercfg /a` to check

### Create registry keys in folder `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power` 

Dword Key `CsEnabled` value 0 [link](https://answers.microsoft.com/en-us/windows/forum/all/how-to-disable-modern-standby-in-windows-10-may/db950560-33da-4a90-8340-b1f181f5efe6) \
Dword key `PlatformAoAcOverride` value 0 [link](https://windowsloop.com/disable-connected-standby/) \
Dword key `EnforceDisconnectedStandby` value 1 [link](https://www.elevenforum.com/t/enable-or-disable-modern-standby-network-connectivity-in-windows-11.3286/page-2)

### Set up the powerconfig to not use connected standby

[https://winaero.com/enable-or-disable-network-connectivity-in-standby-in-windows-10/](https://winaero.com/enable-or-disable-network-connectivity-in-standby-in-windows-10/)

[https://www.tenforums.com/tutorials/146593-enable-disable-network-connectivity-modern-standby-windows-10-a-2.html](https://www.tenforums.com/tutorials/146593-enable-disable-network-connectivity-modern-standby-windows-10-a-2.html)

`PowerCfg /SetDCValueIndex <YOUR CONFIG ID> SUB_NONE CONNECTIVITYINSTANDBY 0` \
`PowerCfg /SetACValueIndex <YOUR CONFIG ID> SUB_NONE CONNECTIVITYINSTANDBY 0`

where `<YOUR CONFIG ID>` is the power config you use - something like `fdv8v0nu8-freu8fy-fre834f8h-e32y783` that you see with `powercfg /a`

### Enable hibernate

`powercfg /hibernate on` \
`powercfg /h /size 100%`

### This might be needed
[https://github.com/ElectronicElephant/Modern-Standby-Byby](https://github.com/ElectronicElephant/Modern-Standby-Byby)

## Step 5 Get the drivers
Use the previous backup, device manager and google-fu to do this.

## Step 6 disable windows defender
Use [https://www.sordum.org/9480/defender-control-v2-1/](https://www.sordum.org/9480/defender-control-v2-1/)

## Step 7 Pause updates for 20 years
[https://www.elevenforum.com/t/disable-automatic-windows-updates-in-windows-11.22669/](https://www.elevenforum.com/t/disable-automatic-windows-updates-in-windows-11.22669/)

Increase time to 20 years with registry key
Folder - HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings
Key - FlightSettingsMaxPauseDays
Value - dword:00001c84

## Step 7 Use this tool to stop telemetry and updates
https://github.com/ChrisTitusTech/winutil/releases/tag/24.10.07

## Step 8 Become owner (make the owner .../Administrators) and remove all permissions 
### For these files, make it so no user can execute them.
```
C:\Windows\System32\CompatTelRunner.exe
C:\Windows\System32\DeviceCensus.exe
C:\windows\system32\sihclient.exe
C:\windows\system32\usoclient.exe
C:\windows\system32\waasmedicagent.exe
C:\windows\system32\wsqmcons.exe
C:\Windows\UUS\amd64\mousocoreworker.exe
C:\Windows\UUS\amd64\UusBrain.dll
C:\Windows\UUS\amd64\UusFailover.dll
C:\Windows\System32\Speech_OneCore\common\SpeechModelDownload.exe
C:\Windows\System32\DiagSvcs\DiagnosticsHub.StandardCollector.Service.exe
C:\Windows\System32\backgroundTaskHost.exe
C:\Windows\System32\BackgroundTransferHost.exe
C:\Windows\System32\wermgr.exe
```
### For these folders, delete contents and, make it so no user can write or read them
```
C:\Windows\SoftwareDistribution\Download
```

## Step 9 Erase
