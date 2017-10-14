Write-Host "PACKER_BUILD_NAME is automatically set for you, " -NoNewline
Write-Host "or you can set it in your builder variables; " -NoNewline
Write-Host "The default for this builder is:" $Env:PACKER_BUILD_NAME

Write-Host "Use backticks as the escape character when required in powershell:"
Write-Host "For example, VAR1 from our config is:" $Env:VAR1
Write-Host "Likewise, VAR2 is:" $Env:VAR2
Write-Host "Finally, VAR3 is:" $Env:VAR3
