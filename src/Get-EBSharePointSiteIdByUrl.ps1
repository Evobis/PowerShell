<#
    .SYNOPSIS
        Using the Microsoft Graph API, this function will return the SharePoint Site ID for a given URL
    .Description
        Using the Microsoft Graph API, this function will return the SharePoint Site ID for a given URL
    .NOTES
        Author: Dan Toft
#>

function Get-EBSharePointSiteIdByUrl {
    param (
        [string]$SiteUrl
    )

    $site = Get-MgSite -Search $SiteUrl -Property "id,name,webUrl"
    if ($null -eq $site) {
        throw "❌ - Site '$SiteUrl' not found - make sure the URL is correct, and no trailing slashes are present"
    }
    write-host "✅ - Site '$($site.Name)' found at '$($site.WebUrl)'"
    return $site.Id
}
