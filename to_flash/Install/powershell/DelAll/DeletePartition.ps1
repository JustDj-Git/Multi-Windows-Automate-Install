FindAndReplace -Path "T:\ventoy\ventoy.json" -Pattern '"VTOY_DEFAULT_IMAGE": "/OS/Windows_10/windows10.iso"' '"VTOY_DEFAULT_IMAGE": "/OS/Windows_11/windows11.iso"' -Overwrite
#
& diskpart /S 'T:\Install\powershell\DelAll\diskpart.txt'
#
Set-Partition -DiskNumber 0 -PartitionNumber 2 -NewDriveLetter Y
cd Y:\
& cmd.exe /C rmdir EFI /s /q
#
Restart-Computer