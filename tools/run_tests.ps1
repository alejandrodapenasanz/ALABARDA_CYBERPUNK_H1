param([string]$Godot = $env:GODOT_BIN, [string]$OutputDir = '', [switch]$Graphics)
$ErrorActionPreference = 'Stop'
$repoH03 = Split-Path -Parent $PSScriptRoot
$argumentsH03 = @('-X', 'utf8', (Join-Path $PSScriptRoot 'h03/run_tests.py'))
if ($Godot) { $argumentsH03 += @('--godot', $Godot) }
if ($OutputDir) { $argumentsH03 += @('--output', $OutputDir) }
if ($Graphics) { $argumentsH03 += '--graphics' }
Push-Location -LiteralPath $repoH03
try {
    & python @argumentsH03
    $resultH03 = $LASTEXITCODE
} finally { Pop-Location }
exit $resultH03
