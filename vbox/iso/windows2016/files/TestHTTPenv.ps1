# Test the Packer HTTP Server Environment variable

Write-Host "Packer Build Name: $env:PACKER_BUILD_NAME"
Write-Host "Packer Builder Type: $env:PACKER_BUILDER_TYPE"

$FileName = "random.txt"
$SourceFile = "http://$env:PACKER_HTTP_ADDR/$FileName"
$TargetFile = "$env:TEMP/$FileName"
$SourceFileMd5 = 'c3b62a675989c760fb3ae743444e926e'

Write-Host "Source file is at $SourceFile"
Write-Host "Target download location is $TargetFile"

Write-Host "Downloading file..."
Invoke-WebRequest $SourceFile -OutFile $TargetFile | Out-Null
Write-Host "Done"

Write-Host "Calculating md5 sum..."
$TargetFileMd5 = $(Get-FileHash $TargetFile -Algorithm MD5).Hash
if ($SourceFileMd5 -ne $TargetFileMd5) {
    Write-Host 'ERROR: Downloaded file does not have expected MD5 sum'
} else {
    Write-Host 'GOOD: Downloaded file has expected MD5 sum'
}
Write-Host "Complete"
