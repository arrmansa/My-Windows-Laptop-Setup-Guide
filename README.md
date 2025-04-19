# My-Windows-Laptop-Setup-Guide
My guide to setup windows in a way that is private, fast and updateless.

# What windows update can screw up
## 1. Second screen on asus duo may be disabled
The very latest windows just won't allow me to use my second screen, All the other updates etc. did not work. Just won't even show up in device manager.
## 2. Nvidia driver can stop working
Idk why an update nuked my driver, but atleast I can reinstall this.
## 3. Main screen can start flickering
The main screen can start filckering if armoury crate is not open while the battery is connected.
## 4. Windows recovery can become broken from expired components
To fix this, we need to set the date to 2015 to re-enable windows recovery.
## 5. Wifi is unreliable
Wifi is unreliable if wlan auto config is allowed, or save power is allowed.
WLAN AutoConfig detected limited connectivity, attempting automatic recovery.

Recovery Type: 4
Error Code: 0x0
Trigger Reason: 5
IP Family: 0 
## 6. Touchpad slows down randomly
Touchpad slows down if asus stuff is enabled - actually was "C:\Windows\System32\ctfmon.exe" found using Procmon.exe, was showing a ton of reg events and my touchpad lagged like crazy
Stopping this fixes touchpad, but blocks search and explorer input https://answers.microsoft.com/en-us/windows/forum/all/is-there-a-way-to-control-ctfmon-from-running-in/b7030532-ab97-4897-9786-26d865571a60
<br>
ctfmon queries C:\Windows\Globalization\ELS\SpellDictionaries\MsSp7en-US.lex
C:\Windows\Globalization\ELS\SpellDictionaries\Fluency\en-US\.config
we will block these
Still persists gonna try to remove textinputhost
C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\TextInputHost.exe

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
This will give us finer control over the internet. Set the behaviour of this to block network connections by default.
Remove the existing rules for `svchost.exe`

Add 2 filters - Allow in and out with weight 100

### DHCP ALLOW

```
Application is
C:\windows\system32\svchost.exe
C:\windows\system32\svchost.exe@Dnscache

Remote port in range
67

Transport protocol is
UDP(17)

Local port in range
68
```

### Dnscache Allowed

```
Application is
C:\windows\system32\svchost.exe@Dnscache

Remote port in range
53
5353
5355

Transport protocol is
UDP(17)
TCP(6)
```

## Step 3 WindowsSpyBlocker [https://github.com/crazy-max/WindowsSpyBlocker](https://github.com/crazy-max/WindowsSpyBlocker)
Set the NCSI to be the Firefox one, Firewall rules not required.
Disable internet checking using registry key
Folder `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\NlaSvc\Parameters\Internet`
Dword Key `EnableActiveProbing`
Original Value `1`
New Value `0`

## Step 4 Disable Connected Standby 
We want the laptop to  not have some sort of weird semi-sleep.

use ` powercfg /a` to check your standby states

### Ouptut 

```
The following sleep states are available on this system:
    Standby (S0 Low Power Idle) Network Disconnected
    Hibernate
    Fast Startup
```

### Create registry keys in folder `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power` 

