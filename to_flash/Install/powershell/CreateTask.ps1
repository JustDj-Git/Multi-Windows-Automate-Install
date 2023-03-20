$taskAction = New-ScheduledTaskAction `
    -Execute 'powershell.exe' `
    -Argument "-File $Env:HOMEDRIVE\Install\powershell\UpdateDrivers.ps1"

$taskTrigger = New-ScheduledTaskTrigger -AtLogOn
$taskName = "Check Drivers"
$description = "Check Drivers on logon untill updates exists"

$task = Register-ScheduledTask `
    -TaskName $taskName `
    -Action $taskAction `
    -Trigger $taskTrigger `
    -Description $description `
    -RunLevel Highest `
    -Force

Start-ScheduledTask -TaskName "Check Drivers"