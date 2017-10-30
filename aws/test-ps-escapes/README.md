# Test fixer and auto escape of chars special to PowerShell

```
packer fix windows-2016-fix-me.json > windows-2016-fixed.json
```

```
PACKER_LOG=1 packer build windows-2016-fixed.json 2> packer.log
```
