function New-OSDPartitionWindows {
    [CmdletBinding()]
    param (
        #Number of the Disk to prepare
        #Alias = Disk DiskNumber
        [Parameter(Position = 0)]
        [Alias('Disk','DiskNumber')]
        [int]$Number = 0,

        #Drive Label of the Windows Partition
        #Default = OS
        #Alias = LW
        [Alias('LW')]
        [string]$LabelWindows = 'OS',

        #Skips the creation of the Recovery Partition
        #Alias = NoR
        [Alias('NoR')]
        [switch]$NoRecovery,
        
        #Drive Label of the Recovery Partition
        #Default = Recovery
        #Alias = LR
        [Alias('LR')]
        [string]$LabelRecovery = 'Recovery',

        #Size of the Recovery Partition
        #Default = 984MB
        #Range = 499MB - 40000MB
        #Alias = SR Recovery Tools
        [Alias('SR','Recovery','Tools')]
        [ValidateRange(499MB,40000MB)]
        [uint64]$SizeRecovery = 984MB
    )
    Write-Verbose "Prepare Windows Partition"
    if (Get-OSDGather IsUEFI) {
        #======================================================================================================
        #	GPT
        #======================================================================================================
        if ($NoRecovery.IsPresent) {
            Write-Verbose "New-Partition GptType {ebd0a0a2-b9e5-4433-87c0-68b6b72699c7} DriveLetter W"
            $PartitionWindows = New-Partition -DiskNumber $Number -UseMaximumSize -GptType '{ebd0a0a2-b9e5-4433-87c0-68b6b72699c7}' -DriveLetter W
    
            Write-Verbose "Format-Volume FileSystem NTFS NewFileSystemLabel $LabelWindows"
            $null = Format-Volume -Partition $PartitionWindows -NewFileSystemLabel "$LabelWindows" -FileSystem NTFS -Force -Confirm:$false
        } else {
            $OSDDisk = Get-Disk -Number $Number
            $SizeWindows = $($OSDDisk.LargestFreeExtent) - $SizeRecovery
            $SizeWindowsGB = [math]::Round($SizeWindows / 1GB,1)
    
            Write-Verbose "New-Partition GptType {ebd0a0a2-b9e5-4433-87c0-68b6b72699c7} Size $($SizeWindowsGB)GB DriveLetter W"
            $PartitionWindows = New-Partition -DiskNumber $Number -Size $SizeWindows -GptType '{ebd0a0a2-b9e5-4433-87c0-68b6b72699c7}' -DriveLetter W
    
            Write-Verbose "Format-Volume FileSystem NTFS NewFileSystemLabel $LabelWindows"
            $null = Format-Volume -Partition $PartitionWindows -NewFileSystemLabel "$LabelWindows" -FileSystem NTFS -Force -Confirm:$false
            #======================================================================================================
            #	Recovery Partition
            #======================================================================================================
            Write-Verbose "Prepare $LabelRecovery Partition"
            Write-Verbose "New-Partition GptType {de94bba4-06d1-4d40-a16a-bfd50179d6ac} UseMaximumSize"
            $PartitionRecovery = New-Partition -DiskNumber $Number -GptType '{de94bba4-06d1-4d40-a16a-bfd50179d6ac}' -UseMaximumSize
    
            Write-Verbose "Format-Volume FileSystem NTFS NewFileSystemLabel $LabelRecovery"
            $null = Format-Volume -Partition $PartitionRecovery -NewFileSystemLabel "$LabelRecovery" -FileSystem NTFS -Confirm:$false
    
            Write-Verbose "Set-Partition Attributes 0x8000000000000001"
            $null = @"
select disk $Number
select partition $($PartitionRecovery.PartitionNumber)
gpt attributes=0x8000000000000001 
exit 
"@ |
            diskpart.exe
        }
    } else {
        #======================================================================================================
        #	MBR
        #======================================================================================================
        if ($NoRecovery.IsPresent) {
            Write-Verbose "New-Partition MbrType IFS DriveLetter W"
            $PartitionWindows = New-Partition -DiskNumber $Number -UseMaximumSize -MbrType IFS -DriveLetter W
    
            Write-Verbose "Format-Volume FileSystem NTFS NewFileSystemLabel $LabelWindows"
            $null = Format-Volume -Partition $PartitionWindows -NewFileSystemLabel "$LabelWindows" -FileSystem NTFS -Force -Confirm:$false
        } else {
            $OSDDisk = Get-Disk -Number $Number
            $SizeWindows = $($OSDDisk.LargestFreeExtent) - $SizeRecovery
            $SizeWindowsGB = [math]::Round($SizeWindows / 1GB,1)
    
            Write-Verbose "New-Partition Size $($SizeWindowsGB)GB MbrType IFS DriveLetter W"
            $PartitionWindows = New-Partition -DiskNumber $Number -Size $SizeWindows -MbrType IFS -DriveLetter W
    
            Write-Verbose "Format-Volume FileSystem NTFS NewFileSystemLabel $LabelWindows"
            $null = Format-Volume -Partition $PartitionWindows -NewFileSystemLabel "$LabelWindows" -FileSystem NTFS -Force -Confirm:$false
            #======================================================================================================
            #	Recovery Partition
            #======================================================================================================
            Write-Verbose "Prepare $LabelRecovery Partition"
            Write-Verbose "New-Partition UseMaximumSize"
            $PartitionRecovery = New-Partition -DiskNumber $Number -UseMaximumSize
    
            Write-Verbose "Format-Volume FileSystem NTFS NewFileSystemLabel $LabelRecovery"
            $null = Format-Volume -Partition $PartitionRecovery -NewFileSystemLabel "$LabelRecovery" -FileSystem NTFS -Confirm:$false
    
            Write-Verbose "Set-Partition id 27"
            $null = @"
select disk $Number
select partition $($PartitionRecovery.PartitionNumber)
set id=27
exit 
"@ |
        diskpart.exe
        }
    }
}