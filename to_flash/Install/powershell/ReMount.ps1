Start-Transcript -Path "$Env:HOMEDRIVE\Install\_Logs\CopyFiles_Transcript.log"
$source = Get-PSDrive -PSProvider 'FileSystem'
foreach ($i in $source){
	$test_path = $(Join-Path $($i.Root) -ChildPath '_Copy_')
    if (Test-Path -Path "$test_path"){
        $drive = $i
    }
}

Set-Partition -DriveLetter $drive.Name -NewDriveLetter T
Start-Sleep 10
Stop-Transcript