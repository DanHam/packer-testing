# Output the current value of the ProgressPreference variable

$Logfile = 'C:\ElevProgPrefTest.log'

function LogWrite {
   param ([string]$Logstring)
   $Now = Get-Date -Format s
   Add-Content $Logfile -value "$Now $Logstring"
   Write-Host $Logstring
}

LogWrite "Elevated Powershell says: Initial value of ProgressPreference is $ProgressPreference"

If ((Test-Path variable:global:ProgressPreference) -and ($ProgressPreference -ne 'SilentlyContinue')) {
    $ProgressPreference = 'SilentlyContinue'
    LogWrite "Elevated Powershell says: This is output after the value of ProgressPreference was changed to 'SilentlyContinue'"
}

Write-Host "Hello World! I'm output from an elevated Powershell script"