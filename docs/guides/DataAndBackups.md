# Data locations and backups

[Documentation home](index.md) · [Local saves](SavesAndFiles.md) · [Updates](Updates.md)

The tool package, Editor source data, generated gameplay data and player saves have different lifetimes. **Settings** reports actual locations for the current project/environment. Output/example paths can depend on the destination you chose.

| Content | Normal location | Keep/recover |
| --- | --- | --- |
| Template definitions | `ProjectSettings/DataCraftTemplates.asset` | Version/control or back up as project authoring |
| Instance drafts | `ProjectSettings/DataCraftInstances.json` | Keep with the matching templates |
| Saved mappings | Project-local mapping configuration shown in Designer | Keep with authoring; it is not source rows or credentials |
| Generated catalog/shards and optional C# IDs | Your chosen game-owned location under `Assets` | Preserve GUIDs/references; refresh explicitly in Project Data |
| API endpoints and generated game code | Your chosen game-owned assets/scripts | Back up and review as game code |
| Runtime/player saves | `Application.persistentDataPath/DataCraft` | Back up independently; Editor/device/Player paths may differ |
| Original Files edit backups | `.backups` under the local save folder | Exact pre-edit bytes; no automatic pruning/restore |
| Schema migration backups | `ProjectSettings/DataCraftMigrationBackups` | Preserve before manual recovery |
| Unresolved ordinary template edit | `Library/DataCraft/TemplateEditRecovery.json` | Resolve/export before deleting Library |
| Verified itch.io tool archives | `Packages/DataCraft~/Archives` | Retain installed/prior archives and relative UPM references |
| Update journal and manifest/lock backups | `Library/DataCraftUpdates` | Diagnose/restore tool installation |
| Copied optional examples | Usually `Assets/DataCraftSamples` or Package Manager's selected sample location | Back up edits; avoid duplicate GUID copies |

## Back up a project before structural changes

Keep templates and instance drafts together, plus generated assets with their `.meta` files, scene assignments and your DTO/code. Preserve package manifest/lock files and access to the installed archive. A Library cache backup alone is not a full project backup.

Deleting Library normally causes a reimport, but it also removes unresolved template recovery and update diagnostics stored there. Retained itch.io archives deliberately live outside Library. Do not remove archives still referenced by UPM.

## Share a private project safely

Share commercial tool source only with appropriately licensed collaborators. Account tokens are held outside the project in supported OS secure storage or the current session; they do not belong in Git. Do not commit API secrets, private player saves or publisher signing keys.

Generated catalogs/read-only JSON and local saves are not encryption. A game's own security model, server authority, save schema migrations and cloud synchronization remain game responsibilities.
