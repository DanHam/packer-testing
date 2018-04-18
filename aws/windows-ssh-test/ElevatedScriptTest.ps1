# Test the elevated powershell provisioner

$Logfile = 'C:\ElevatedOutput.log'

function LogWrite {
   param ([string]$Logstring)
   $Now = Get-Date -Format s
   Add-Content $Logfile -value "$Now $Logstring"
   Write-Host $Logstring
}

# Env vars must be INSIDE THE QUOTES for LogWrite!
LogWrite "Hello from the Elevated Powershell provisioner"
LogWrite "LogWrite says Env var MOO has value: $Env:MOO"
