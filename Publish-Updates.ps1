param([switch]$Publish,[switch]$ConfirmStoreAvailability)
$ErrorActionPreference='Stop'
if (-not $ConfirmStoreAvailability) { throw 'Check each store download, then run with -ConfirmStoreAvailability. Do not announce a candidate, an upload or a pending Unity review.' }
Add-Type -AssemblyName System.Security.Cryptography.ProtectedData
$keyPath=Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'DataCraftPublisher\Keys\updates-20261024.dpapi'
if (-not (Test-Path -LiteralPath $keyPath)) { throw 'Publisher signing key is missing. It is not included in the public repository or commercial packages.' }
$python=Get-Command py -ErrorAction SilentlyContinue
if ($python) { $pythonPath=$python.Source;$prefix=@('-3') } else { $pythonPath=(Get-Command python -ErrorAction Stop).Source;$prefix=@() }
$sequence=1
$previous=Join-Path $PSScriptRoot 'updates-v2.json'
if (Test-Path -LiteralPath $previous) {
    $old=Get-Content -LiteralPath $previous -Raw | ConvertFrom-Json
    $payload=[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($old.payload)) | ConvertFrom-Json
    $sequence=[long]$payload.sequence+1
}
$temporary=Join-Path ([IO.Path]::GetTempPath()) ('datacraft-public-payload-'+[Guid]::NewGuid().ToString('N'))
$clear=$null;$rsa=[Security.Cryptography.RSA]::Create()
try {
    & $pythonPath @prefix (Join-Path $PSScriptRoot 'build-channel.py') --build $temporary --sequence $sequence
    if ($LASTEXITCODE -ne 0) { throw 'Release validation failed.' }
    $clear=[Security.Cryptography.ProtectedData]::Unprotect([IO.File]::ReadAllBytes($keyPath),$null,[Security.Cryptography.DataProtectionScope]::CurrentUser)
    $rsa.FromXmlString([Text.Encoding]::UTF8.GetString($clear))
    $expected=Get-Content -LiteralPath (Join-Path $PSScriptRoot 'publisher-public-key.json') -Raw | ConvertFrom-Json
    if ([Convert]::ToBase64String($rsa.ExportParameters($false).Modulus) -ne $expected.modulus) { throw 'Signing key does not match the public trust anchor.' }
    $bytes=[IO.File]::ReadAllBytes($temporary)
    $signature=$rsa.SignData($bytes,[Security.Cryptography.HashAlgorithmName]::SHA256,[Security.Cryptography.RSASignaturePadding]::Pkcs1)
    if (-not $rsa.VerifyData($bytes,$signature,[Security.Cryptography.HashAlgorithmName]::SHA256,[Security.Cryptography.RSASignaturePadding]::Pkcs1)) { throw 'Local signature verification failed.' }
    $envelope=[ordered]@{format='DataCraft.Updates';formatVersion=2;keyId=$expected.keyId;payload=[Convert]::ToBase64String($bytes);signature=[Convert]::ToBase64String($signature)} | ConvertTo-Json -Compress
    $target=Join-Path $PSScriptRoot 'updates-v2.json';$tempTarget=$target+'.tmp'
    [IO.File]::WriteAllText($tempTarget,$envelope+"`n",[Text.UTF8Encoding]::new($false))
    Move-Item -LiteralPath $tempTarget -Destination $target -Force
    Move-Item -LiteralPath ($temporary+'.legacy.json') -Destination (Join-Path $PSScriptRoot 'latest.json') -Force
    $pem="-----BEGIN PUBLIC KEY-----`n"+[Convert]::ToBase64String($rsa.ExportSubjectPublicKeyInfo(),[Base64FormattingOptions]::InsertLineBreaks)+"`n-----END PUBLIC KEY-----`n"
    [IO.File]::WriteAllText((Join-Path $PSScriptRoot 'publisher-public-key.pem'),$pem,[Text.UTF8Encoding]::new($false))
} finally { if ($clear) { [Array]::Clear($clear,0,$clear.Length) };$rsa.Dispose();foreach($p in @($temporary,($temporary+'.legacy.json'))){if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Force }} }
Write-Output "Signed metadata sequence $sequence prepared. No commercial package or game data is included."
if ($Publish) {
    $allowed=@('README.md','releases.json','updates-v2.json','latest.json','publisher-public-key.json','publisher-public-key.pem','Publish-Updates.ps1','Backup-SigningKey.ps1','build-channel.py','.gitignore','.github/workflows/validate.yml')
    $remote=& git -C $PSScriptRoot remote get-url origin
    if ($LASTEXITCODE -ne 0 -or $remote.Trim() -ne 'https://github.com/Albjav12345/datacraft-updates.git') { throw 'Unexpected publisher repository remote.' }
    $tracked=@(& git -C $PSScriptRoot ls-files)
    if (@($tracked | Where-Object {$_ -notin $allowed}).Count) { throw 'Unexpected files in metadata repository; nothing pushed.' }
    & git -C $PSScriptRoot add -- @allowed
    if ($LASTEXITCODE -ne 0) { throw 'Could not stage metadata.' }
    & git -C $PSScriptRoot commit -m "Publish DataCraft update metadata sequence $sequence"
    if ($LASTEXITCODE -ne 0) { throw 'Could not commit metadata.' }
    & git -C $PSScriptRoot push origin HEAD:main
    if ($LASTEXITCODE -ne 0) { throw 'Could not publish metadata. The signed local files remain available.' }
}
