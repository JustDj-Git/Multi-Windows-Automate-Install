New-Item -Path "$Env:HOMEDRIVE\Install\" -Name "_Logs" -ItemType Directory
Start-Transcript -Path "$Env:HOMEDRIVE\Install\_Logs\CopyFiles_Transcript.log"
$logpath = "$Env:HOMEDRIVE\Install\_Logs\InstallModules.log"

##GetDate
function GetFormattedDate {
    $date = (Get-Date -Format "MM/dd/yyyy HH:mm:ss").ToString()
    return $date
}
"$(GetFormattedDate) Copy Files and PS modules" >> $logpath
#

robocopy "T:\Install\powershell" "$Env:HOMEDRIVE\Install\powershell" "UpdateDrivers.ps1" /XF ".gitkeep" >> $Env:HOMEDRIVE\Install\_Logs\robocopy.log
robocopy "T:\_Copy_\to_C" "$Env:HOMEDRIVE\" /E /XF ".gitkeep" >> $Env:HOMEDRIVE\Install\_Logs\robocopy.log
robocopy "T:\_Copy_\to_Desktop" "$Env:HOMEPATH\Desktop" /E /XF ".gitkeep" >> $Env:HOMEDRIVE\Install\_Logs\robocopy.log
robocopy "T:\_Copy_\to_Documents" "$Env:HOMEPATH\Documents" /E /XF ".gitkeep" >> $Env:HOMEDRIVE\Install\_Logs\robocopy.log
robocopy "T:\Install\powershell\Modules\" "$Env:ProgramFiles\WindowsPowerShell\Modules" /E >> $Env:HOMEDRIVE\Install\_Logs\robocopy.log
robocopy "T:\Install" "$Env:HOMEDRIVE\Install" "CopyTestLog.bat" /XF ".gitkeep" >> $Env:HOMEDRIVE\Install\_Logs\robocopy.log
"$(GetFormattedDate) Files copied" >> $logpath

Stop-Transcript