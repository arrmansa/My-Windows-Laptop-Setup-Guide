# My-Windows-Laptop-Setup-Guide
My guide to setup windows in a way that is private, fast and updateless.

# Basic setup
Just the basic configuration

## Step 0 Backup the entire drive
For obvious reasons - tentative tool [https://medicatusb.com/](https://medicatusb.com/)

## Step 1 Windows AME [https://ameliorated.io/](https://ameliorated.io/)
This will strip the useless bloat that comes with windows

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
Use device manager and google-fu to do this
