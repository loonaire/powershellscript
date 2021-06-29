# NOTE: le api et le repos sert a telecharger depuis un outil de script.
#$reposlink = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"

# commande complète originale:
#Invoke-WebRequest (Invoke-WebRequest https://api.github.com/repos/microsoft/winget-cli/releases/latest | ConvertFrom-Json).assets[2].browser_download_url -Out (("https://github.com/microsoft/winget-cli/releases/download/v1.0.11692/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -split "/")[-1])

# details

# on récupère le fichier json 
$jsonfile=Invoke-WebRequest https://api.github.com/repos/microsoft/winget-cli/releases/latest
#on parse le json pour recuperer l'url qui nous interesse
$downloadLink = ($jsonfile | ConvertFrom-Json).assets[2].browser_download_url

# On récupère le nom du fichier de sortie
$FileName = ($downloadLink -split "/")[-1]

# on télécharge le fichier
Invoke-WebRequest $downloadLink -Out $FileName