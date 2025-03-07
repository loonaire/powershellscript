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
    
    $Path = (Get-ChildItem -Path "$($Path)").FullName

    if (-not (Test-Path -Path $Path)) {
        Write-Error "Path is not valid $Path"
        return $Null
    }

    #$MsiPropertiesObject = [PSCustomObject]@{PSTypeName = "MsiProperties"}
    $MsiPropertiesObject = New-Object PSObject
    try {
        $WindowsInstaller = New-Object -ComObject WindowsInstaller.Installer
        $Database = $WindowsInstaller.GetType().InvokeMember("OpenDatabase", "InvokeMethod", $Null, $WindowsInstaller, @($Path,0))
        $View = $Database.GetType().InvokeMember("OpenView", "InvokeMethod", $Null, $Database, ("SELECT * FROM Property"))
        $View.GetType().InvokeMember("Execute", "InvokeMethod", $Null, $View, $Null)
        do {
            $Record = $View.GetType().InvokeMember("Fetch", "InvokeMethod", $Null, $View, $Null)
            if ($Null -ne $Record) {
                $PropertyName = $Record.GetType().InvokeMember("StringData", "GetProperty", $Null, $Record, 1)
                $PropertyValue = $Record.GetType().InvokeMember("StringData", "GetProperty", $Null, $Record, 2)
                $MsiPropertiesObject | Add-Member -MemberType NoteProperty -Name "$PropertyName" -Value "$PropertyValue"                
            }
        } while ($Null -ne $Record)

        $View.GetType().InvokeMember('Close', "InvokeMethod", $Null, $View, $Null)        
    } catch {
        #throw "Error accessing file $_"  
        Write-Host $_
        return $Null
    }

    return $MsiPropertiesObject
}

#invoke-WebRequest "https://github.com/glpi-project/glpi-agent/releases/download/1.11/GLPI-Agent-1.11-x64.msi" -OutFile "GLPI-Agent-1.11-x64.msi"

Get-MSIProperties -Path "GLPI-Agent-1.11-x64.msi"