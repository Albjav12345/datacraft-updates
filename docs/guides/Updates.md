# Updates through your purchase store

[Documentation home](index.md) · [Installation](../INSTALLATION.md) · [Troubleshooting](Troubleshooting.md)

Open **Settings → Updates**. Your retail edition follows the store it came from; there is no customer store selector. Store availability can differ. Buying from one store does not automatically grant a second store entitlement.

## Unity Asset Store edition

1. Choose **Check for updates** and review **Release history** in DataCraft.
2. Open DataCraft in **Package Manager** using the provided action.
3. Use the Unity account that owns the asset and Unity's available version/install workflow.
4. Wait for compilation and confirm the installed version in Settings.

No itch.io sign-in is involved. A release awaiting Asset Store approval is not an available Unity download. Package Manager does not silently update a local tarball merely because its name contains a newer version.

## itch.io edition

1. If upgrading from 1.1.1 or earlier, [install the new official tarball manually](../INSTALLATION.md) once to obtain the newer updater.
2. In **Settings → Updates**, choose **Connect itch.io account**. Authorize the application in your system browser; your password stays there. A one-time-code option is available when loopback sign-in cannot complete.
3. Confirm **Official DataCraft download access verified**. Official purchases, gifts, claimed bundles and publisher-authorized download access are checked by itch.io. Connection alone is not ownership.
4. Review an available compatible release and choose **Update from itch.io**. DataCraft rechecks access, downloads the authorized archive, verifies signed release hashes/package identity and installs it through UPM.
5. Let Unity finish compilation/reload, then check the version and result. Installation is explicit and must run outside Play/import transitions.

If you claim a gift/bundle after connecting, choose **Verify access**. Claim the individual product from your bundle library if prompted. **No official access** means check the owning account/claim state, not reinstall the asset. An author account does not inherently have buyer access.

Remembered sessions use Windows Credential Manager/macOS Keychain where supported; otherwise sign-in lasts for the Editor session. Tokens are kept outside the project. Disconnect forgets the local session; revoking the app on itch.io can affect its other sessions.

## Notices and privacy

Manual checks read public publisher-signed release information. Optional **Check automatically once a day** is off by default and runs while the Editor is open; it does not silently install code. **Remind tomorrow** postpones the same notice for 24 hours.

Release history explains changes, feature/fix/security category, normal/recommended/critical importance, affected versions and minimum Unity version. A verification failure or offline/cached result remains labelled; it is not a fresh successful check. Old signed metadata cannot establish current availability indefinitely: check the issue date/store if warned it is stale.

Public metadata checks send no project data, saves, credentials or project paths. itch.io account checks go to itch.io; authorized delivery requests do not receive the OAuth bearer token. Signatures authenticate release/package information; they do not encrypt game JSON or protect a compromised local machine.

## Restore or recover an itch.io package

Verified tarballs and a prior package remain in **`Packages/DataCraft~/Archives`**, referenced relatively for project portability. Keep this folder with the private project and share commercial code only with appropriately licensed collaborators. Archives are not automatically pruned.

Use **Restore previous package** for the retained tool version. If compilation prevents DataCraft opening, choose the retained `.tgz` manually in Package Manager. Manifest/lock backups and installation observations live in `Library/DataCraftUpdates`; a reload observes the pending outcome rather than silently executing another install.

Restoring a package does not roll back game-owned schema/data edits. Back up the complete project before an update and keep those changes compatible with the restored code. See [Data locations and backups](DataAndBackups.md).
