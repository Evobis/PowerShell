<#
    .SYNOPSIS
        Adds a role assignment to a managed identity
    .Description
        Given a service principal, managed identity object id, and a role assignment, this function will add the role assignment to the managed identity
    .NOTES
        Author: Dan & Steffen
#>

function Add-EBRoleAssignment {
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [PSCustomObject]$ServicePrincipal,

        [Parameter(Position = 1, mandatory = $true)]
        [string]$ManagedIdentityObjectId,

        [Parameter(Position = 2, mandatory = $true)]
        [string]$RoleAssignment,
        
        [Parameter(Position = 3, mandatory = $false)]
        [switch]$Delegated = $false
    )

    if ($Delegated -eq $false) {
        $appRole = $ServicePrincipal.AppRoles | ? Value -eq $RoleAssignment
        $existing = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $ManagedIdentityObjectId | ? AppRoleId -eq $appRole.Id
        if ($null -eq $existing) {
            Write-Host "🆕 Adding assignment: '$RoleAssignment'";
            New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $ManagedIdentityObjectId -PrincipalId $ManagedIdentityObjectId -ResourceId $ServicePrincipal.Id -AppRoleId $appRole.Id | out-null
        }
        else {
            Write-Host "✅ Assignment '$RoleAssignment' already exists, skipping";
        }
    }
    else {
        $existing = Get-MgOauth2PermissionGrant -Filter "clientId eq '$ManagedIdentityObjectId' and consentType eq 'AllPrincipals'"  | ? ResourceId -eq $ServicePrincipal.Id
        if ($null -eq $existing) {
            Write-Host "🆕 Adding assignment: '$RoleAssignment'";
            New-MgOauth2PermissionGrant -ClientId $ManagedIdentityObjectId -Scope $RoleAssignment -ConsentType "AllPrincipals" -ResourceId $ServicePrincipal.Id| out-null
        } else {
            Write-Host "✅ Assignment '$RoleAssignment' already exists, Updating insted";
            $scope = $existing.Scope.Split(" ")
            $contains = $scope -contains $RoleAssignment

            if($contains -eq $false) {
                $scope += $RoleAssignment
                Update-MgOauth2PermissionGrant -OAuth2PermissionGrantId $existing.Id -Scope ($scope -join " ")| out-null
            } else {
                Write-Host "✅ Role assignment '$RoleAssignment' already exists in the scope, skipping update";
            }
        }
    }
}