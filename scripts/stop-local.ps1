$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$pidFile = Join-Path $projectRoot '.local/server.pid'
if (-not (Test-Path -LiteralPath $pidFile)) { Write-Output 'Not running'; exit 0 }
$serverPid = [int](Get-Content -LiteralPath $pidFile)
$running = Get-CimInstance Win32_Process -Filter "ProcessId = $serverPid" -ErrorAction SilentlyContinue
if ($running -and $running.CommandLine -like ('*' + $projectRoot + '*dist*server*index.js*')) {
    Stop-Process -Id $serverPid
    Write-Output 'Stopped ghtrends. SQLite data remains in data/.'
} elseif ($running) { throw 'PID belongs to another command; refusing to stop it.' }
Remove-Item -LiteralPath $pidFile
