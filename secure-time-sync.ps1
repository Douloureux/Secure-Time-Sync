#   Secure Time Sync on Windows
#   Copyright (C) 2022 Douloureux 
#
#   Use of this source code is governed by the MIT license, which can be
#   found in the LICENSE file.

<#
.SYNOPSIS
    Synchronizes the system clock using HTTPS instead of NTP
#>

param(
    [Parameter()]
    [ValidateScript({$_ -like 'https://*'})]
    [string]$URL
)

# Self elevation
# Only works with Standard users.
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
     $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
     Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
     Exit
    }
   }

$ErrorActionPreference = 'Stop'

Function Find-Timezone {

    # Find user's current timezone 
    $tz = Get-TimeZone | Select-Object -Expand "Id"
    return $tz

}

Function Get-Time {
    
    # Choose random URL from the list
    $curl_url_db = @(
        "https://duckduckgo.com",
        "https://torproject.org",
        "https://www.whonix.org"
        )

    # Check if the -URL parameter was passed to the script and set the URL.
    if ($PSBoundParameters.ContainsKey('URL')) {
        $curl_url = $URL
    }

    else {
        $curl_url = Get-Random -InputObject $curl_url_db
    }

    # Pull in time from http headers and remove "Date: " from the output
    $raw_time = (curl -sI --tlsv1.3 $curl_url | Select-String "Date:" | Out-String).trim().replace("Date: ", "")

    # Convert time to PowerShell's time formatting, then convert to the user's timezone.
    return [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId((Get-Date "$raw_time"), (Find-Timezone))

}

# Set new time
Set-Date -Date (Get-Time)