$taskAction = New-ScheduledTaskAction `
    -Execute 'powershell.exe' `
    -Argument "-File T:\Install\powershell\DelAll\DeletePartition.ps1"

$taskName = "DelAll"
$description = "DelAll"

$task = Register-ScheduledTask `
    -TaskName $taskName `
    -Action $taskAction `
    -Description $description `
    -RunLevel Highest `
    -Force