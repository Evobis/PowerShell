# Add-EBPermissionsToManagedIdentity

This cmdlet is used to add permissions to a managed identity.

## Example

```powershell
Add-EBPermissionsToManagedIdentity -ManagedIdentityObjectId "b8ef0ce0-2e99-4950-8bfd-713fb0ce810a" -SharePointScopesApplication Sites.FullControl.All -GraphScopesApplication Directory.Read.All, Mail.Send
```

```powershell
Add-EBPermissionsToManagedIdentity -ManagedIdentityObjectId "b8ef0ce0-2e99-4950-8bfd-713fb0ce810a" -SharePointScopesDelegated AllSites.FullControl -GraphScopesDelegated Mail.ReadWrite.Shared, Mail.Send, Presence.Read
```


```powershell
Add-EBPermissionsToManagedIdentity -ManagedIdentityObjectId "b8ef0ce0-2e99-4950-8bfd-713fb0ce810a" -SharePointScopesApplication Sites.FullControl.All -GraphScopesApplication Directory.Read.All, Mail.Send -SharePointScopesDelegated AllSites.FullControl -GraphScopesDelegated Mail.ReadWrite.Shared, Mail.Send, Presence.Read
```

## Parameters

- `-ManagedIdentityObjectId`: **Guid** The object id of the managed identity.
- `-SharePointScopesApplication`: **string\[\]** The SharePoint Application permissions to add, these support autocomplete of the possible scopes, and allow multiple, simply by separating them with a `,`.
- `-GraphScopesApplication`: **string\[\]** The Graph Application permissions to add, these support autocomplete of the possible scopes, and allow multiple, simply by separating them with a `,`.
- `-SharePointScopesDelegated`: **string\[\]** The SharePoint Delegated permissions to add, these support autocomplete of the possible scopes, and allow multiple, simply by separating them with a `,`.
- `-GraphScopesDelegated`: **string\[\]** The Graph Delegated permissions to add, these support autocomplete of the possible scopes, and allow multiple, simply by separating them with a `,`.