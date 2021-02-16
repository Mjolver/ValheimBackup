# Necessary variables
$userName = $env:USERNAME
$saveFiles = "C:\Users\$userName\AppData\LocalLow\IronGate\Valheim\worlds\"
$destination = "C:\Users\$userName\Documents\ValheimBackup\"
Write-Host "Saving game files to $destination" -ForegroundColor Green

# Test if path exists, if it doesn't exists it creates a folder
$pathExists = Test-Path $destination

if ($pathExists -eq $false )
    { 
        mkdir -Path "C:\Users\$userName\Documents\ValheimBackup\"
    }

Copy-Item -Recurse -Path $saveFiles -Destination $destination -Force:$true

# Creates a scheduled task that runs every hour.
Write-Host "Creating scheduled task..." -ForegroundColor Green
$filePath = "C:\Users\$userName\Downloads\ValheimSaveBackup-1.0\ValheimSaveBackup-1.0\Script\ValheimSaveBackup.ps1"
$TaskName = 'ValheimBackup'
$Action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument "-WindowStyle Hidden -NonInteractive -NoProfile -File $filePath "
$Settings = New-ScheduledTaskSettingsSet
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 60)
$TaskExists = Get-ScheduledTask | Where-Object {$_.TaskName -Like $TaskName }

if ($TaskExists)
    {
        Write-Host "Scheduled task already exists..." -ForegroundColor Yellow
        Write-Host "Script finished. Press any key to continue" -ForegroundColor Green
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        exit
    } 
    else 
    {
        Write-Host "Scheduled task doesn't exist, creating task.." -ForegroundColor Yellow
        $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
        Register-ScheduledTask -TaskName $TaskName -InputObject $Task -User $userName
        Write-Host "Script finished. Press any key to continue" -ForegroundColor Green
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    }