Dword Key `CsEnabled` value 0 [link](https://answers.microsoft.com/en-us/windows/forum/all/how-to-disable-modern-standby-in-windows-10-may/db950560-33da-4a90-8340-b1f181f5efe6) \
Dword key `PlatformAoAcOverride` value 0 [link](https://windowsloop.com/disable-connected-standby/) \
Dword key `EnforceDisconnectedStandby` value 1 [link](https://www.elevenforum.com/t/enable-or-disable-modern-standby-network-connectivity-in-windows-11.3286/page-2)

### Set up the powerconfig to not use connected standby

[https://winaero.com/enable-or-disable-network-connectivity-in-standby-in-windows-10/](https://winaero.com/enable-or-disable-network-connectivity-in-standby-in-windows-10/)

[https://www.tenforums.com/tutorials/146593-enable-disable-network-connectivity-modern-standby-windows-10-a-2.html](https://www.tenforums.com/tutorials/146593-enable-disable-network-connectivity-modern-standby-windows-10-a-2.html)

Now we need to run the commands - 

(1 is enabled, 2 is managed by windows and 0 is disabled) [https://www.tenforums.com/tutorials/146593-enable-disable-network-connectivity-modern-standby-windows-10-a.html](https://www.tenforums.com/tutorials/146593-enable-disable-network-connectivity-modern-standby-windows-10-a.html)




where `<YOUR CONFIG ID>` is the power config you use - something like `fdv8v0nu8-freu8fy-fre834f8h-e32y783` that you can see with `powercfg /L`

You can get the current value using `powercfg /QUERY <YOUR CONFIG ID> sub_NONE`

And you should set it to 0 with this for all config id's (Yeah it is a pain to run 8 commands)

`PowerCfg /SetDCValueIndex <YOUR CONFIG ID> SUB_NONE CONNECTIVITYINSTANDBY 0` \
`PowerCfg /SetACValueIndex <YOUR CONFIG ID> SUB_NONE CONNECTIVITYINSTANDBY 0`


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

Increase time to 20 years with registry key (You need to make a new key)
Folder - HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings
Key - FlightSettingsMaxPauseDays
Value - dword:00001c84

## Step 7 Use this tool to stop telemetry and updates
https://github.com/ChrisTitusTech/winutil/releases/tag/24.10.07

## Step 8 Become owner (make the owner .../Administrators) and remove all permissions 
Similar to [https://superuser.com/questions/1058487/permanantly-delete-bits-annd-windows-update-services-in-windows-10](https://superuser.com/questions/1058487/permanantly-delete-bits-annd-windows-update-services-in-windows-10) But better I think, because we just get executables that are effectively dead and just stuck in place that cannot be run.
### For these files, make it so no user can execute them.
```
C:\Windows\System32\backgroundTaskHost.exe
C:\Windows\System32\BackgroundTransferHost.exe
C:\Windows\System32\CompatTelRunner.exe
C:\Windows\System32\DeviceCensus.exe
C:\Windows\System32\dosvc.dll
C:\windows\system32\sihclient.exe
C:\windows\system32\usoclient.exe
C:\windows\system32\waasmedicagent.exe
C:\Windows\System32\wermgr.exe
C:\windows\system32\wsqmcons.exe
C:\Windows\UUS\amd64\mousocoreworker.exe
C:\Windows\UUS\amd64\UusBrain.dll
C:\Windows\UUS\amd64\UusFailover.dll
C:\Windows\System32\Speech_OneCore\common\SpeechModelDownload.exe
C:\Windows\System32\DiagSvcs\DiagnosticsHub.StandardCollector.Service.exe
C:\Windows\System32\ctfmon.exe
C:\Program Files (x86)\ASUS\Update\AsusUpdate.exe
```
### For these folders, delete contents and, make it so no user can write or read them
```
C:\Windows\SoftwareDistribution\Download
```
## Step 9 Delete task scheduler entriee for windows update, update medic, update orchestrator, and telemetry
```cmd
psexec.exe -i -s %windir%\system32\mmc.exe /s taskschd.msc
```
# Step 10 Stop and disable services
```
BITS - Background Intelligent Transfer Service - C:\Windows\System32\svchost.exe -k netsvcs -p
```
## Use registry to disable Delivery optimization
Folder - `Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DoSvc`
Key - `Start`
Value - `4`
Previous Value - `3`

## Disable exe's using debugger
[https://learn.microsoft.com/en-us/previous-versions/windows/desktop/xperf/image-file-execution-options](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/xperf/image-file-execution-options)
[https://www.reddit.com/r/Windows10/comments/y2zteh/comment/is7dqtv/](https://www.reddit.com/r/Windows10/comments/y2zteh/comment/is7dqtv/)
[https://securityblueteam.medium.com/utilizing-image-file-execution-options-ifeo-for-stealthy-persistence-331bc972554e](https://securityblueteam.medium.com/utilizing-image-file-execution-options-ifeo-for-stealthy-persistence-331bc972554e)
In the registry, we use debugger options to disable exes (that we already disabled)

```
C:\Windows\System32\backgroundTaskHost.exe
C:\Windows\System32\BackgroundTransferHost.exe
C:\Windows\System32\CompatTelRunner.exe
C:\Windows\System32\DeviceCensus.exe
C:\Windows\System32\dosvc.dll
C:\windows\system32\sihclient.exe
C:\windows\system32\usoclient.exe
C:\windows\system32\waasmedicagent.exe
C:\Windows\System32\wermgr.exe
C:\windows\system32\wsqmcons.exe
C:\Windows\UUS\amd64\mousocoreworker.exe
C:\Windows\System32\Speech_OneCore\common\SpeechModelDownload.exe
C:\Windows\System32\DiagSvcs\DiagnosticsHub.StandardCollector.Service.exe
```

## Fix context menu - Use the old contex menu, not the `show ore options` crap
run the command in admin command prompt
```
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
```

## Disable memory compression
https://silicophilic.com/windows-memory-compression/
Run in admin powershell 
```
Disable-MMAgent –mc
```
Can be enabled (bad setting)
```
Enable-MMAgent –mc
```

## Adjust appearance and performance
Disable 
```
Animate controls and elements inside windows
Animate windows when minimizing and maximizing
Animations in the taskbar
Fade or slide menus into view
Fade or slide ToolTips into view
Fade out menu items after clicking
Save taskbar thumbnail previews
Slide open combo boxes
```
Enable
```
Enable Peek
Show shadows under mouse pointer
Show shadows under windows
Show thumbnails instead of icons
Show translucent selection rectangle
Show window contents while dragging
Smooth edges of screen fonts
Smooth-scroll list boxes
Use drop shadows for icon labels on the desktop
```


### Fix touchpad edgemotion zones
Can be changed using this
https://community.frame.work/t/disable-edge-drag-for-windows-precision-touchpad/47892
https://github.com/imbushuo/mac-precision-touchpad/issues/262
https://superuser.com/questions/1721893/disable-part-of-touchpad-on-win-10
https://learn.microsoft.com/en-us/windows-hardware/design/component-guidelines/touchpad-tuning-guidelines

https://learn.microsoft.com/en-us/windows-hardware/design/component-guidelines/touchpad-tuning-guidelines#suppressing-accidental-activation-protection

AAPThreshold - 0
AAPDisabled - 1

For changing edge tap drag to minimum - 

SuperCurtainBottom - 1
SuperCurtainLeft - 1
SuperCurtainRight - 1
SuperCurtainTop - 1 



## Network

Device manager > adapter 

In power, uncheck turn off this device to save power
Disable roaming, wake on magic packet etc., change power to max

registry key 
https://officialaptivi.wordpress.com/2024/01/16/netlimdisable-fixes-random-disconnections/
https://learn.microsoft.com/en-us/answers/questions/1359044/weve-experiencing-from-may-of-2023-wireless-discon
https://community.cisco.com/t5/network-access-control/cisco-anyconnect-nam-stuck-in-associating-with-wifi/td-p/4774420
https://github.com/wazuh/wazuh-qa/issues/3021

Set registry key 
HKLM\SOFTWARE\Microsoft\WcmSvc\EnableBadStateTracking - dword 0

Set WlanAutoConfigService to delayed start using registry - 


https://smallvoid.com/article/winnt-services-regedit.html

```
0 = Boot
1 = System
2 = Automatic
3 = Manual
4 = Disabled
```

Folder - `Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WlanSvc`
Key - `DelayedAutoStart`
Value - `1`

Then run this in admin command window
```
netsh wlan show settings
```
to get
```
Wireless LAN settings
---------------------
    Show blocked networks in visible network list: No

    Only use GP profiles on GP-configured networks: No

    Hosted network mode allowed in WLAN service: Yes

    Allow shared user credentials for network authentication: Yes

    Block period: Not Configured.

    Auto configuration logic is enabled on interface "Wi-Fi"
    MAC randomization enabled on interface Wi-Fi
```

then you can do  `netsh wlan set autoconfig enabled=no interface="name of your wireless network here"`
which in my case is 
```
netsh wlan set autoconfig enabled=no interface="Wi-Fi"
```

and then use the show command to confirm 



```
C:\Windows\system32>netsh wlan show settings

Wireless LAN settings
---------------------
    Show blocked networks in visible network list: No

    Only use GP profiles on GP-configured networks: No

    Hosted network mode allowed in WLAN service: Yes

    Allow shared user credentials for network authentication: Yes

    Block period: Not Configured.

    Auto configuration logic is disabled on interface "Wi-Fi"
    MAC randomization enabled on interface Wi-Fi
```

## Use powershell script to assign cores to processes more optimally 

`stop_lag.ps1` 

when firefox goes high cpu and causes fans to spin, use this

```powershell
ForEach($PROCESS in GET-PROCESS firefox) {
    $PROCESS.ProcessorAffinity=1
    $PROCESS.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::BelowNormal
    Write-Host "Updated process: $($PROCESS.Name) (PID: $($PROCESS.Id))"
}
```
## Disable asus system analysis in task scheduler and services to prevent rouchpad lag

tried disabling asus agni service, did not work
happens every 10 min

