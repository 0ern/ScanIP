# ScanIP

A simple and basic script to show the connection status of multiple devices in the local network by listing IPv4 addresses in a text file instead of launching `cmd ping` command several times.





## Instructions

1. Download the [`ScanIP.exe`](https://github.com/0ern/ScanIP/releases/) latest release and the [`List_config.txt`](https://github.com/0ern/ScanIP/blob/main/List_config.txt) IP list file.
2. Put them in a folder.
3. Run the `ScanIP.exe`

To change the IP addresses to be scanned, open the file `List_config.txt` and write an IP address on a single line. Then save it and run again the `ScanIP.exe`.






## Future features

Any help or advice on developing this script and implementing new features is welcome. Please open a new Issue.

1. **Increase the scanning speed**: currently with few IP addresses in the list it is fast. When there are many IP addresses it takes a long time to scan them all.

2. **Percentage of project**: was tried to implement the display of a percentage of scan progress on the total number of addresses written to the list. the PowerShell Write-Progress command was used but in PowerShell it is displayed but in the executable it is not.
The code parts were commented out in the script.

3. **GUI**: thanks to PS2EXE it is possible to generate the executable not in console but in window. It is currently ugly. I preferred to leave it on console with colored text. In the future it would be nice to have the executable in window but with the console style.

4. **Automatic detection**: automatic detection of all subnet addresses without having to manually write them to the list file.






## Generation of the executable

Run `PowerShell.exe` as Administrator.

- Install the PS2EXE tool
```powershell
Install-Module ps2exe
```

- Import the module
```powershell
Import-Module ps2exe
```

- Run PS2EXE as GUI
```powershell
Win-PS2EXE
```






#### PowerShell Execution Policies

In case of problems with PowerShell Execution Policies, please read Microsoft's documentation [about_Execution_Policies](https://learn.microsoft.com/en-gb/powershell/module/microsoft.powershell.core/about/about_execution_policies).

Example to enable only the current user:

- View the current status of policies
```powershell
Get-ExecutionPolicy -List
```
- Change the execution policy
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

- After, for remove the execution policy:
```powershell
Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser
```






## References

This script was written in PowerShell on Windows. For more details on PowerShell commands, refer to the [Microsoft documentation](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility). 

The executable .exe file was generated thanks to the [PS2EXE](https://github.com/MScholtes/PS2EXE) tool.
