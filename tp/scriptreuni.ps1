$DC= "local"
$DCname = "alexis"

# Import active directory 
Import-Module activedirectory

#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Création des OU 
New-ADOrganizationalUnit  -Name "TP-ENI" -Path "DC=$DCname,DC=$DC" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit  -Name "Nantes" -Path "OU=TP-ENI,DC=$DCname,DC=$DC" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit  -Name "Rennes" -Path "OU=TP-ENI,DC=$DCname,DC=$DC" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit  -Name "Vertou" -Path "OU=TP-ENI,DC=$DCname,DC=$DC" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit  -Name "Groupe" -Path "OU=TP-ENI,DC=$DCname,DC=$DC" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit  -Name "Informatique" -Path "OU=Nantes,OU=TP-ENI,DC=$DCname,DC=$DC" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit  -Name "Secretaire" -Path "OU=Nantes,OU=TP-ENI,DC=$DCname,DC=$DC" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit  -Name "Production" -Path "OU=Vertou,OU=TP-ENI,DC=$DCname,DC=$DC" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit  -Name "Interimaire" -Path "OU=Vertou,OU=TP-ENI,DC=$DCname,DC=$DC" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit  -Name "Commercial" -Path "OU=Rennes,OU=TP-ENI,DC=$DCname,DC=$DC" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit  -Name "Secretaire" -Path "OU=Rennes,OU=TP-ENI,DC=$DCname,DC=$DC" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit  -Name "Interimaire" -Path "OU=Rennes,OU=TP-ENI,DC=$DCname,DC=$DC" -ProtectedFromAccidentalDeletion $false

#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Import des utilisateurs

#Importer les utilisateur du fichier csv dans la variable $ADUsers 
$ADUsers = Import-csv usereni.csv -Delimiter ";" 

