param([switch]$Publish,[switch]$ConfirmStoreAvailability,[string]$ItchArchive)
$ErrorActionPreference='Stop'
if (-not $ConfirmStoreAvailability) { throw 'Verify actual store downloads before announcing a release. Upload/review is not publication.' }
$metadataFiles=@('README.md','releases.json','updates-v2.json','latest.json','artifacts.json','artifacts-v1.json','prepare-artifacts.py','publisher-public-key.json','publisher-public-key.pem','Publish-Updates.ps1','Backup-SigningKey.ps1','build-channel.py','.gitignore','.github/workflows/validate.yml')

function Assert-PublishCheckout([string]$RepositoryRoot) {
    $remote=& git -C $RepositoryRoot remote get-url origin
    if ($LASTEXITCODE -ne 0 -or $remote.Trim() -ne 'https://github.com/Albjav12345/datacraft-updates.git') { throw 'Unexpected metadata repository remote.' }
    $safeTracked=@($metadataFiles)+@('PUBLISHING.md')
    $inventoryPath=Join-Path $RepositoryRoot 'docs/.datacraft-docs-inventory.json'
    if(Test-Path -LiteralPath $inventoryPath) {
        $inventory=Get-Content -LiteralPath $inventoryPath -Raw | ConvertFrom-Json
        $safeTracked+=@('docs/.datacraft-docs-inventory.json')
        foreach($property in $inventory.PSObject.Properties) {
            $name=$property.Name
            if($name -match '[\\:\x00-\x1f]' -or $name.StartsWith('/') -or @($name.Split('/') | Where-Object {$_ -in @('','.','..')}).Count -or [IO.Path]::GetExtension($name) -notin @('.md','.png','.jpg','.txt') -or $property.Value -notmatch '^[a-f0-9]{64}$') { throw 'Unsafe documentation inventory; nothing pushed.' }
            $safeTracked+='docs/'+$name
        }
    }
    $tracked=@(& git -C $RepositoryRoot ls-files)
    if($LASTEXITCODE -ne 0 -or @($tracked | Where-Object {$_ -notin $safeTracked}).Count) { throw 'Unexpected tracked files; nothing pushed.' }
    $staged=@(& git -C $RepositoryRoot diff --cached --name-only)
    if($LASTEXITCODE -ne 0 -or @($staged | Where-Object {$_ -notin $metadataFiles}).Count) { throw 'Unrelated staged changes; publish metadata separately.' }
}
if($Publish) { Assert-PublishCheckout $PSScriptRoot }

