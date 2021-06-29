# NOTE: le api et le repos sert a telecharger depuis un outil de script.
#$reposlink = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"

# commande compl�te originale:
#Invoke-WebRequest (Invoke-WebRequest https://api.github.com/repos/microsoft/winget-cli/releases/latest | ConvertFrom-Json).assets[2].browser_download_url -Out (("https://github.com/microsoft/winget-cli/releases/download/v1.0.11692/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -split "/")[-1])

# details

# on r�cup�re le fichier json 
$jsonfile=Invoke-WebRequest https://api.github.com/repos/microsoft/winget-cli/releases/latest
#on parse le json pour recuperer l'url qui nous interesse
$downloadLink = ($jsonfile | ConvertFrom-Json).assets[2].browser_download_url

# On r�cup�re le nom du fichier de sortie
$FileName = ($downloadLink -split "/")[-1]

# on t�l�charge le fichier
Invoke-WebRequest $downloadLink -Out $FileName