# List of processes you want to modify
$uselessProcessNames = @(
'ACCIMonitor', 'amdfendrsr', 'AMDRSServ', 'AMDRSSrcExt', 'ArmouryCrate', 'ArmouryCrate.Service',
'ArmouryCrate.UserSessionHelper', 'ArmouryCrateControlInterface', 'ArmourySocketServer', 'ArmourySwAgent', 
'AsHotplugCtrl', 'AsMonitorControl', 'AsusAgni', 'AsusAppService', 'AsusDialAgent', 'AsusDialService',
'AsusFeatureService', 'AsusInitialService', 'AsusLinkToScreenXpert', 'AsusMultiAntennaSvc', 'AsusOptimization',
'AsusOptimizationStartupTask', 'AsusOSD', 'AsusScreenXpertCheckUpdate', 'ASUSSmartDisplayControl', 'AsusSoftwareManager',
'AsusSoftwareManagerAgent', 'AsusSwitch', 'AsusSystemAnalysis', 'AsusSystemDiagnosis', 'asus_framework',
'Aura Wallpaper Service', 'RadeonSoftware', 'LightingService'
)

$midProcessNames =  @(
'Taskmgr', 'NLClientApp', 'perfmon'
)

$lagProcessNames = @(
'AsusAgniService', 'dwm', 'NLSvc'
)

# Loop through each process name in the list
ForEach ($processName in $uselessProcessNames) {
    # Get the process(es) by name
    $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
    
    # If the process is found, apply the changes
    ForEach ($PROCESS in $processes) {
        # Set processor affinity to 1 (use only the first core)
        $PROCESS.ProcessorAffinity = 1
        # Set the process priority to Idle (Low priority)
        $PROCESS.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::Idle
        Write-Host "Updated process: $($PROCESS.Name) (PID: $($PROCESS.Id))"
    }
}


ForEach ($processName in $midProcessNames) {
    # Get the process(es) by name
    $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
    
    # If the process is found, apply the changes
    ForEach ($PROCESS in $processes) {
        # Set processor affinity to 3 (use only the first 2 cores)
        $PROCESS.ProcessorAffinity = 3
        # Set the process priority to Above Normal (Slightly higher priority)
        $PROCESS.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::AboveNormal
        Write-Host "Updated process: $($PROCESS.Name) (PID: $($PROCESS.Id))"
    }
}


ForEach ($processName in $lagProcessNames) {
    # Get the process(es) by name
    $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
    
    # If the process is found, apply the changes
    ForEach ($PROCESS in $processes) {
        # Set processor affinity to 3 (use only the first 2 cores)
        $PROCESS.ProcessorAffinity = 3
        # Set the process priority to Max (RealTime priority)
        $PROCESS.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::RealTime
        Write-Host "Updated process: $($PROCESS.Name) (PID: $($PROCESS.Id))"
    }
}
