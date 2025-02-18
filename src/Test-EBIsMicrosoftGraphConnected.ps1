
<#
    .SYNOPSIS
        Checks if the current PowerShell session is connected to Microsoft Graph
    .Description
        Checks if the current PowerShell session is connected to Microsoft Graph, using the Microsoft.Graph PowerShell module
    .NOTES
        Author: Dan Toft
#>

function Test-EBIsMicrosoftGraphConnected {
    return $null -ne (Get-MgContext)    
}