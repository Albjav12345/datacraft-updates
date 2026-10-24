param([Parameter(Mandatory=$true)][string]$Path,[switch]$Restore)
$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Security.Cryptography.ProtectedData
$destination=[IO.Path]::GetFullPath($Path)
if ($destination.StartsWith($PSScriptRoot.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)) { throw 'Store signing-key backups outside the public repository.' }
$keyRoot=Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'DataCraftPublisher\Keys'
$keyPath=Join-Path $keyRoot 'updates-20261024.dpapi'
$password=Read-Host 'Password for the encrypted signing-key backup (keep it separately)' -AsSecureString
$credential=[Net.NetworkCredential]::new('', $password)
$phrase=$credential.Password
if ($phrase.Length -lt 16) { throw 'Use a backup password with at least 16 characters.' }
$rsa=[Security.Cryptography.RSA]::Create();$clear=$null
try {
    if ($Restore) {
        if (Test-Path -LiteralPath $keyPath) { throw 'A protected signing key already exists; no replacement performed.' }
        $read=0;$rsa.ImportEncryptedPkcs8PrivateKey($phrase,[IO.File]::ReadAllBytes($destination),[ref]$read)
        $expected=Get-Content -LiteralPath (Join-Path $PSScriptRoot 'publisher-public-key.json') -Raw | ConvertFrom-Json
        if ([Convert]::ToBase64String($rsa.ExportParameters($false).Modulus) -ne $expected.modulus) { throw 'Backup does not match the publisher trust key.' }
        $clear=[Text.Encoding]::UTF8.GetBytes($rsa.ToXmlString($true))
        [IO.Directory]::CreateDirectory($keyRoot) | Out-Null
        [IO.File]::WriteAllBytes($keyPath,[Security.Cryptography.ProtectedData]::Protect($clear,$null,[Security.Cryptography.DataProtectionScope]::CurrentUser))
        Write-Output 'Matching publisher key restored into CurrentUser DPAPI protection.'
    } else {
        if (Test-Path -LiteralPath $destination) { throw 'Backup destination exists; no overwrite performed.' }
        $clear=[Security.Cryptography.ProtectedData]::Unprotect([IO.File]::ReadAllBytes($keyPath),$null,[Security.Cryptography.DataProtectionScope]::CurrentUser)
        $rsa.FromXmlString([Text.Encoding]::UTF8.GetString($clear))
        $parameters=[Security.Cryptography.PbeParameters]::new([Security.Cryptography.PbeEncryptionAlgorithm]::Aes256Cbc,[Security.Cryptography.HashAlgorithmName]::SHA256,200000)
        [IO.File]::WriteAllBytes($destination,$rsa.ExportEncryptedPkcs8PrivateKey($phrase,$parameters))
        Write-Output 'Encrypted PKCS#8 backup created. Keep its password separately; do not publish this file.'
    }
} finally { if ($clear) {[Array]::Clear($clear,0,$clear.Length)};$rsa.Dispose();$phrase=$null;$credential=$null;$password.Dispose() }
