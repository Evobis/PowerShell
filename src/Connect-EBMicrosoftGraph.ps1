<#
    .SYNOPSIS
        Ensures that the current PowerShell session is connected to Microsoft Graph
    .Description
        Ensures that the current PowerShell session is connected to Microsoft Graph, using the Microsoft.Graph PowerShell module
    .NOTES
        Author: Dan Toft
#>

$neededScopes = @(
    "AppRoleAssignment.ReadWrite.All", 
    "Application.Read.All",
    "Sites.FullControl.All"
)

function Connect-EBMicrosoftGraph {
    if (-not (Test-EBIsMicrosoftGraphConnected)) {
        Connect-MgGraph -Scopes $neededScopes -NoWelcome;
        Write-Host "✅ - Microsoft Graph has been connected" -ForegroundColor Green
    }
    else {
        Write-Host "⚠️ - Microsoft Graph is already connected" -ForegroundColor Yellow
        Write-Host "⚠️ - Checking scopes" -ForegroundColor Yellow

        $currentScopes = (Get-MgContext).Scopes
        $missingScopes = $neededScopes | Where-Object { $currentScopes -notcontains $_ } | Measure-Object | Select-Object -ExpandProperty Count
        if($missingScopes -le 0) {
            Write-Host "✅ - All required scopes are present" -ForegroundColor Green
        } else {
            Write-Host "❌ - Missing required scopes: $missingScopes" -ForegroundColor Red
            Write-Host "❌ - Reconnecting to Microsoft Graph with all required scopes" -ForegroundColor Red
            Connect-MgGraph -Scopes $neededScopes -NoWelcome;
            Write-Host "✅ - Microsoft Graph has been connected" -ForegroundColor Green
        }
        
    }
}