Start-Transcript -Path "$Env:HOMEDRIVE\Install\_Logs\InstallApps.log"
##GetDate
function GetFormattedDate {
    $date = (Get-Date -Format "MM/dd/yyyy HH:mm:ss").ToString()
    return $date
}

function InstallApp {
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$installer_name,
		[Parameter(Mandatory = $false)]
		[string]$installer_arguments = ""
	)
	
	write-host "$(GetFormattedDate) Install $installer_name"
    if ($installer_arguments){
        Start-Process "T:\Install\apps\$installer_name" -argumentlist "$installer_arguments" -Wait
    } else {
        Start-Process "T:\Install\apps\$installer_name" -Wait
    }
	write-host "$(GetFormattedDate) Ready $installer_name"
}

$_installer_name = "vc_redist.x64.exe"
$_installer_arguments =  "/install /quiet /norestart"
InstallApp -installer_name "$_installer_name" -installer_arguments "$_installer_arguments"


<### Add here lines like
$_installer_name = "_EXE_NAME_"
$_installer_arguments =  "_arguments_"
InstallApp -installer_name "$_installer_name" -installer_arguments "$_installer_arguments"
#>


Stop-Transcript