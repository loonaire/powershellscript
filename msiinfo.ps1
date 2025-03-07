$MSIFileName = "GLPI-Agent-1.11-x64.msi"        #Full Path to .msi file

function Get-MSIProperties {
    <#
    .SYNOPSIS
    Function to get properties from MSI file
    
    .DESCRIPTION
    Function to get every properties of MSI file.
    Return simple MSI properties like ProductName, ProductVersion, ProductLanguage
    Custom properties for installation are return in SecureCustomProperties Member 
    
    .PARAMETER Path
    Specifies the path to MSI file.
    
    .EXAMPLE
    PS> Get-MSIProperties file.msi
    PS> Get-MSIProperties -Path file.msi
    
    .NOTES
    Inspired from https://winadminnotes.wordpress.com/2010/04/05/accessing-msi-file-as-a-database/
    #>
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Specifies path to MSI file.')][ValidateScript({
        if ($_.EndsWith('.msi')) {
            $true
        } else {
            throw ("{0} must be an '*.msi' file." -f $_)
        }
    })]
    [String] $Path
    )
    
    if (-not (Test-Path -Path $Path)) {
        Write-Error "Path is not valid $MSIFileName"
        return
    }

    $MsiPropertiesObject = [PSCustomObject]@{PSTypeName = "MsiProperties"}

    $WindowsInstaller = New-Object -com WindowsInstaller.Installer
    $Database = $WindowsInstaller.GetType().InvokeMember("OpenDatabase", "InvokeMethod", $Null, $WindowsInstaller, @($Path,0))
    $View = $Database.GetType().InvokeMember("OpenView", "InvokeMethod", $Null, $Database, ("SELECT * FROM Property"))
    $View.GetType().InvokeMember("Execute", "InvokeMethod", $Null, $View, $Null)
    do {
        $Record = $View.GetType().InvokeMember(“Fetch”, "InvokeMethod", $Null, $View, $Null)
        $PropertyName = $Record.GetType().InvokeMember("StringData", "GetProperty", $Null, $Record, 1)
        $PropertyValue = $Record.GetType().InvokeMember("StringData", "GetProperty", $Null, $Record, 2)
        $MsiPropertiesObject | Add-Member -MemberType NoteProperty -Name "$PropertyName" -Value "$PropertyValue"
    } while ($Null -ne $Record)

    $View.GetType().InvokeMember('Close', "InvokeMethod", $Null, $View, $Null)
    return $MsiPropertiesObject
}

$res = Get-MSIProperties -Path "GLPI-Agent-1.11-x64.msi"
$res