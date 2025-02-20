# Getting started

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

![A screenshot from the sign-in process](../assets/Choose-account.png)

Once you're signed in, you'll be prompted to consent some permissions for the `Microsoft Graph Command Line Tools` application, this is the backing of our cmdlets, and is used to authenticate and authorize the cmdlets, simply follow the instructions in the browser.

![A screenshot from the sign-in process](../assets/Consent.png)

Once all of that has been completed, you should see the following:

![A screenshot from a successful initialization of the library](../assets/Success.png)

If everything goes well, you should see the following, and you're ready to use the cmdlets.