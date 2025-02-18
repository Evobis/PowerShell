# Add-EBSitesSelectedPermissionToSite

This cmdlet allows you to grant an application access to a single SharePoint site, this is useful when you want to grant access to a site, rather than using the all mighty `Sites.FullControl.All`, but instead the `Sites.Selected`.

## Example

```powershell
Add-EBSitesSelectedPermissionToSite -ClientId "<Guid>" -SiteUrl "https://<tenant>.sharepoint.com/sites/<site>" -Permission read
```

## Parameters

- `-ClientId`/`-ObjectId`: **Guid** The ClientId of the application, or the ObjectId of the managed identity.
- `-SiteUrl`: **string** The URL of the site to grant access to, without any trailing slashes.
- `-Permission`: **string** The permission to grant, this can be `read`, `write`