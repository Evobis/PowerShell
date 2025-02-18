$ErrorActionPreference = "Stop"
$ProductName = "Evobis Customer PowerShell module";
$ProductVersion = "0.0.1";

Write-Host "👋 - Welcome to the $ProductName!`n" -ForegroundColor Cyan
try {
    
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

    $rootUrl = "https://raw.githubusercontent.com/Evobis-ApS/PowerShell/refs/heads/main/src"
    foreach ($cmdlet in $cmdlets) {
        Write-Host "🔍 - Loading $cmdlet" -ForegroundColor Magenta;
        irm -Uri "$rootUrl/$cmdlet.ps1" | iex
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