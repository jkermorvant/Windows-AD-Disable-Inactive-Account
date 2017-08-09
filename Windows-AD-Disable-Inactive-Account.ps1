# Script pour automatiser la désactivation des compes AS dont la dernière connexion > 90 jours
# version 1.0
# Auteur : Jerome Kermorvant

# Forcer le type d'execution
Set-ExecutionPolicy Unrestricted

# Importer le module ActiveDirectory
Import-Module ActiveDirectory
$LockAccount = Search-ADAccount -UserOnly -AccountInactive -TimeSpan 90.00:00:00 -SearchBase "OU=Users,DC=Domain,DC=Local" | Where {$_.enabled}

# Envoi de mail
$smtpServer = "mail.domain.local"
$from = "DisableADAccount <powershell@domain.local>"
$to = "Support <support@domain.local>"
$subject = "[INFO] Comptes AD last logon > 90 jours"
$body = "
<html>
  <head></head>
    <body>
      <p>Bonjour,<br />
         Les comptes suivants sont desactives a cause d'une inactivite de plus de 90 jours<br />:
         $LockedAccount
      </p>
    </body>
</html>"

Send-MailMessage -SmtpServer $smtpserver -from $from -to $to -subject $subject -body $body -bodyasHTML -Priority High