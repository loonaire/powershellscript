
function Get-InstalledSoftwareInfos {
    <#
    .SYNOPSIS
    Function to get some information about installed software
    
    .DESCRIPTION
    Function to get Name, Version, Uninstall executable of installed software
    
    .PARAMETER Name
    Specifies the name of the Software to search
    
    .EXAMPLE
    PS> Get-InstalledSoftwareInfos softwarename
    PS> Get-InstalledSoftwareInfos -Name softwarename
    
    .NOTES
    Inspired from https://www.sharepointdiary.com/2020/04/powershell-to-get-installed-software.html
    Some issues can be appeared, some softare are detected as multiple installation by Windows and because i use wildcard and like for search the software, some software can be undected or the bad software can be returned
    #>
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Specifies of the software to get')]
        [String] $Name
    )

    $registryPath = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall", 
        "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall", 
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
    )

    foreach ($path in $registryPath) {
        $appsInPath = Get-ChildItem -Path "$path" | Get-ItemProperty | Where-Object {($_.DisplayName -like "*$Name*")} | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate, UninstallString
        if ($appsInPath.length -lt 0) {
           return $appsInPath
        }
    }
    return
}


Get-InstalledSoftwareInfos -Name 'Firefox'
