![Evobis logo](./assets/EVOBIS-Logo.png)

# Evobis Customer PowerShell module

> [!NOTE]
> This library is in preview, and is subject to change.

This is a PowerShell library/module that is designed to aid [Evobis](https://evobis.dk) customers in managing their tenant.

These cmdlets aren't meant to be used for automations, but rather as a way to provide a simple interface to the more complex tasks that are often needed when working with development across Microsoft 365, such as managing permissions that don't yet have a GUI provided by Microsoft.

## Getting started

> [!IMPORTANT]
> This module is designed to be run with PowerShell 7.x and above, and **WILL NOT** work with Windows PowerShell.
> 
> The latest version of PowerShell can be downloaded from [here](https://aka.ms/powershell-release?tag=stable).

The solution isn't a "module" in the sense that you don't install it on your machine. 

Instead you just run it from the repository, when needed, and then it's only available in the current session.

To use it, simply run the following command in a PowerShell session:

```powershell
irm "https://raw.githubusercontent.com/Evobis/PowerShell/refs/heads/main/main.ps1" | iex
```

You'll be prompted to sign in with your **Admin account**.

![A screenshot from the sign-in process](./assets/Choose-account.png)

Once you're signed in, you'll be prompted to consent some permissions for the `Microsoft Graph Command Line Tools` application, this is the backing of our cmdlets, and is used to authenticate and authorize the cmdlets, simply follow the instructions in the browser.

![A screenshot from the sign-in process](./assets/Consent.png)

Once all of that has been completed, you should see the following:

![A screenshot from a successful initialization of the library](./assets/Success.png)

If everything goes well, you should see the following, and you're ready to use the cmdlets:

## Cmdlets

There are loads of service cmdlets available, those aren't intended to be used directly, but are instead called via the other cmdlets, the following are the ones intended for 'public usage'.

### Add Cmdlets

#### [Add-EBPermissionsToManagedIdentity](docs/Add-EBPermissionsToManagedIdentity.md)

#### [Add-EBSitesSelectedPermissionToSite](docs/Add-EBSitesSelectedPermissionToSite.md)

## Changes

### 0.0.1

This is the initial release of the module, and contains the following cmdlets:

- `Add-EBPermissionsToManagedIdentity`
- `Add-EBSitesSelectedPermissionToSite`

More to come in the future.

## Contributing

Since this is a library intended for internal use, we don't expect any contributions, but if you find any issues, please report them to your consultant at [Evobis](https://evobis.dk/om-evobis/our-team/), or feel free to fork the repository, and provide a fix, we'll be happy to look over your contributions.

## Issues

If you find any issues, please contact your consultant at [Evobis](https://evobis.dk/om-evobis/our-team/).

## Contributors

- [Dan Toft](https://dan-toft.dk)
