pwsh.exe { #PowerShell Core v7

    # (OPTION) Clean window. For debug readability.
    # Clear-Host

    Function Start-ConsoleCommand
    {
        [CmdletBinding(SupportsShouldProcess)]

        [Alias('scc')]

        Param  
        ( 
            [string]$ConsoleCommand,
            [switch]$PoSHCore
        )

        If ($PoSHCore)
        {Start-Process pwsh -ArgumentList "-NoExit","-Command  &{ $ConsoleCommand }" -Wait}
        Else
        {Start-Process powershell -ArgumentList "-NoExit","-Command  &{ $ConsoleCommand }" -Wait}

    }

    # Get local IPv4 address (Ethernet or active interface)
    $localIP = (Get-NetIPAddress -AddressFamily IPv4 `
        | Where-Object { $_.IPAddress -notlike "169.*" -and $_.PrefixOrigin -ne "WellKnown" } `
        | Select-Object -First 1).IPAddress

    # Get default gateway
    $gateway = (Get-NetRoute -DestinationPrefix "0.0.0.0/0" `
        | Sort-Object RouteMetric `
        | Select-Object -First 1).NextHop

    Write-Host "Local IP: $localIP" -ForegroundColor Yellow
    Write-Host "Gateway : $gateway" -ForegroundColor DarkYellow

    # Extract subnet base (es: 192.168.1)
    $base = ($localIP -split '\.')[0..2] -join '.'

    # Generate IP range excluding local + gateway
    $IPs = 1..255 | ForEach-Object { "$base.$_" } | Where-Object {
        $_ -ne $localIP -and $_ -ne $gateway
    }

    Write-Host "Start scanning subnet from $base.1 to $base.255" -ForegroundColor Blue

    # ONLY FOR POWERSHELL 7
    # Parallel scan
    $results = $IPs | ForEach-Object -Parallel {
        $ip = $_
        if (Test-Connection $ip -Quiet -Count 1 -TimeoutSeconds 1) {
            [PSCustomObject]@{ IP = $ip; Status = "CONNECTED" }
        }    
        else {
            [PSCustomObject]@{ IP = $ip; Status = "NOT CONNECTED" }
        }
        
    } -ThrottleLimit 255

    <# 
    # FOR OLD POWERSHELL VERSIONS
    $jobs = foreach ($ip in $IPs) {
        Start-Job -ScriptBlock {
            param($ip)
            if (Test-Connection $ip -Quiet -Count 1 -ErrorAction SilentlyContinue) {
                [PSCustomObject]@{ IP = $ip; Status = "CONNECTED" }
            }
        } -ArgumentList $ip
    }
    $results = $jobs | Wait-Job | Receive-Job
    #>

    # Output only connected devices
    foreach ($r in $results) {
        if ($r.Status -eq "CONNECTED") {
            Write-Host "$($r.IP) - CONNECTED" -ForegroundColor Green
        }
        <# #Output also unconnected devices
        else {
            Write-Host "$($r.IP) - NOT CONNECTED" -ForegroundColor Red
        }
        #>
    }

    Write-Host "Done."

    # (OPTION) After 60 seconds, close the window.
    Start-Sleep -s 60

    # (OPTION) Waiting for user input to close the window.
    # Read-Host -Prompt "Press Enter to exit "

}