#On va variabiliser chaque colonne du fichier csv 
foreach ($User in $ADUsers)
{
			
	$Username 	= $User.username
	$Password 	= $User.password
	$Firstname 	= $User.firstname
	$Lastname 	= $User.lastname
	$OU 		= $User.ou
    #$Dpt        = $User.Department
    #$Function   = $User.Title
    #$Dscpt      = $User.Description 

	#On vérifier si l'utilisateur existe dans l'AD
	if (Get-ADUser -F {SamAccountName -eq $Username})
	{
		 #Si oui on l'indique
		 Write-Warning "A user account with username $Username already exist in Active Directory."
	}
	else
	{
		#Si l'utilisateur n'existe pas ou va le créer
		
        #On va récupérer les information dans les variables créées ci-dessus
		New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@$DCname.$DC" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -DisplayName "$Lastname, $Firstname" `
            -Path $OU `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
            #-Title $Function
            #-Department $Dpt
            #-Description $Dscpt  
	}
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Création des groupes GG

New-ADGroup -Name "GG-NAN-Informatique" -GroupCategory "Security" -GroupScope "Global" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -PassThru
New-ADGroup -Name "GG-Secrétaire" -GroupCategory "Security" -GroupScope "Global" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -PassThru
New-ADGroup -Name "GG-NAN-Secrétaire" -GroupCategory "Security" -GroupScope "Global" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -PassThru
New-ADGroup -Name "GG-REN-Secrétaire" -GroupCategory "Security" -GroupScope "Global" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -PassThru
New-ADGroup -Name "GG-REN-Commercial" -GroupCategory "Security" -GroupScope "Global" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -PassThru
New-ADGroup -Name "GG-REN-Interim" -GroupCategory "Security" -GroupScope "Global" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -PassThru
New-ADGroup -Name "GG-VER-Production" -GroupCategory "Security" -GroupScope "Global" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -PassThru
New-ADGroup -Name "GG-VER-Interim" -GroupCategory "Security" -GroupScope "Global" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -PassThru
New-ADGroup -Name "GG-NANTES" -GroupCategory "Security" -GroupScope "Global" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -PassThru
New-ADGroup -Name "GG-RENNES" -GroupCategory "Security" -GroupScope "Global" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -PassThru
New-ADGroup -Name "GG-VERTOU" -GroupCategory "Security" -GroupScope "Global" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -PassThru
New-ADGroup -Name "GG-ALL" -GroupCategory "Security" -GroupScope "Global" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -PassThru




#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Ajout des utilisateurs dans les groupes
Add-ADGroupMember -Identity GG-NAN-Informatique -Members sinfo, GG-NAN-Informatique -PassThru
Add-ADGroupMember -Identity GG-Secrétaire -Members ssec, ccamille -PassThru
Add-ADGroupMember -Identity GG-NAN-Secrétaire -Members ssec -PassThru
Add-ADGroupMember -Identity GG-REN-Secrétaire -Members ccamille -PassThru
Add-ADGroupMember -Identity GG-REN-Commercial -Members clcom, cocom -PassThru
Add-ADGroupMember -Identity GG-REN-Interim -Members Icom -PassThru
Add-ADGroupMember -Identity GG-VER-Production -Members pprod, paprod, pauprod -PassThru
Add-ADGroupMember -Identity GG-VER-Interim -Members Iprod -PassThru
Add-ADGroupMember -Identity GG-NANTES -Members GG-NAN-Informatique, GG-NAN-Secrétaire  -PassThru
Add-ADGroupMember -Identity GG-RENNES -Members GG-REN-Secrétaire, GG-REN-Commercial, GG-REN-Interim   -PassThru
Add-ADGroupMember -Identity GG-VERTOU -Members GG-VER-Production, GG-VER-Interim  -PassThru
Add-ADGroupMember -Identity GG-ALL -Members GG-NANTES, GG-RENNES, GG-VERTOU  -PassThru




#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Création des groupes DL 




# A modifier?



New-ADGroup -Name "DL-Production-CT" -GroupCategory "Security" -GroupScope "DomainLocal" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -Description "PartageProduction" -PassThru 
New-ADGroup -Name "DL-Production-M" -GroupCategory "Security" -GroupScope "DomainLocal" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -Description "Partage Production" -PassThru 
New-ADGroup -Name "DL-Production-L" -GroupCategory "Security" -GroupScope "DomainLocal" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -Description "Partage Production" -PassThru 
New-ADGroup -Name "DL-Production-R" -GroupCategory "Security" -GroupScope "DomainLocal" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -Description "Partage Production" -PassThru 
New-ADGroup -Name "DL-Applications-CT" -GroupCategory "Security" -GroupScope "DomainLocal" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -Description "Partage INFRA" -PassThru 
New-ADGroup -Name "DL-Applications-M" -GroupCategory "Security" -GroupScope "DomainLocal" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -Description "Partage INFRA" -PassThru 
New-ADGroup -Name "DL-Applications-L" -GroupCategory "Security" -GroupScope "DomainLocal" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -Description "Partage INFRA" -PassThru 
New-ADGroup -Name "DL-Applications-R" -GroupCategory "Security" -GroupScope "DomainLocal" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -Description "Partage INFRA" -PassThru 
New-ADGroup -Name "DL-Prospect-CT" -GroupCategory "Security" -GroupScope "DomainLocal" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -Description "Partage Prospect" -PassThru 
New-ADGroup -Name "DL-Prospects-M" -GroupCategory "Security" -GroupScope "DomainLocal" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -Description "Partage Prospect" -PassThru 
New-ADGroup -Name "DL-Prospect-L" -GroupCategory "Security" -GroupScope "DomainLocal" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -Description "Partage Prospect" -PassThru 
New-ADGroup -Name "DL-Prospect-R" -GroupCategory "Security" -GroupScope "DomainLocal" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -Description "Partage Prospect" -PassThru
New-ADGroup -Name "DL-Public-CT" -GroupCategory "Security" -GroupScope "DomainLocal" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -Description "Partage Public" -PassThru 
New-ADGroup -Name "DL-Public-M" -GroupCategory "Security" -GroupScope "DomainLocal" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -Description "Partage Public" -PassThru 
New-ADGroup -Name "DL-Public-L" -GroupCategory "Security" -GroupScope "DomainLocal" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -Description "Partage Public" -PassThru 
New-ADGroup -Name "DL-Public-R" -GroupCategory "Security" -GroupScope "DomainLocal" -Path "OU=Groupe,OU=TP-ENI,DC=$DCname,DC=$DC" -Description "Partage Public" -PassThru






#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Ajout des utilisateurs dans les groupes DL
Add-ADGroupMember -Identity DL-Production-CT -Members GG-NAN-Informatique -PassThru 
Add-ADGroupMember -Identity DL-Production-M -Members GG-VERTOU -PassThru 
Add-ADGroupMember -Identity DL-Production-R -Members GG-RENNES, GG-NAN-Secrétaire  -PassThru 
Add-ADGroupMember -Identity DL-Applications-M -Members GG-NAN-Informatique -PassThru 
Add-ADGroupMember -Identity DL-Applications-L -Members GG-VERTOU, GG-RENNES  -PassThru
Add-ADGroupMember -Identity DL-Applications-R -Members GG-Secrétaire  -PassThru
Add-ADGroupMember -Identity DL-Prospects-M -Members GG-REN-Commercial  -PassThru
Add-ADGroupMember -Identity DL-Public-L -Members GG-ALL  -PassThru


#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Ajout des utilisateur dans les groupes GG

<#
Interet de cette partie? semble dupliquée avec 2 parties au dessus, ou alors faux


Add-ADGroupMember -Identity DL-Compta-CT -Members GG-Infra -PassThru 

#>

<#
Add-ADGroupMember -Identity GG-Compta -Members Cmamant, Gtablo, Pmateux, Sarik, Scomte  -PassThru
Add-ADGroupMember -Identity GG-Direction -Members Jrouliere,   -PassThru
Add-ADGroupMember -Identity GG-Assistantes -Members Cmamant,   -PassThru
Add-ADGroupMember -Identity GG-RH -Members Cmamant,   -PassThru
Add-ADGroupMember -Identity GG-Finance -Members Cmamant,   -PassThru
Add-ADGroupMember -Identity GG-Marketing -Members Cmamant,   -PassThru
Add-ADGroupMember -Identity GG-Commercial -Members Cmamant,   -PassThru
Add-ADGroupMember -Identity GG-Achat -Members Cmamant,   -PassThru
Add-ADGroupMember -Identity GG-HPN1 -Members Cmamant,   -PassThru
Add-ADGroupMember -Identity GG-HPN2 -Members Cmamant,   -PassThru
Add-ADGroupMember -Identity GG-DEV -Members Cmamant,   -PassThru
Add-ADGroupMember -Identity GG-SysRes -Members Cmamant,   -PassThru
#>
#------------------------------------------------------------------------------------------------------------------------------------------------------------



