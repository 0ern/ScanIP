#E

# Clean window. For debug.
# Clear-Host

Write-Host "IP of your Ethernet port" -Separator "  ->  " -ForegroundColor Yellow (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Ethernet).IPAddress
"`n" # New line

Write-Host "Start scanning IP addresses in your local network ..." -ForegroundColor White
"`n" # New line

$InputFile = '.\List_config.txt' # Associated file to a variable
$String = Get-content $InputFile # Read file as a string
# $count = 0
# $totIP = (Get-Content $InputFile).Length # Total number of IP listed in file


foreach ($IPn in $String) # For each IP listed in file
{
    # Percentage = (counter/total)*100 with truncation
    # $Percent = [math]::floor(($count/$totIP) * 100)
    # Display progress
    # Write-Progress -Activity "Search in Progress" -Status "$Percent% complete" #-PercentComplete $Percent
    # $count = $count+1

    if ($IPn.contains(“#”)) # skip if IP is commented with # character at the beginning
    {

    }
    else{
        if (Test-Connection $IPn -Quiet -Count 1 -ErrorAction SilentlyContinue) # Check if IP is reachable
        {
            Write-Host ("$IPn","CONNECTED") -Separator "  -  " -ForegroundColor Green
        }
        else # IP is not reachable
        {
            Write-Host ("$IPn","NOT CONNECTED") -Separator "  -  " -ForegroundColor Red
        }
    }
}

"`n" # New line
Write-Host "Done." -ForegroundColor White 
Write-Host "To edit IP addresses list, open file List_config.txt." -ForegroundColor White

# After 60 seconds, close the window.
Start-Sleep -s 60

# Waiting for user input to close the window.
# Read-Host -Prompt "Press Enter to exit "