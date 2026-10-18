# Registers a scheduled task that runs sync.ps1 every 15 minutes and at logon (no window).
$pwsh = (Get-Command pwsh.exe).Source
$script = Join-Path $PSScriptRoot 'sync.ps1'
$action = New-ScheduledTaskAction -Execute 'conhost.exe' -Argument "--headless `"$pwsh`" -NoProfile -NonInteractive -File `"$script`""
$every15 = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 15)
$logon = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 5) -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName 'ConfigsBackupSync' -Action $action -Trigger $every15, $logon -Settings $settings -Force `
    -Description 'Sync nvim/powershell/wezterm configs to .configs-bak and push' | Out-Null
Start-ScheduledTask -TaskName 'ConfigsBackupSync'
Write-Host 'Registered ConfigsBackupSync. Check sync.log for results.'
