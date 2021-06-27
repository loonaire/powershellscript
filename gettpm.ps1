
# import de la lib de gui
Add-type -assembly System.Windows.Forms 



#---------- Recuperation des valeurs -------------------

# on recupere l'info du TPM:
# recupere l'etat du tpm
$command = Get-Tpm | select TpmPresent, TpmReady, TpmEnabled, TpmActivated

# recupere la version du tpm:


if ($command.TpmPresent){
    # si le tpm est présent on verifie la version
    $checkTpmVersion = Get-TpmEndorsementKeyInfo

}
   
#-----------------------------------------------------------------
# initialisation du gui
$gui = New-Object System.Windows.Forms.Form
$gui.Text = "Get-Tpm"
$gui.AutoSize = $true

# Premiere ligne de texte
$Label1 = New-Object System.Windows.Forms.Label
$Label1.Text = "Etat du TPM:"
$Label1.Location = New-Object System.Drawing.Size(10,10)
$Label1.Size = New-Object System.Drawing.Size(200)

# Deuxieme ligne de texte, qui dit si le TPM est active
$LabelTpmPresent = New-Object System.Windows.Forms.Label
$LabelTpmPresent.Text = "Tpm Present: " + $command.TpmPresent
$LabelTpmPresent.Location = New-Object System.Drawing.Point(10,40)

$LabelTpmReady = New-Object System.Windows.Forms.Label
$LabelTpmReady.Text = "Tpm Ready: " + $command.TpmReady
$LabelTpmReady.Location = New-Object System.Drawing.Point(10,70)

$LabelTpmEnabled = New-Object System.Windows.Forms.Label
$LabelTpmEnabled.Text = "Tpm enable: " + $command.TpmEnabled
$LabelTpmEnabled.Location = New-Object System.Drawing.Point(10,100)

$LabelTpmActivated = New-Object System.Windows.Forms.Label
$LabelTpmActivated.Text = "Tpm activate: " + $command.TpmActivated
$LabelTpmActivated.Location = New-Object System.Drawing.Point(10,130)


if($command.TpmPresent){
    $TPMVersion = (($checkTpmVersion.AdditionalCertificates).Subject).Substring(14,8)
    
} else {
    $TPMVersion = ""
}

$LabelTpmVersion = New-Object System.Windows.Forms.Label
$LabelTpmVersion.Text = "Version du TPM: " + $TPMVersion
$LabelTpmVersion.Location = New-Object System.Drawing.Point(10,160)



# packing des label dans le gui
$gui.Controls.Add($Label1)
$gui.Controls.Add($LabelTpmPresent)
$gui.Controls.Add($LabelTpmReady)
$gui.Controls.Add($LabelTpmEnabled)
$gui.Controls.Add($LabelTpmActivated)
$gui.Controls.Add($LabelTpmVersion)


# affiche la fenetre:
$gui.ShowDialog()


# Pas mal d'info ici: https://blog.netwrix.com/2018/10/04/powershell-variables-and-arrays/