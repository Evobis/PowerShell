<#
    .SYNOPSIS
        Checks if the current PowerShell session is running PowerShell 7 or higher
    .Description
        Checks if the current PowerShell session is running PowerShell 7 or higher
    .NOTES
        Author: Dan Toft
#>

function Test-EBIsPowerShellCore {
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        Write-Host "❌ - This module requires PowerShell 7 or higher to run" -ForegroundColor Red
        throw "❌ - This module requires PowerShell 7 or higher to run, please upgrade your PowerShell version and try again - https://aka.ms/powershell-release?tag=stable"
        exit
    }
    else {
        Write-Host "✅ - PowerShell 7 or higher detected" -ForegroundColor Green
    }
}