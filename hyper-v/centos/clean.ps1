# Clean Packer build artifacts
Remove-Item -Path boxes\*.box -ErrorAction SilentlyContinue
Remove-Item -Recurse -Path output-hyperv-iso -ErrorAction SilentlyContinue