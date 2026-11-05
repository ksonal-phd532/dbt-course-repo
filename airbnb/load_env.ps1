# Load KEY=VALUE pairs from airbnb/.env into the current PowerShell session.
# Usage (dot-source so variables persist):  . .\airbnb\load_env.ps1
$envFile = Join-Path $PSScriptRoot '.env'
Get-Content $envFile | Where-Object { $_ -match '^\s*[^#\s][^=]*=' } | ForEach-Object {
    $name, $value = $_ -split '=', 2
    Set-Item -Path "env:$($name.Trim())" -Value $value.Trim()
}
