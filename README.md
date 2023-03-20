# Multi-Windows Automate Install
## _by JustDj_

## FileTree (not all but needed for you)

```bash
├── CreateFlashUSB
	├── HowtoPrepareFlash.png (Showing how to create flash USB)
	├── Ventoy2Disk.exe (Needed program for creating flash USB)
	
	
├── to_flash_drive
    ├── _Copy_
        ├── to_C
		    ├── place files here to copy to C
        ├── to_Desktop
			├── place files to copy to Desktop
		├── to_Documents
			├── place files to copy to Documents

    ├── Install
        ├── apps
            ├──  EXE files to install
        ├── bats
			├── bats_HERE
				├──  place .bats files here
        ├── Wifi_Profile
                   ├──  Wi-fi profile

	├── OS
		├── Windows_10
			├── Put here windows 10 iso named 'windows10.iso'
		├── Windows_11	
			├── Put here windows 11 iso named 'windows11.iso'

	├── unattend
		├── autounattend_win10.xml (auto-answer Microsoft file for windows 10 installation)
		├── autounattend_win11.xml (auto-answer Microsoft file for windows 10 installation)


├── README.md
└── .gitignore
```

## Instruction

### Copy programs to dir

If you want to copy your files to System Drive (```C:\````) put the needed files to

```ssh 
to_flash_drive\_Copy_\to_C
```
If you want to copy your files to Desktop (```C:\Users\cic\Desktop```) put the needed files to

```ssh 
to_flash_drive\_Copy_\to_Desktop
```

If you want to copy your files to Documents (```C:\Users\cic\Documents```) put the needed files to

```ssh 
to_flash_drive\_Copy_\to_Documents
```

### Install programs (BEFORE you will see the desktop)

1) Add installers to ```to_flash\Install\apps```

2) Open ```_InstallApps.ps1``` file in ```to_flash\Install\apps``` folder

3) Edit file

|Description                |                         |Sample                         |
|----------------|-----------------------------|-----------------------------|
|Installer name with .exe/.msi on ending|$_installer_name = "_EXE_NAME_"|$_installer_name = "vc_redist.x64.exe"|
|Installer arguments |$_installer_arguments =  "_arguments_"|$_installer_arguments =  "/install /quiet /norestart"|
|Start function|InstallApp -installer_name "$_installer_name" -installer_arguments "$_installer_arguments"||


### Do anything else after showing desktop

Open 
```ssh 
to_flash_drive\unattend\autounattend_win10.xml
```


Find block ```FirstLogonCommands```
```ssh 
                <SynchronousCommand wcm:action="add">
                    <Order>[NUMBER]</Order>
                    <RequiresUserInput>[TRUE_OR_FALSE]</RequiresUserInput>
                    <CommandLine>[DO_SOMETHING]</CommandLine>
                    <Description>[TEXT]</Description>
                </SynchronousCommand>
```



|                |Sample                         |Description                         |
|----------------|-----------------------------|-----------------------------|
|Block starts|`<SynchronousCommand wcm:action="add">`||
|Order|`<Order>500/Order>`|The number must not repeat and bigger than 500|
|RequiresUserInput          |`<RequiresUserInput>true</RequiresUserInput>`| Boolean. `True` - the "Preparing Your Desktop" screen is removed, allowing users to reach the desktop more quickly and provide input. `False` - the desktop does not appear until first logon command is complete, or until two minutes pass
|Command|`<CommandLine>cmd /C powershell.exe -File &quot;%SystemDrive%\Install\powershell\UpdateDrivers.ps1&quot; -noninteractive -windowstyle hidden</CommandLine>` | Put here needed command. `"` must be replaced by `&quot;`
|Description|`<Description>Update Drivers</Description>`| Just text |
|Block end|`</SynchronousCommand>`
