$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$runtimeDirectory = Join-Path $projectRoot '.local'
New-Item -ItemType Directory -Force -Path $runtimeDirectory | Out-Null
$pidFile = Join-Path $runtimeDirectory 'server.pid'
if (Test-Path -LiteralPath $pidFile) {
    $serverPid = [int](Get-Content -LiteralPath $pidFile)
    $running = Get-CimInstance Win32_Process -Filter "ProcessId = $serverPid" -ErrorAction SilentlyContinue
    if ($running -and $running.CommandLine -like ('*' + $projectRoot + '*dist*server*index.js*')) {
        Write-Output 'Already running: http://127.0.0.1:3721/?lang=zh'
        exit 0
    }
}
if (-not (Test-Path -LiteralPath (Join-Path $projectRoot 'dist/server/index.js'))) {
    throw 'Build first: npm ci; npm run build'
}
$env:HOST = '127.0.0.1'
$env:PORT = '3721'
$env:PUBLIC_URL = 'http://127.0.0.1:3721'
$env:GHTRENDS_DATA_DIR = Join-Path $projectRoot 'data'
$env:GHTRENDS_HOSTED = '0'
$env:GHTRENDS_PAID_RESEARCH = '0'
$nodePath = (Get-Command node.exe).Source
$entryPath = Join-Path $projectRoot 'dist/server/index.js'
$serverProcess = Start-Process -FilePath $nodePath -ArgumentList @('--env-file-if-exists=.env', '--disable-warning=ExperimentalWarning', ('"' + $entryPath + '"')) -WorkingDirectory $projectRoot -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $runtimeDirectory 'server.log') -RedirectStandardError (Join-Path $runtimeDirectory 'server-error.log')
Set-Content -LiteralPath $pidFile -Value $serverProcess.Id
Write-Output ('Started PID ' + $serverProcess.Id + ': http://127.0.0.1:3721/?lang=zh')
