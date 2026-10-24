# DataCraft public update channel

This repository contains public release metadata and publisher tooling only. It contains no commercial DataCraft source, package archive, customer project or game save.

## Client behavior

DataCraft 1.2.0 reads `updates-v2.json` over HTTPS, verifies its RSA-3072/SHA-256 publisher signature against a public key compiled into the Editor, bounds the document and rejects invalid JSON/contracts and sequence rollback. Release text is rendered as plain text inside the Editor. Store URLs are fixed in the client, not commands or download addresses supplied by metadata.

Retail packages carry an explicit **Unity Asset Store** or **itch.io** edition marker and present separate update actions. Only development previews show a QA channel selector, which never grants access to downloads. Optional automatic checks are off by default, run at most daily while Unity is open, and can be disabled. Failed/offline checks are distinguished from saved verified information. Public notice checks upload no game/project data or account tokens. Asset Store editions use Unity Package Manager and Unity entitlement. itch.io editions sign in through the official OAuth browser flow, verify official purchase/gift/bundle access and may download/install a verified archive after the user chooses Update. Passwords stay in the browser; no publisher API key is distributed. Download authorization is not DRM against copying local source.

Each release explicitly declares features/fixes/security, normal/recommended/critical importance, affected `[affectsFrom, affectsBefore)` versions, a full minimum Unity version and separate store availability. A pending Unity review is **not** an available Asset Store download. Critical fixes pending in one store remain visible as pending, without pretending an update can be downloaded there. A later compatible release carries earlier critical notices that affect the installed version.

`latest.json` preserves the older unsigned v1 client contract. It announces releases available in **itch.io**, the distribution used by the pre-1.2 public clients. The first public Asset Store delivery uses the v2 client. Legacy clients cannot identify their store or read signed importance/history. They must install 1.2.0 or newer to acquire the new UI and trust checks.

## Publish a future release

1. Publish the package in a store and verify its download/version there. Do not mark an upload, candidate or review as released.
2. Edit `releases.json`. Add a stable version with concise notes, full Unity minimum, explicit importance/affected range, and truthful `stores.assetStore` / `stores.itch` booleans. At least one store must actually offer it. Keep old security/fix history needed by supported installations. Use an empty mitigation string when no workaround is needed.
3. On the publisher's Windows account, run PowerShell 7 from this checked-out repository:

   `pwsh -File ./Publish-Updates.ps1 -ConfirmStoreAvailability -Publish`

The command validates the source, increments the channel sequence, signs the exact UTF-8 payload, verifies locally, commits only an allowlist of metadata files, and pushes to the fixed `Albjav12345/datacraft-updates` remote. Git authenticates with your normal publisher credentials. Python 3, PowerShell 7 and Git are publisher tools; customers need none of them.

When the other store approves/offers the same version, change just its availability flag and publish metadata again. Updating notes or store flags does **not** require repacking the client. The GitHub workflow independently validates the schema and signature with OpenSSL.

## Signing-key custody and limits

The private key is **not** in this repository or in commercial packages. On the original publisher Windows account it is protected with CurrentUser DPAPI under `%LOCALAPPDATA%/DataCraftPublisher/Keys/updates-20261024.dpapi`. Create an encrypted portable backup with `pwsh -File ./Backup-SigningKey.ps1 -Path /path/outside/this/repository/updates-encrypted.pkcs8`. It prompts locally for a password of at least 16 characters and writes AES-256 encrypted PKCS#8; keep its password separately. On a new publisher Windows account, restore the matching key with the same command plus `-Restore`. Nothing exports or uploads an unencrypted key. Copying that encrypted file alone to another machine/account does not make it decryptable. Never commit private keys, credentials or an exported unencrypted key. Losing the signing key requires a new client release/trust-key migration; replacing the public key here cannot change installed clients.

Signatures authenticate metadata; they do not encrypt game JSON or protect a compromised local Editor/publisher account. Persisted sequence/hash checks prevent rollback after a client has seen newer signed metadata. A first contact cannot establish historical freshness from a static document alone. Offline/disabled checks cannot provide immediate alerts; the Editor shows check/publication dates. Metadata older than 90 days never claims a fresh current version: verify your store and have the publisher refresh the signed channel with the same publishing command, even when no new package is needed. Normal TLS connection metadata is visible to the hosting provider; no project paths, saves or authentication headers are sent.

The starting history records **1.1.1 in itch.io**, confirmed by the publisher: https://albjav12345.itch.io/datacraft/devlog/1726077/datacraft-111-unity-6-lts-full-compatibility . Asset Store remains unavailable until actual approval/public availability. The prepared 1.2.0 client is not announced as published by this setup.

## Authenticated itch.io artifacts

`artifacts-v1.json` is a separate publisher-signed **DataCraft.UpdateArtifacts / version 1** envelope. Its public payload contains only package/version, exact itch archive filename, byte length, outer ZIP SHA-256, inner signed tarball filename and SHA-256. It contains no commercial bytes, user token or download URL. An empty list means no in-Editor artifact has been announced yet. Normal version/severity notices remain in updates-v2.json.

After uploading the exact signed ZIP and confirming it is available to buyers, update releases.json and run:

```powershell
pwsh -File ./Publish-Updates.ps1 -ConfirmStoreAvailability -ItchArchive "C:/Releases/DataCraft-1.2.0-itch-signed.zip" -Publish
```

Use the exact uploaded filename. The local path is never copied into metadata. The tool verifies the retail edition and signed-tarball presence, calculates both hashes, binds the artifact to a release actually marked available in itch.io, signs/verifies both documents and publishes only the allowlist. For note/store-flag changes or quarterly freshness renewal without a new archive, omit -ItchArchive. Never announce an upload/review as released.

The new account/download client is in preparation and is not announced as an available 1.2.0 release. Official gifts and bundles count as access. Bundle owners may need to claim the individual product in their itch.io library first. Selecting a store or possessing a package copy never authenticates a download. The client does not lock ordinary authoring/runtime use behind a login. OAuth account credentials go to itch.io only; CDN downloads never receive the bearer token.

Verified package tarballs and a previous version are retained under the private consuming project's Packages/DataCraft~/Archives, referenced relatively for portability and Library cleanup. Tokens are held separately in OS credential storage where supported, otherwise only in the current Editor session. Installation records/backups in Library enable observation/recovery after code reload; the updater never silently rewrites authoring data or saves.
