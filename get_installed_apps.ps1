<#
.DESCRIPTION
This Script will get all the installad apps on a system. you can use this apps to manage 
your startmenue or taskbar settings with the right links.
Find the Application User Model ID of an installed app
This script is from the MS-Docs reference:
https://msdn.microsoft.com/windows/hardware/commercialize/customize/enterprise/find-the-application-user-model-id-of-an-installed-app

.EXAMPLE
get_installed_apps.ps1 -output "c:\temp\installed_apps.txt"

.NOTES
Author: Mirko Colemberg / baseVISION
Date:   29.04.2017

History
    001: First Version
    002: Correct Example in Documentation

#>
[CmdletBinding()]
Param(
    [string]$output
)


listAumids| out-file $output

function listAumids( $userAccount ) {
<#
    .DESCRIPTION
    get from all users all the installed apps.
    like allusers, user, CustomerAccount

    .NOTES
    This function get all the apps collected on a system.
    #>

    if ($userAccount -eq "allusers")
    {
        # Find installed packages for all accounts. Must be run as an administrator in order to use this option.
        $installedapps = Get-AppxPackage -allusers
    }
    elseif ($userAccount)
    {
        # Find installed packages for the specified account. Must be run as an administrator in order to use this option.
        $installedapps = get-AppxPackage -user $userAccount
    }
    else
    {
        # Find installed packages for the current account.
        $installedapps = get-AppxPackage
    }

    $aumidList = @()
    foreach ($app in $installedapps)
    {
        foreach ($id in (Get-AppxPackageManifest $app).package.applications.application.id)
        {
            $aumidList += $app.packagefamilyname + "!" + $id
        }
    }

    return $aumidList
} 