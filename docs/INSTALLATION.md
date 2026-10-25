# Install DataCraft

[User documentation](guides/index.md) · [First catalog walkthrough](guides/UserGuide.md)

Use **Unity 6.0 LTS 6000.0.85f1 or newer**. Keep exactly one DataCraft tool installation in a project. See [Compatibility](guides/Compatibility.md) for tested configurations and optional sample requirements.

## Unity Asset Store purchase

Use the Unity account that owns DataCraft and install the available UPM package through Unity's Asset Store/Package Manager workflow. After resolution and compilation, find **DataCraft** under **Packages** and open **Tools → DataCraft → Open DataCraft**.

Unity manages entitlement and the versions available to your account. If your delivery includes a local `.tgz`, use the tarball steps below. Do not copy a publisher submission folder into a normal consumer project.

## itch.io purchase or local tarball

1. Download the official delivery from your itch.io library/purchase page. Extract the **outer ZIP**.
2. Keep the signed **`.tgz` compressed**, in a stable local folder outside `Assets`.
3. In Unity open **Window → Package Management → Package Manager**.
4. Choose **+ → Install package from tarball** and select the `.tgz`.
5. Wait for dependency resolution and compilation. Unity resolves the declared Newtonsoft JSON, UnityWebRequest and JSON Serialization requirements; you do not need NUnit or the optional demos.
6. Clear Package Manager filters and select the installed **DataCraft** package. Open **Tools → DataCraft → Open DataCraft** and check the installed version/source in **Settings**.

Keep the archive at its referenced location. Moving or deleting a local tarball can break project resolution. A release signature verifies package origin/integrity; it does not indicate Unity review approval. Do not edit or repack a signed archive.

**Expected result:** DataCraft compiles, appears under Packages, and opens Overview with working offline Help. Next: [create a first catalog](guides/UserGuide.md), [save progress](guides/SavesAndFiles.md), or [try a demo](guides/Examples.md).

## Move an older Assets installation to UPM

Back up or commit the complete project first. Close Unity and move `Assets/DataCraft` **and its `.meta` outside the project**. Preserve any game-owned files you placed inside that folder. Reopen Unity and install the package through Package Manager. Keep only one copy of its assemblies and GUIDs.

Retain your templates, instance drafts, mappings, generated output, endpoint assets, generated game code, local saves and original backups. Their [locations and ownership](guides/DataAndBackups.md) are separate from the tool package. After switching, inspect the Console and scene/prefab references.

Old examples may already exist under `Assets/DataCraftSamples`, `Assets/Samples` or an old Assets delivery. Back up modifications before importing another copy; duplicate examples can share GUIDs. No game data or sample is migrated/deleted automatically.

Projects using the prototype ID `com.datacraft-team.datacraft` must remove that package before installing `dev.amedina.datacraft`. This is a package-identity change, not a normal version update.

## Updates, teams and removal

[Settings → Updates follows your purchase store](guides/Updates.md). An older pre-1.2 itch.io installation needs one manual tarball installation to obtain the newer updater. A local tarball alone does not make UPM an online update registry.

For a manual upgrade, back up first, then use **Install package from tarball** with the newer official archive. Confirm the resulting version. Keep project manifest/lock changes together with a reproducible private package setup; each collaborator needs the appropriate license.

Use **Remove** in Package Manager to remove the tool. Project-owned data and copied examples remain separate. Game code that references DataCraft needs the package to compile.

[Installation problems](guides/Troubleshooting.md) · [Optional examples](guides/Examples.md) · [Support](SUPPORT.md)
