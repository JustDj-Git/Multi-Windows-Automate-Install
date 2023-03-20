Start-Transcript -Path "$Env:HOMEDRIVE\Install\_Logs\UpdateDrivers_Transcript.log"

##GetDate
function GetFormattedDate {
    $date = (Get-Date -Format "MM/dd/yyyy HH:mm:ss").ToString()
    return $date
}

Write-Host "$(GetFormattedDate) Script starting"

##Globals
Import-Module PSWindowsUpdate
Import-Module ImportWiFi
$logpath = "$Env:HOMEDRIVE\Install\_Logs\UpdateDrivers.log"

##Check inet
$timer = [Diagnostics.Stopwatch]::StartNew()

do {
    $inet = Test-Connection -ComputerName www.google.com -Quiet
    if ($inet -eq $false) {
		ImportWiFi
		if ($timer.elapsed.TotalMinutes -le 2) {
			$a = " No internet! Waiting for it 10 sec and recheck"
			Write-Host (GetFormattedDate) $a -ForegroundColor Red
			(GetFormattedDate) + $a >> $logpath
			Start-Sleep 10
		} else {
			$a = " 2 minutes are over. reboot"
			Write-Host (GetFormattedDate) $a
			(GetFormattedDate) + $a >> $logpath
			Restart-Computer
		}
    } else {
        $a = " Internet detected"
        Write-Host (GetFormattedDate) $a
        (GetFormattedDate) + $a >> $logpath
    }
} while ($inet -eq $false)

$timer.Stop()
$timer.Reset()

$a = " Waiting for InstallerStatus false or 2 minutes"
Write-Host (GetFormattedDate) $a
(GetFormattedDate) + $a >> $logpath


##Wait for InstallerStatus
$timer = [Diagnostics.Stopwatch]::StartNew()
do {
    $a = " InstallerStatus $((Get-WUInstallerStatus).IsBusy)"
    Write-Host (GetFormattedDate) $a
    (GetFormattedDate) + $a >> $logpath
    Start-Sleep -Seconds 10
} while (((Get-WUInstallerStatus).IsBusy -eq 'True') -or ($timer.elapsed.TotalMinutes -gt 2))

#Reboot and try one more time
if (((Get-WUInstallerStatus).IsBusy -eq 'True') -or ($timer.elapsed.TotalMinutes -gt 2)){
    Restart-Computer
}

$timer.Stop()
$timer.Reset()

Get-WindowsUpdate -Hide -Title "Intel - net - *" -Confirm:$false
Get-WindowsUpdate -Hide -Title "HP Inc. - Firmware*" -Confirm:$false

try {
	$status = Get-WindowsUpdate -UpdateType Driver -Install -AcceptAll -AutoReboot
} catch {
	if ($BootCount.BootId -gt '6'){
		Unregister-ScheduledTask -TaskName "Check Drivers" -Confirm:$false
		$a = " Task Removed bec a Get-WindowsUpdate error"
		Write-Host (GetFormattedDate) $a
		(GetFormattedDate) + $a >> $logpath
	} else {
		$a = " Something wrong with the module"
		Write-Host (GetFormattedDate) $a
		(GetFormattedDate) + $a >> $logpath
		Restart-Computer
	}
}

$status >> $logpath

if (!$status){
    $a = " No updates"
    Write-Host (GetFormattedDate) $a
    (GetFormattedDate) + $a >> $logpath
    $BootCount = Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters' 
    if ($BootCount.BootId -gt '3'){
        Unregister-ScheduledTask -TaskName "Check Drivers" -Confirm:$false
        $a = " Task Removed"
        Write-Host (GetFormattedDate) $a
        (GetFormattedDate) + $a >> $logpath
        Write-Host '==============================================' -ForegroundColor Green
        $b = "
  :::::::::   ::::::::  ::::    ::: :::::::::: 
  :+:    :+: :+:    :+: :+:+:   :+: :+:        
  +:+    +:+ +:+    +:+ :+:+:+  +:+ +:+        
  +#+    +:+ +#+    +:+ +#+ +:+ +#+ +#++:++#   
  +#+    +#+ +#+    +#+ +#+  +#+#+# +#+        
  #+#    #+# #+#    #+# #+#   #+#+# #+#        
  #########   ########  ###    #### ########## 
"
        Write-Host $b -ForegroundColor Green
        Write-Host '==============================================' -ForegroundColor Green
        Write-Host 'Window closes in 10 sec!' -ForegroundColor Green
		## Net tweaks
		#Get-NetConnectionProfile -Name 'Office-net' | Set-NetConnectionProfile -NetworkCategory Private
		netsh advfirewall firewall set rule group="network discovery" new enable=yes
		netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=yes
		##
		Remove-Item –path "$Env:HOMEDRIVE\BIT\files\*"
		##
        Start-Sleep 10
		Start-Process "devmgmt.msc"
		Start-Process -FilePath "$Env:HOMEDRIVE\BIT\bit.exe" -ArgumentList '-lv -m -r'
    } else {
        $a = " BootCount $($BootCount.BootId). Don't delete task. Need more reboots for sure"
        Write-Host $a
        (GetFormattedDate) + $a >> $logpath
		$b >> $logpath
        Restart-Computer
    }
} else {
	if ($BootCount.BootId -gt '6'){
		Unregister-ScheduledTask -TaskName "Check Drivers" -Confirm:$false
		$a = " Task Removed bec a reboot loop"
        Write-Host (GetFormattedDate) $a
        (GetFormattedDate) + $a >> $logpath
	} else {
		$a = " Restart PC after 2 min"
		Write-Host $a
		(GetFormattedDate) + $a >> $logpath
		Start-Sleep -Seconds 120
		(GetFormattedDate) + " Restarting PC" >> $logpath
		Restart-Computer
	}
}
Stop-Transcript