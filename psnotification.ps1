
$passwordExpirationDate = $(Get-Date).ToString("dd/MM/yyyy")

$xml =[System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]::Default.GetBytes( @"
<toast scenario="reminder" duration="long">
  <visual>
    <binding template="ToastGeneric">
      <text>Mot de passe</text>
      <text>Votre mot de passer expire le $passwordExpirationDate</text>
    </binding>
  </visual>
</toast>
"@))

Write-Host $xml

$XmlDocument = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]::New()

$XmlDocument.LoadXml($xml)

$AppId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]::CreateToastNotifier($AppId).Show($XmlDocument)
