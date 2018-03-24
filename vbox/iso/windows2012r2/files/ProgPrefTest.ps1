# Output the current value of the ProgressPreference variable


Write-Host "Initial value of ProgressPreference is" $ProgressPreference

If ((Test-Path variable:global:ProgressPreference) -and ($ProgressPreference -ne 'SilentlyContinue')) {
    $ProgressPreference = 'SilentlyContinue'
    Write-Host "This is output after the value of ProgressPreference was changed to 'SilentlyContinue'"
}

# Write-Output "Output to stdout stream"
# Write-Error "Output to stderr stream"
# Write-Verbose "Output to Verbose stream"
# Write-Progress "Output to the Progress stream"
# Write-Warning "Output to the Warning stream"
# Write-Debug "Output to the Debug stream"
