<#
    .SYNOPSIS
        Checks if a PowerShell module is installed, if it's not it will install it
    .Description
        Checks if a PowerShell module is installed, if it's not it will install it
    .NOTES
        Author: Dan Toft
#>

function Enable-EBModule {
    param (
        [string]$ModuleName
    )

    $module = Get-Module -ListAvailable -Name $ModuleName -ErrorAction SilentlyContinue
    if ($null -eq $module) {
        Write-Host "⚠️ - '$ModuleName' PowerShell Module not found, installing it now" -ForegroundColor Yellow
        Install-Module -Name $ModuleName -Force -AllowClobber -Scope CurrentUser
        Import-Module $ModuleName
        Write-Host "✅ - '$ModuleName' PowerShell Module has been installed" -ForegroundColor Green
    }
    else {
        Write-Host "✅ - '$ModuleName' PowerShell Module is already installed" -ForegroundColor Green
    }
}