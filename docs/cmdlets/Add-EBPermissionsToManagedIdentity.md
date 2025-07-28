# Add-EBPermissionsToManagedIdentity

This cmdlet is used to add permissions to a managed identity.

## Example

```powershell
Add-EBPermissionsToManagedIdentity -ManagedIdentityObjectId "b8ef0ce0-2e99-4950-8bfd-713fb0ce810a" -SharePointScopes Sites.FullControl.All -GraphScopes Directory.Read.All, Mail.Send
```

## Parameters

- `-ManagedIdentityObjectId`: **Guid** The object id of the managed identity.
- `-SharePointScopes`: **string\[\]** The SharePoint scopes to add, these support autocomplete of the possible scopes, and allow multiple, simply by separating them with a `,`.
- `-GraphScopes`: **string\[\]** The Graph scopes to add, these support autocomplete of the possible scopes, and allow multiple, simply by separating them with a `,`.
- `-SharePointScopesDelegated`: **string\[\]** The SharePoint scopes to add, these support autocomplete of the possible scopes, and allow multiple, simply by separating them with a `,`.
- `-GraphScopesDelegated`: **string\[\]** The Graph scopes to add, these support autocomplete of the possible scopes, and allow multiple, simply by separating them with a `,`.