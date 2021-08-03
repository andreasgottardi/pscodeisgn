# This creates a new ceritificate in the personal store of the current user
$Certificate = New-SelfSignedCertificate `
	-DnsName cert.goa.systems `
	-Type CodeSigning `
	-CertStoreLocation Cert:\CurrentUser\My

# This generates a random password
$RandomPassword = -Join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 16 | ForEach-Object {[char]$_})

# This converts the plain text password to a secure string
$CertificatePassword = ConvertTo-SecureString `
	-String "$RandomPassword" `
	-Force `
	–AsPlainText

# This exports the certificate into a file called "test.pfx"
Export-PfxCertificate `
	-Cert "Cert:\CurrentUser\My\$($Certificate.Thumbprint)" `
	-Password $CertificatePassword `
	-FilePath ".\test.pfx"

# This removes the certificate form the personal store of the current user. It has to be manually imported into the "Trusted Root Certification Authoroties" store.
$Store = Get-Item -Path "Cert:\CurrentUser\My"
$Store.Open("ReadWrite")
$Store.Remove($Certificate)
$Store.Close()

# This prints out the generated password, which is required later, and the thumbprint, that is required to sign the example script.
Write-Host "Your certificate password is `"$RandomPassword`" and the thumbprint is `"$($Certificate.Thumbprint)`". Please note the password down. It can not be reproduced."

# Import the generated pfx file by double clicking it and importing it into the users "Trusted Root Certification Authoroties" store. The generated password is required for this action.