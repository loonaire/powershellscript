# importe la lib de fenetre
Add-Type -assembly System.Windows.Forms

# crée une instance d'une fenetre
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text = "Bonjour" # nomme la fenetre
#$main_form.Width = 600 # largeur de la fenetre
#$main_form.Height = 800 # hauteur de la fenetre
$main_form.AutoSize = $true # active le redimensionnement?


# crée un bouton
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(10,10)
$Button.Size = New-Object System.Drawing.Size(120,23)
$Button.Text = "Hi there"
$main_form.Controls.Add($Button)


# crée un widget texte "hello"
$Label = New-Object System.Windows.Forms.Label
$Label.Text = "General Kenobi"
$Label.Location  = New-Object System.Drawing.Point(10,40)
$Label.AutoSize = $true
$Label.Visible = $false
$main_form.Controls.Add($Label)

# evenement du click sur le bouton
$Button.Add_Click(
    {
        if($Label.Visible){
            $Label.Visible = $false
        } else {
            $Label.Visible = $true
        }
        
    }
)
















 # charge la fenetre et tout ses widgets
$main_form.ShowDialog()