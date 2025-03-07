function Get-OnlineLastVersion {
    <#
    .SYNOPSIS
    Check update from only repo
    
    .DESCRIPTION
    Get info from github repo and get last version and download url
 
    .EXAMPLE
    PS> Get-OnlineLastVersion
    
    .NOTES
    #>
    $repoUrl = "https://api.github.com/repos/glpi-project/glpi-agent/releases"
    $jsonVersionAvalaible = ((Invoke-WebRequest "$repoUrl").Content | ConvertFrom-Json) | Where-Object {$_.draft -eq $False -and $_.prerelease -eq $False}
    $jsonAssetData = $jsonVersionAvalaible[0].assets | Where-Object {$_.content_type -like "application/x-msi"}
    return @{
        Version = $jsonVersionAvalaible[0].tag_name
        Filename = $jsonAssetData.name
        DownloadUrl = $jsonAssetData.browser_download_url
    }
}
$values = Get-OnlineLastVersion

Write-Host "$($values.Filename)"

#Invoke-WebRequest $values.DownloadUrl -OutFile "$($values.Filename)"


