Add-Type -assembly System.Windows.Forms

<#
Docs:
https://gist.github.com/CMCDragonkai/002eff66f47269f4f3da
https://theitbros.com/powershell-gui-for-scripts/
https://github.com/MScholtes/PS2EXE

#>

<#
Commandes pour les ip: (copie du lien github au dessus)
# get all IPs from the WiFi interface
(get-netadapter | get-netipaddress |? InterfaceAlias -eq 'WiFi').ipaddress

# get the IPv4 IP address for the WiFi interface
(get-netadapter | get-netipaddress |? { $_.InterfaceAlias -eq 'WiFi' -and $_.AddressFamily -eq 'IPv4' }).ipaddress

# get all the VirtualBox IPs along with their interface alias as a table
get-netadapter | get-netipaddress |? InterfaceAlias -like 'VirtualBox*' | select InterfaceAlias, IPAddress

# get all the local ethernet connection IPs with their interface alias as a table
get-netadapter | get-netipaddress |? InterfaceAlias -like 'Local Area Connection*' | select InterfaceAlias, IPAddress

# show all IPs to interface alias as a table
get-netadapter | get-netipaddress | select InterfaceAlias, IPAddress

#>



$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='Support'
#$main_form.Width = 600
#$main_form.Height = 400
$main_form.AutoSize = $true
$main_form.FormBorderStyle = "FixedSingle"
$main_form.MaximizeBox = $false

# Récupère les nom de la machine puis le nom de l'utilisateur
$hostLabel = New-Object System.Windows.Forms.Label
$hostLabel.Text = "Nom d'hote: $([System.Environment]::MachineName)"
$hostLabel.AutoSize = $true
$main_form.Controls.Add($hostLabel)

$userLabel = New-Object System.Windows.Forms.Label
$userLabel.Text = "Utilisateur: $($env:username)"
$userLabel.AutoSize = $true
$userLabel.Location = New-Object System.Drawing.Point(0,$hostLabel.Height)
$main_form.Controls.Add($userLabel)

# Ajoute toutes les interfaces
$yLabelPosition = $hostLabel.Height + $userLabel.Height
$interfaceNumber = 1
ForEach($interface in (Get-NetAdapter | Where-Object {$_.Status -eq "Up"})) {

    $interfaceIpAddress = $interface | Get-NetIPAddress -AddressFamily IPv4

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Interface $interfaceNumber $($interfaceIpAddress.InterfaceAlias) $($interfaceIpAddress.IPv4Address)" 
    $label.AutoSize = $true
    $label.TextAlign = "MiddleCenter"
    $label.Location = New-Object System.Drawing.Point(0,$yLabelPosition)
    
    $main_form.Controls.Add($label)

    $yLabelPosition += $label.Height
    $interfaceNumber++

}



















$main_form.ShowDialog()