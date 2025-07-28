$ErrorActionPreference = "Stop"
$ProductName = "Evobis Customer PowerShell module - DEV";
$ProductVersion = "0.0.3";

Write-Host "👋 - Welcome to the $ProductName!`n" -ForegroundColor Cyan
try {
    
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        throw "❌ - This module requires PowerShell 7 or higher to run, please upgrade your PowerShell version and try again - https://aka.ms/powershell-release?tag=stable"
    }

    Write-host "⌛ - Loading $ProductName" -ForegroundColor Magenta

    $cmdlets = @(
        "Enable-EBModule",
        "Test-EBIsPowerShellCore",
        "Test-EBIsMicrosoftGraphConnected",
        "Connect-EBMicrosoftGraph",
        "Add-EBPermissionsToManagedIdentity",
        "Add-EBRoleAssignment",
        "Get-EBSharePointSiteIdByUrl",
        "Add-EBSitesSelectedPermissionToSite"
    )

    foreach ($cmdlet in $cmdlets) {
        Write-Host "🔍 - Loading $cmdlet" -ForegroundColor Magenta;
        . "$PSScriptRoot\src\$cmdlet.ps1"
    }

    Write-Host "✅ - $ProductName is loaded`n" -ForegroundColor Green;
    Write-Host "👷 - Checking prerequisites" -ForegroundColor Magenta;
    Test-EBIsPowerShellCore;
    Enable-EBModule -ModuleName "Microsoft.Graph";

    Write-Host "✅ - Prerequisites are met`n" -ForegroundColor Green;
    Write-Host "🚀 - Connecting to Microsoft Graph" -ForegroundColor Magenta;
    Connect-EBMicrosoftGraph;

    Write-Host "`n✅ - $ProductName ($ProductVersion) loaded successfully - you're ready to go!" -ForegroundColor Green;

}
catch {
    Write-Host "❌ - $ProductName failed to load" -ForegroundColor Red;
    Write-Host "❌ - Error: $($_.Exception.Message)" -ForegroundColor Red;
    Write-Host "❌ - Please fix the error and try again" -ForegroundColor Red;
}