<#
.DESCRIPTION
Compare un fichier avec un hash
/!\ powershell 7 est recommandé pour les caractères spéciaux
.SYNOPSIS
Cette commande permet de comparer un fichier avec un hash

.PARAMETER File
Fichier avec le hash à calculer

.PARAMETER Hash
Hash à tester pour le fichier

.PARAMETER HashAlgorithm
Algorithme à utiliser pour le hash, doit être MD5, SHA1, SHA384, SHA256 ou SHA512

#>
# au dessus: help

# Paramètres à prendre:
param([string] $File, [string] $Hash, [string] $HashAlgorithm)

#script qui compare le hash d'un fichier avec un fichier donné


# Tableau qui contient les algorithmes disponibles:
$ListHashAlgorithm = @("SHA1" , "SHA256" , "SHA384" , "SHA512" , "MD5")

if (-not $File) {
    # Tant que le fichier saisi par l'utlisateur n'existe pas, on lui redemande un fichier
    do {
        try{
        $File = Read-Host "Veuillez indiquer le nom du fichier dont il faut calculer le hash"
        Get-Item $File -ErrorAction Stop | Out-Null
        $isExist = $true
        } catch {
            $isExist = $false
        }        
    } until ( $isExist )
} 

if (-not $Hash){
    # Valeur que doit faire le fichier
    $Hash = Read-Host "Veuillez indiquer le hash à comparer"
}

if ($ListHashAlgorithm.Contains( "$HashAlgorithm.ToUpper()" ) ){
    $HashAlgorithm = $null
}
if ( (-not $HashAlgorithm) ){
    # Algorithme utiliser pour le hash
    do {
        $HashAlgorithm = Read-Host "Veuillez indiquer l'algorithme à utiliser pour le hash du fichier"
    } until ($ListHashAlgorithm.Contains($HashAlgorithm.ToUpper() ) )
    
}

# calcul le hash du fichier
$FileHash = (Get-FileHash -Path $File -Algorithm $HashAlgorithm).Hash

# affiche les Hash
Write-Host "Hash du fichier: $Filehash"
Write-Host "Hash souhaité: $Hash"

#Détermine si les hashs sont identiques
if ( $FileHash -like $Hash){
    Write-Host "Les hashs sont identiques!" -ForegroundColor Green
} else {
    Write-Host "Les hashs ne sont pas identiques!" -ForegroundColor Red
}








