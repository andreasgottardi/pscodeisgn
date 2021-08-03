$Thumbprint = "put here the thumbprint generated in 'CreateCert.ps1'"
$SignCert = (Get-ChildItem -Path "Cert:\CurrentUser\Root\$Thumbprint")
Set-AuthenticodeSignature .\Script.ps1 -Certificate $SignCert