# DISM GUI Build Script
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $ScriptDir

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "       Building DISM GUI Solution        " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

$ProjectPath = Join-Path $ScriptDir "DISM GUI\DISM GUI.vbproj"

# Locate MSBuild or dotnet
$MSBuildPath = "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"

If (Test-Path $MSBuildPath) {
    Write-Host "[1/3] Restoring NuGet Packages using MSBuild..." -ForegroundColor Yellow
    & $MSBuildPath $ProjectPath /t:Restore /nologo /v:m
    if ($LASTEXITCODE -ne 0) { throw "Restore failed!" }

    Write-Host "[2/3] Building Release Executable..." -ForegroundColor Yellow
    & $MSBuildPath $ProjectPath /p:Configuration=Release /t:Rebuild /nologo /v:m
    if ($LASTEXITCODE -ne 0) { throw "Build failed!" }
} Else {
    Write-Host "[1/3] Restoring NuGet Packages using dotnet..." -ForegroundColor Yellow
    dotnet restore $ProjectPath
    if ($LASTEXITCODE -ne 0) { throw "Restore failed!" }

    Write-Host "[2/3] Building Release Executable using dotnet..." -ForegroundColor Yellow
    dotnet build $ProjectPath -c Release --no-restore
    if ($LASTEXITCODE -ne 0) { throw "Build failed!" }
}

# Locate output EXE
$ExePath = Join-Path $ScriptDir "DISM GUI\bin\Release\net9.0-windows\DISM GUI.exe"
If (-not (Test-Path $ExePath)) {
    $ExePath = (Get-ChildItem -Path (Join-Path $ScriptDir "DISM GUI\bin") -Filter "DISM GUI.exe" -Recurse | Select-Object -First 1).FullName
}

If ($ExePath -and (Test-Path $ExePath)) {
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "BUILD SUCCESSFUL!" -ForegroundColor Green
    Write-Host "Executable output: $ExePath" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
} Else {
    Write-Host "Build completed, but DISM GUI.exe could not be found." -ForegroundColor Yellow
}
