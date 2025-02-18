<#
    .SYNOPSIS
        Adds a role assignment to a managed identity
    .Description
        Given a service principal, managed identity object id, and a role assignment, this function will add the role assignment to the managed identity
    .NOTES
        Author: Dan
#>

function Add-EBRoleAssignment {
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [Microsoft.Graph.PowerShell.Models.MicrosoftGraphServicePrincipal]$ServicePrincipal,

        [Parameter(Position = 1, mandatory = $true)]
        [string]$ManagedIdentityObjectId,

        [Parameter(Position = 2, mandatory = $true)]
        [string]$RoleAssignment
    )

    $appRole = $ServicePrincipal.AppRoles | ? Value -eq $RoleAssignment
    $existing = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $ManagedIdentityObjectId | ? AppRoleId -eq $appRole.Id
    if ($null -eq $existing) {
        Write-Host "🆕 Adding assignment: '$RoleAssignment'";
        $_ = New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $ManagedIdentityObjectId -PrincipalId $ManagedIdentityObjectId -ResourceId $ServicePrincipal.Id -AppRoleId $appRole.Id
    }
    else {
        Write-Host "✅ Assignment '$RoleAssignment' already exists, skipping";
    }
}