Add-Type -AssemblyName System.Security.Cryptography.ProtectedData
$keyPath=Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'DataCraftPublisher\Keys\updates-20261024.dpapi'
if (-not (Test-Path -LiteralPath $keyPath)) { throw 'Publisher signing key missing; it never belongs in this repository or commercial packages.' }
$python=Get-Command py -ErrorAction SilentlyContinue
if ($python) { $pythonPath=$python.Source;$prefix=@('-3') } else { $pythonPath=(Get-Command python -ErrorAction Stop).Source;$prefix=@() }
if ($ItchArchive) {
    & $pythonPath @prefix (Join-Path $PSScriptRoot 'prepare-artifacts.py') --add $ItchArchive
    if ($LASTEXITCODE -ne 0) { throw 'Itch archive validation failed. No signed announcement was changed.' }
}
function Next-Sequence([string]$name) {
    $path=Join-Path $PSScriptRoot $name
    if (-not (Test-Path -LiteralPath $path)) { return 1L }
    $old=Get-Content -LiteralPath $path -Raw | ConvertFrom-Json
    $payload=[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($old.payload)) | ConvertFrom-Json
    return [long]$payload.sequence+1
}
$temporary=Join-Path ([IO.Path]::GetTempPath()) ('datacraft-public-payload-'+[Guid]::NewGuid().ToString('N'))
$clear=$null;$rsa=[Security.Cryptography.RSA]::Create();$staged=@()
try {
    & $pythonPath @prefix (Join-Path $PSScriptRoot 'build-channel.py') --build $temporary --sequence (Next-Sequence 'updates-v2.json')
    if ($LASTEXITCODE -ne 0) { throw 'Release validation failed.' }
    & $pythonPath @prefix (Join-Path $PSScriptRoot 'prepare-artifacts.py') --build ($temporary+'.artifacts') --sequence (Next-Sequence 'artifacts-v1.json')
    if ($LASTEXITCODE -ne 0) { throw 'Artifact source validation failed.' }
    $clear=[Security.Cryptography.ProtectedData]::Unprotect([IO.File]::ReadAllBytes($keyPath),$null,[Security.Cryptography.DataProtectionScope]::CurrentUser)
    $rsa.FromXmlString([Text.Encoding]::UTF8.GetString($clear))
    $public=Get-Content -LiteralPath (Join-Path $PSScriptRoot 'publisher-public-key.json') -Raw | ConvertFrom-Json
    if ([Convert]::ToBase64String($rsa.ExportParameters($false).Modulus) -ne $public.modulus) { throw 'Signing key differs from installed client trust anchor.' }
    foreach($entry in @(@{source=$temporary;target='updates-v2.json';marker='DataCraft.Updates';version=2},@{source=$temporary+'.artifacts';target='artifacts-v1.json';marker='DataCraft.UpdateArtifacts';version=1})) {
        $bytes=[IO.File]::ReadAllBytes($entry.source)
        $signature=$rsa.SignData($bytes,[Security.Cryptography.HashAlgorithmName]::SHA256,[Security.Cryptography.RSASignaturePadding]::Pkcs1)
        if (-not $rsa.VerifyData($bytes,$signature,[Security.Cryptography.HashAlgorithmName]::SHA256,[Security.Cryptography.RSASignaturePadding]::Pkcs1)) { throw 'Local signature verification failed.' }
        $envelope=[ordered]@{format=$entry.marker;formatVersion=$entry.version;keyId=$public.keyId;payload=[Convert]::ToBase64String($bytes);signature=[Convert]::ToBase64String($signature)} | ConvertTo-Json -Compress
        $target=Join-Path $PSScriptRoot $entry.target;$tempTarget=$target+'.tmp'
        [IO.File]::WriteAllText($tempTarget,$envelope+"`n",[Text.UTF8Encoding]::new($false));$staged+=@{temp=$tempTarget;target=$target}
    }
    foreach($entry in $staged) { Move-Item -LiteralPath $entry.temp -Destination $entry.target -Force }
    Move-Item -LiteralPath ($temporary+'.legacy.json') -Destination (Join-Path $PSScriptRoot 'latest.json') -Force
} finally {
    if ($clear) { [Array]::Clear($clear,0,$clear.Length) };$rsa.Dispose()
    foreach($p in @($temporary,($temporary+'.legacy.json'),($temporary+'.artifacts'))+@($staged | ForEach-Object {$_.temp})) { if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Force } }
}
& $pythonPath @prefix (Join-Path $PSScriptRoot 'build-channel.py') --verify
if ($LASTEXITCODE -ne 0) { throw 'Independent notice signature verification failed. Nothing pushed.' }
& $pythonPath @prefix (Join-Path $PSScriptRoot 'prepare-artifacts.py') --verify
if ($LASTEXITCODE -ne 0) { throw 'Independent artifact signature verification failed. Nothing pushed.' }
Write-Output 'Signed public metadata prepared. No commercial content, customer data or private key is included.'
if ($Publish) {
    $allowed=$metadataFiles
    & git -C $PSScriptRoot add -- @allowed
    if ($LASTEXITCODE -ne 0) { throw 'Could not stage metadata.' }
    & git -C $PSScriptRoot commit -m 'Publish DataCraft signed notices and authorized artifact metadata'
    if ($LASTEXITCODE -ne 0) { throw 'Could not commit metadata.' }
    & git -C $PSScriptRoot push origin HEAD:main
    if ($LASTEXITCODE -ne 0) { throw 'Push failed. The signed local files are retained.' }
}
