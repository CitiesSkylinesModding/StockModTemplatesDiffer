Set-StrictMode -Version Latest

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

# Retrieve the version number from launcher-settings.json

Write-Host -ForegroundColor Blue "Detecting game version number..."

$launcherSettingsPath = "C:\Program Files (x86)\Steam\steamapps\common\Cities Skylines II\Launcher\launcher-settings.json"
if (-not (Test-Path -Path $launcherSettingsPath)) {
    Write-Host "Launcher settings file not found ($launcherSettingsPath)."
    exit 1
}

$launcherSettings = Get-Content -Path $launcherSettingsPath | Out-String | ConvertFrom-Json
$version = $launcherSettings.version

if (-not $version) {
    Write-Host "Version number not found in launcher settings."
    exit 1
}

Write-Host "Version number retrieved: $version"

# Delete previous template folders

Write-Host -ForegroundColor Blue "Deleting previous folders..."

Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "dotnet"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "ui"

# Deploy .NET mod

Write-Host -ForegroundColor Blue "Deploying .NET mod..."

dotnet new csiimod --name StockMod --output dotnet --IncludeSetting

# Deploy UI mod

Write-Host -ForegroundColor Blue "Deploying UI mod..."

npm x create-csii-ui-mod

if (-not $?) {
    exit 1
}

Rename-Item -Force "StockMod" "ui"
Remove-Item -Recurse -Force "ui/node_modules"

# Ask the user to confirm changes

Write-Host -ForegroundColor Blue "Please review changes:"

git add .
git diff --staged

$confirmation = Read-Host "Do you want to proceed with committing the changes? (yes/no)"
if ($confirmation -ne "yes") {
    Write-Host "Changes not committed."
    exit 0
}

# Push the tag and commit

Write-Host -ForegroundColor Blue "Committing and pushing..."

git commit -m "chore: update templates for version $version"
git tag $version
git push origin main --tags

Write-Host -ForegroundColor Blue "Done."
