---
external help file: OSD-help.xml
Module Name: OSD
online version: https://osdcloud.osdeploy.com
schema: 2.0.0
---

# New-OSDCloudTemplate

## SYNOPSIS
Creates an OSDCloud Template in $env:ProgramData\OSDCloud

## SYNTAX

```
New-OSDCloudTemplate [[-Language] <String[]>] [[-SetAllIntl] <String>] [[-SetInputLocale] <String>] [-WinRE]
 [<CommonParameters>]
```

## DESCRIPTION
Creates an OSDCloud Template in $env:ProgramData\OSDCloud

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Language
Adds additional language ADK Packages

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetAllIntl
Sets all International settings in WinPE to the specified setting

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetInputLocale
Sets the default InputLocale in WinPE to the specified Input Locale

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WinRE
Uses Windows 10 WinRE.wim instead of the ADK Boot.wim

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://osdcloud.osdeploy.com](https://osdcloud.osdeploy.com)
