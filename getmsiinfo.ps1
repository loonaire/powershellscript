<#
LIENS ORIGINAUX SOURCES

https://stackoverflow.com/questions/72047380/powershell-get-properties-of-msi

https://itpro-tips.com/recuperer-informations-fichier-msi-avec-powershell/
https://stackoverflow.com/questions/8743122/how-do-i-find-the-msi-product-version-number-using-powershell
https://winadminnotes.wordpress.com/2010/04/05/accessing-msi-file-as-a-database/
https://gist.github.com/jstangroome/913062
https://stackoverflow.com/questions/65150110/powershell-how-to-use-windowsinstaller-installer-to-insert-a-property-value


#>




$msifile = 'GLPI-Agent-1.11-x64.msi'

function Which-MSIVersion {
    <#
    .SYNOPSIS
    Function to Check Version of an MSI file.
    
    .DESCRIPTION
    Function to Check Version of an MSI file for comparision in other scripts.
    Accepts path to single file.
    
    .PARAMETER msifile
    Specifies the path to MSI file.
    
    .EXAMPLE
    PS> Which-MSIVersion -msifile $msifile
    68.213.49193
    
    .NOTES
    General notes
    #>
    param (
        [Parameter(Mandatory = $true, HelpMessage = 'Specifies path to MSI file.')][ValidateScript({
        if ($_.EndsWith('.msi')) {
            $true
        } else {
            throw ("{0} must be an '*.msi' file." -f $_)
        }
    })]
    [String[]] $msifile
    )

    $invokemethod = 'InvokeMethod'
    try {

        #calling com object
        $FullPath = (Resolve-Path -Path $msifile).Path
        $windowsInstaller = New-Object -ComObject WindowsInstaller.Installer

        ## opening database from file
        $database = $windowsInstaller.GetType().InvokeMember(
            'OpenDatabase', $invokemethod, $Null, 
            $windowsInstaller, @($FullPath, 0)
        )

        ## select productversion from database
        $q = "SELECT Value FROM Property WHERE Property = 'ProductVersion'"
        $View = $database.GetType().InvokeMember(
            'OpenView', $invokemethod, $Null, $database, ($q)
        )

        ##execute
        $View.GetType().InvokeMember('Execute', $invokemethod, $Null, $View, $Null)

        ## fetch
        $record = $View.GetType().InvokeMember(
            'Fetch', $invokemethod, $Null, $View, $Null
        )

        ## write to variable
        $productVersion = $record.GetType().InvokeMember(
            'StringData', 'GetProperty', $Null, $record, 1
        )

        $View.GetType().InvokeMember('Close', $invokemethod, $Null, $View, $Null)


        ## return productversion
        return $productVersion

    }
    catch {
        throw 'Failed to get MSI file version the error was: {0}.' -f $_
    }
}

Which-MSIVersion -msifile $msifile
